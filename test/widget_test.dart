import 'package:camera_v1/core/errors/failures.dart';
import 'package:camera_v1/core/di/injection.dart';
import 'package:camera_v1/core/usecases/usecase.dart';
import 'package:camera_v1/features/auth/domain/entities/user.dart';
import 'package:camera_v1/features/auth/domain/usecases/change_password.dart';
import 'package:camera_v1/features/auth/domain/usecases/check_auth_status.dart';
import 'package:camera_v1/features/auth/domain/usecases/forgot_password.dart';
import 'package:camera_v1/features/auth/domain/usecases/login.dart';
import 'package:camera_v1/features/auth/domain/usecases/logout.dart';
import 'package:camera_v1/features/auth/domain/usecases/register.dart';
import 'package:camera_v1/features/auth/domain/usecases/resend_otp.dart';
import 'package:camera_v1/features/auth/domain/usecases/reset_password.dart';
import 'package:camera_v1/features/auth/domain/usecases/verify_otp.dart';
import 'package:camera_v1/features/auth/domain/usecases/verify_reset_otp.dart';
import 'package:camera_v1/features/auth/presentation/bloc/bloc/auth_bloc.dart';
import 'package:camera_v1/features/settings/presentation/bloc/settings_cubit.dart';
import 'package:camera_v1/main.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Fake UseCases
class FakeLogin extends Fake implements Login {}

class FakeRegister extends Fake implements Register {}

class FakeForgotPassword extends Fake implements ForgotPassword {}

class FakeVerifyOtp extends Fake implements VerifyOtp {}

class FakeResendOtp extends Fake implements ResendOtp {}

class FakeResetPassword extends Fake implements ResetPassword {}

class FakeVerifyResetOtp extends Fake implements VerifyResetOtp {}

class FakeCheckAuthStatus extends Fake implements CheckAuthStatus {
  @override
  Future<Either<Failure, User>> call([NoParams? params]) async {
    return Left(
      ServerFailure('Auth Check Failed'),
    ); // Default to unauthenticated
  }
}

class FakeLogout extends Fake implements Logout {}

class FakeChangePassword extends Fake implements ChangePassword {}

void main() {
  setUp(() async {
    await getIt.reset();
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('App smoke test', (WidgetTester tester) async {
    // Setup Mocks
    final sharedPreferences = await SharedPreferences.getInstance();

    // Register SettingsCubit
    getIt.registerFactory<SettingsCubit>(
      () => SettingsCubit(sharedPreferences: sharedPreferences),
    );

    // Register AuthBloc with Fakes
    getIt.registerFactory<AuthBloc>(
      () => AuthBloc(
        loginUseCase: FakeLogin(),
        registerUseCase: FakeRegister(),
        forgotPasswordUseCase: FakeForgotPassword(),
        verifyOtpUseCase: FakeVerifyOtp(),
        resendOtpUseCase: FakeResendOtp(),
        resetPasswordUseCase: FakeResetPassword(),
        verifyResetOtpUseCase: FakeVerifyResetOtp(),
        checkAuthStatusUseCase: FakeCheckAuthStatus(),
        logoutUseCase: FakeLogout(),
        changePasswordUseCase: FakeChangePassword(),
      ),
    );

    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Verify that MaterialApp is present
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
