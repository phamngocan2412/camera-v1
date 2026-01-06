import 'package:injectable/injectable.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../../core/errors/failures.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/usecases/login.dart';
import '../../../domain/usecases/register.dart';
import '../../../domain/usecases/forgot_password.dart';
import '../../../domain/usecases/verify_otp.dart';
import '../../../domain/usecases/resend_otp.dart';
import '../../../domain/usecases/reset_password.dart';
import '../../../domain/usecases/verify_reset_otp.dart';
import '../../../domain/usecases/check_auth_status.dart';
import '../../../domain/usecases/logout.dart';
import '../../../../../core/usecases/usecase.dart';

import '../../../domain/usecases/change_password.dart';

part 'auth_event.dart';
part 'auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Login loginUseCase;
  final Register registerUseCase;
  final ForgotPassword forgotPasswordUseCase;
  final VerifyOtp verifyOtpUseCase;
  final ResendOtp resendOtpUseCase;
  final ResetPassword resetPasswordUseCase;
  final VerifyResetOtp verifyResetOtpUseCase;
  final CheckAuthStatus checkAuthStatusUseCase;
  final Logout logoutUseCase;
  final ChangePassword changePasswordUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.forgotPasswordUseCase,
    required this.verifyOtpUseCase,
    required this.resendOtpUseCase,
    required this.resetPasswordUseCase,
    required this.verifyResetOtpUseCase,
    required this.checkAuthStatusUseCase,
    required this.logoutUseCase,
    required this.changePasswordUseCase,
  }) : super(AuthInitial()) {
    on<LoginEvent>(_onLoginEvent);
    on<RegisterEvent>(_onRegisterEvent);
    on<ForgotPasswordEvent>(_onForgotPasswordEvent);
    on<VerifyOtpEvent>(_onVerifyOtpEvent);
    on<ResendOtpEvent>(_onResendOtpEvent);
    on<ResetPasswordEvent>(_onResetPasswordEvent);
    on<VerifyResetOtpEvent>(_onVerifyResetOtpEvent);
    on<CheckAuthStatusEvent>(_onCheckAuthStatusEvent);
    on<LogoutEvent>(_onLogoutEvent);
    on<ChangePasswordEvent>(_onChangePasswordEvent);
  }

  Future<void> _onLogoutEvent(
    LogoutEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    await logoutUseCase(NoParams());
    emit(AuthInitial());
  }

  Future<void> _onCheckAuthStatusEvent(
    CheckAuthStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final failureOrUser = await checkAuthStatusUseCase();
    failureOrUser.fold(
      (failure) => emit(AuthInitial()), // Stay at initial or login screen
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  Future<void> _onVerifyOtpEvent(
    VerifyOtpEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final failureOrUser = await verifyOtpUseCase(
      VerifyOtpParams(email: event.email, otp: event.code),
    );
    failureOrUser.fold(
      (failure) => emit(AuthError(_mapFailureToMessage(failure))),
      (user) => emit(
        const VerificationSuccess('Verification successful! Please login.'),
      ),
    );
  }

  Future<void> _onResendOtpEvent(
    ResendOtpEvent event,
    Emitter<AuthState> emit,
  ) async {
    final failureOrSuccess = await resendOtpUseCase(
      ResendOtpParams(email: event.email),
    );
    // We probably don't want to show full screen loading for resend, maybe just a toast/snackbar.
    // But since we are inside Bloc, we communicate via state.
    // If we emit error, it shows snackbar.
    failureOrSuccess.fold(
      (failure) => emit(AuthError(_mapFailureToMessage(failure))),
      (_) {
        // success, maybe do nothing or emit a transient success state?
        // keeping it simple, user just sees the timer.
      },
    );
  }

  Future<void> _onLoginEvent(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final failureOrUser = await loginUseCase(
      LoginParams(email: event.email, password: event.password),
    );
    failureOrUser.fold((failure) {
      if (failure is VerificationPendingFailure) {
        emit(VerificationRequired(email: event.email));
      } else {
        emit(AuthError(_mapFailureToMessage(failure)));
      }
    }, (user) => emit(AuthAuthenticated(user)));
  }

  Future<void> _onRegisterEvent(
    RegisterEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final failureOrUser = await registerUseCase(
      RegisterParams(
        email: event.email,
        password: event.password,
        firstName: event.firstName,
        lastName: event.lastName,
        phoneNumber: event.phoneNumber,
        countryCode: event.countryCode,
      ),
    );
    failureOrUser.fold((failure) {
      if (failure is VerificationPendingFailure) {
        emit(VerificationRequired(email: event.email));
      } else {
        emit(AuthError(_mapFailureToMessage(failure)));
      }
    }, (user) => emit(VerificationRequired(email: user.email)));
  }

  Future<void> _onForgotPasswordEvent(
    ForgotPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final failureOrSuccess = await forgotPasswordUseCase(
      ForgotPasswordParams(email: event.email),
    );
    failureOrSuccess.fold(
      (failure) => emit(AuthError(_mapFailureToMessage(failure))),
      (_) => emit(
        const ForgotPasswordSuccess('Reset code has been sent to your email'),
      ),
    );
  }

  Future<void> _onResetPasswordEvent(
    ResetPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final failureOrSuccess = await resetPasswordUseCase(
      ResetPasswordParams(
        email: event.email,
        otp: event.otp,
        newPassword: event.newPassword,
      ),
    );
    failureOrSuccess.fold(
      (failure) => emit(AuthError(_mapFailureToMessage(failure))),
      (_) => emit(
        const ResetPasswordSuccess(
          'Password has been reset successfully. Please login.',
        ),
      ),
    );
  }

  Future<void> _onVerifyResetOtpEvent(
    VerifyResetOtpEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final failureOrSuccess = await verifyResetOtpUseCase(
      VerifyResetOtpParams(email: event.email, otp: event.otp),
    );
    failureOrSuccess.fold(
      (failure) => emit(AuthError(_mapFailureToMessage(failure))),
      (_) => emit(VerifyResetOtpSuccess(email: event.email, otp: event.otp)),
    );
  }

  Future<void> _onChangePasswordEvent(
    ChangePasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    final currentState = state;
    emit(AuthLoading());

    final failureOrSuccess = await changePasswordUseCase(
      ChangePasswordParams(
        oldPassword: event.oldPassword,
        newPassword: event.newPassword,
      ),
    );

    failureOrSuccess.fold(
      (failure) {
        if (currentState is AuthAuthenticated) {
          emit(
            currentState.copyWith(
              changePasswordMessage: _mapFailureToMessage(failure),
              isChangePasswordError: true,
            ),
          );
        } else {
          emit(AuthError(_mapFailureToMessage(failure)));
        }
      },
      (_) {
        if (currentState is AuthAuthenticated) {
          emit(
            currentState.copyWith(
              changePasswordMessage: 'Password changed successfully',
              isChangePasswordError: false,
            ),
          );
        } else {
          // If for some reason we lost state or were not authenticated (should not happen)
          emit(AuthInitial());
        }
      },
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure _:
        return failure.message ?? 'Server Failed';
      case CacheFailure _:
        return 'Cache Error';
      case NetworkFailure _:
        return failure.message ?? 'Network Error';
      default:
        return failure.message ?? 'Unexpected Error';
    }
  }
}
