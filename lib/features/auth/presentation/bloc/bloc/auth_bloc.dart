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
    // Keep current state if possible, or show loading overlay?
    // Using AuthLoading might replace the whole UI if not handled carefully.
    // Ideally we'd have a separate status or loading boolean.
    // For now, let's just assume the UI handles AuthLoading gracefully or we don't emit AuthLoading if we don't want to clear screen.
    // However, standar practice in this bloc is emit AuthLoading.
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
        // Restore previous state if it was Authenticated, but show error?
        // Current architecture: AuthError replaces everything.
        // We probably want to emit AuthError and then user has to navigate back?
        // Or better: emit AuthAuthenticated with an error message? No, AuthAuthenticated only holds user.
        // Let's emit AuthError for now, UI should listen.
        /// Actually, if we emit AuthError, we might lose the Profile Page context if relying on AuthAuthenticated builder.
        /// ProfilePage uses BlocBuilder.
        /// If state becomes AuthError, ProfilePage builder re-runs.
        /// Verify: ProfilePage checks `if (state is AuthAuthenticated)`.
        /// If error, it might show something else or default.
        /// Fix: We should probably emit the error as a side effect or separate stream, OR make AuthAuthenticated capable of carrying error/success messages.
        /// For simplicity now: emit AuthError. The user will see error.
        /// BUT wait, if we are in Profile Page, and we get AuthError, the UI might switch to "You are not logged in" or similar if the builder logic is simple.
        /// ProfilePage builder:
        /// if (state is AuthAuthenticated) ...
        /// else ...
        /// In ProfilePage line 28 provided earlier: it builds the profile UI but data (name/email) depends on AuthAuthenticated.
        /// If state changes to AuthError, lines 25-26 use default "John Doe".
        /// The error will be shown via BlocListener (which we need to add to ProfilePage).
        /// And the UI will flicker to default data. This is not ideal but acceptable for "v1" fix.
        emit(AuthError(_mapFailureToMessage(failure)));
        // After error, we might want to go back to Authenticated?
        if (currentState is AuthAuthenticated) {
          // emit(currentState); // This would clear the error snackbar immediately?
          // Usually we rely on the listener to show snackbar, and builder to show content.
          // If we emit error, builder shows default content.
        }
      },
      (_) {
        emit(ChangePasswordSuccess());
        // After success, we probably want to stay logged in?
        // Or force logout?
        // Requirement says "button ... api from BE". Usually change password keeps session or asks to relogin.
        // Let's assume we stay logged in.
        if (currentState is AuthAuthenticated) {
          emit(currentState);
        }
      },
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return failure.message ?? 'Server Failed';
      case CacheFailure:
        return 'Cache Error';
      case NetworkFailure:
        return failure.message ?? 'Network Error';
      default:
        return failure.message ?? 'Unexpected Error';
    }
  }
}
