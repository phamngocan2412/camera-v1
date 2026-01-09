import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/errors/failures.dart';

@lazySingleton
class Register implements UseCase<User, RegisterParams> {
  final AuthRepository repository;

  Register(this.repository);

  @override
  Future<Either<Failure, User>> call(RegisterParams params) async {
    return await repository.register(
      params.email,
      params.password,
      params.firstName,
      params.lastName,
      params.phoneNumber,
      params.countryCode,
    );
  }
}

class RegisterParams extends Equatable {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String countryCode;

  const RegisterParams({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.countryCode,
  });

  @override
  List<Object> get props => [
    email,
    password,
    firstName,
    lastName,
    phoneNumber,
    countryCode,
  ];
}
