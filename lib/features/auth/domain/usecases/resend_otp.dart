import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

@lazySingleton
class ResendOtp implements UseCase<void, ResendOtpParams> {
  final AuthRepository repository;

  ResendOtp(this.repository);

  @override
  Future<Either<Failure, void>> call(ResendOtpParams params) async {
    return await repository.resendOtp(params.email);
  }
}

class ResendOtpParams extends Equatable {
  final String email;

  const ResendOtpParams({required this.email});

  @override
  List<Object> get props => [email];
}
