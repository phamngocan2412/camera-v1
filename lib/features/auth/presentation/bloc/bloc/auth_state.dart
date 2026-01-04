part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final User user;

  const AuthAuthenticated(this.user);

  @override
  List<Object> get props => [user];
}

class VerificationRequired extends AuthState {
  final String email;
  const VerificationRequired({required this.email});
  @override
  List<Object> get props => [email];
}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object> get props => [message];
}

class ForgotPasswordSuccess extends AuthState {
  final String message;

  const ForgotPasswordSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class VerificationSuccess extends AuthState {
  final String message;
  const VerificationSuccess(this.message);
  @override
  List<Object> get props => [message];
}

class ResetPasswordSuccess extends AuthState {
  final String message;
  const ResetPasswordSuccess(this.message);
  @override
  List<Object> get props => [message];
}

class VerifyResetOtpSuccess extends AuthState {
  final String email;
  final String otp;

  const VerifyResetOtpSuccess({required this.email, required this.otp});

  @override
  List<Object> get props => [email, otp];
}

class ChangePasswordSuccess extends AuthState {
  @override
  List<Object> get props => [];
}
