import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/user.dart';
import '../datasource/auth_remote_data_source.dart';
import '../datasource/auth_local_data_source.dart';
import '../../../../core/errors/exceptions.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    try {
      final remoteUser = await remoteDataSource.login(email, password);
      // Cast entity to model to cache it
      // Since Login returns User entity, and Cache expects UserModel.
      // Ideally RemoteDataSource returns UserModel which extends User.
      // We can cast if we are sure, or mapper.
      // But wait, the return type of remoteDataSource.login is Future<UserModel>.
      await localDataSource.cacheUser(remoteUser as dynamic); // or as UserModel
      return Right(remoteUser);
    } on VerificationPendingException catch (e) {
      return Left(VerificationPendingFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.toString()));
    } catch (e) {
      if (await networkInfo.isConnected == false) {
        return const Left(NetworkFailure('No internet connection'));
      }
      return Left(NetworkFailure('Connection failed: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, User>> register(
    String email,
    String password,
    String firstName,
    String lastName,
    String phoneNumber,
    String countryCode,
  ) async {
    try {
      if (await networkInfo.isConnected == false) {
        // Optional: you can log this, but don't blocking it
        // print("Warning: NetworkInfo says disconnected, but proceeding anyway.");
      }
      final remoteUser = await remoteDataSource.register(
        email,
        password,
        firstName,
        lastName,
        phoneNumber,
        countryCode,
      );
      // Don't cache user here - no valid token yet
      // User will be cached after OTP verification
      return Right(remoteUser);
    } on VerificationPendingException catch (e) {
      return Left(VerificationPendingFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.toString()));
    } catch (e) {
      // If the request fails and we really have no internet, this catch block is hit.
      // We can do a secondary check here if we want to be specific, or just return the error.
      if (await networkInfo.isConnected == false) {
        return const Left(NetworkFailure('No internet connection'));
      }
      return Left(NetworkFailure('Connection failed: ${e.toString()}'));
    }
  }

  // ... (forgotPassword hidden for brevity)

  @override
  Future<Either<Failure, void>> forgotPassword(String email) async {
    try {
      await remoteDataSource.forgotPassword(email);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.toString()));
    } catch (e) {
      if (await networkInfo.isConnected == false) {
        return const Left(NetworkFailure('No internet connection'));
      }
      return Left(NetworkFailure('Connection failed: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, User>> verifyOtp(String email, String otp) async {
    try {
      // print('[DEBUG] VerifyOtp: Starting verification for $email');
      // print(
      //   '[DEBUG] NetworkInfo.isConnected: ${await networkInfo.isConnected}',
      // );

      final user = await remoteDataSource.verifyOtp(email, otp);
      // print('[DEBUG] VerifyOtp: Success! Got user with token');

      // Cache user after successful verification
      // await localDataSource.cacheUser(user); // Disabled: User requested manual login after verification

      return Right(user);
    } on ServerException catch (e) {
      // print('[ERROR] VerifyOtp ServerException: ${e.toString()}');
      return Left(ServerFailure(e.toString()));
    } catch (e) {
      // print('[ERROR] VerifyOtp Exception: $e');
      // print('[ERROR] StackTrace: $stackTrace');

      if (await networkInfo.isConnected == false) {
        return const Left(NetworkFailure('No internet connection (verified)'));
      }
      return Left(NetworkFailure('VerifyOtp failed: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> resendOtp(String email) async {
    try {
      // print('[DEBUG] ResendOtp: Starting for $email');
      await remoteDataSource.resendOtp(email);
      // print('[DEBUG] ResendOtp: Success!');
      return const Right(null);
    } on ServerException catch (e) {
      // print('[ERROR] ResendOtp ServerException: ${e.toString()}');
      return Left(ServerFailure(e.toString()));
    } catch (e) {
      // print('[ERROR] ResendOtp Exception: $e');
      // print('[ERROR] StackTrace: $stackTrace');

      if (await networkInfo.isConnected == false) {
        return const Left(NetworkFailure('No internet connection (verified)'));
      }
      return Left(NetworkFailure('ResendOtp failed: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword(
    String email,
    String otp,
    String newPassword,
  ) async {
    try {
      await remoteDataSource.resetPassword(email, otp, newPassword);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.toString()));
    } catch (e) {
      if (await networkInfo.isConnected == false) {
        return const Left(NetworkFailure('No internet connection'));
      }
      return Left(NetworkFailure('ResetPassword failed: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> verifyResetOtp(String email, String otp) async {
    try {
      await remoteDataSource.verifyResetOtp(email, otp);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.toString()));
    } catch (e) {
      if (await networkInfo.isConnected == false) {
        return const Left(NetworkFailure('No internet connection'));
      }
      return Left(NetworkFailure('VerifyResetOtp failed: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, User>> checkAuthStatus() async {
    try {
      final user = await localDataSource.getLastUser();
      if (user != null) {
        return Right(user);
      } else {
        return const Left(CacheFailure());
      }
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await localDataSource.clearCache();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> changePassword(
    String oldPassword,
    String newPassword,
  ) async {
    try {
      final userModel = await localDataSource.getLastUser();
      if (userModel == null || userModel.token.isEmpty) {
        return const Left(
          CacheFailure(),
        ); // Or ServerFailure('User not logged in')
      }

      await remoteDataSource.changePassword(
        userModel.token,
        oldPassword,
        newPassword,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.toString()));
    } catch (e) {
      if (await networkInfo.isConnected == false) {
        return const Left(NetworkFailure('No internet connection'));
      }
      return Left(NetworkFailure('ChangePassword failed: ${e.toString()}'));
    }
  }
}
