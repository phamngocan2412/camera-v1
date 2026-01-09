import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> login(String email, String password);
  Future<Either<Failure, User>> register(
    String email,
    String password,
    String firstName,
    String lastName,
    String phoneNumber,
    String countryCode,
  );
  Future<Either<Failure, void>> forgotPassword(String email);
  Future<Either<Failure, User>> verifyOtp(String email, String otp);
  Future<Either<Failure, void>> resendOtp(String email);
  Future<Either<Failure, void>> resetPassword(
    String email,
    String otp,
    String newPassword,
  );
  Future<Either<Failure, void>> verifyResetOtp(String email, String otp);
  Future<Either<Failure, User>> checkAuthStatus();
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, void>> changePassword(
    String oldPassword,
    String newPassword,
  );
}
