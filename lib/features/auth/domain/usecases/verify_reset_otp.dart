import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

@lazySingleton
class VerifyResetOtp implements UseCase<void, VerifyResetOtpParams> {
  final AuthRepository repository;

  VerifyResetOtp(this.repository);

  @override
  Future<Either<Failure, void>> call(VerifyResetOtpParams params) async {
    return await repository.verifyResetOtp(params.email, params.otp);
  }
}

class VerifyResetOtpParams extends Equatable {
  final String email;
  final String otp;

  const VerifyResetOtpParams({required this.email, required this.otp});

  @override
  List<Object> get props => [email, otp];
}
