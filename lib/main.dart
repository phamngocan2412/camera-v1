import 'package:camera_v1/config/routes/app_router.dart';
import 'package:camera_v1/config/routes/app_routes.dart';
import 'package:camera_v1/core/network/network_info.dart';
import 'package:camera_v1/core/theme/app_theme.dart';
import 'package:camera_v1/features/auth/data/datasource/auth_remote_data_source.dart';
import 'package:camera_v1/features/auth/data/datasource/auth_local_data_source.dart';
import 'package:camera_v1/features/auth/data/reponsitories/auth_repository_impl.dart';
import 'package:camera_v1/features/auth/domain/usecases/login.dart';
import 'package:camera_v1/features/auth/domain/usecases/register.dart';
import 'package:camera_v1/features/auth/domain/usecases/forgot_password.dart';
import 'package:camera_v1/features/auth/domain/usecases/verify_otp.dart';
import 'package:camera_v1/features/auth/domain/usecases/resend_otp.dart';
import 'package:camera_v1/features/auth/domain/usecases/check_auth_status.dart';
import 'package:camera_v1/features/auth/domain/usecases/logout.dart';
import 'package:camera_v1/features/auth/domain/usecases/reset_password.dart';
import 'package:camera_v1/features/auth/domain/usecases/verify_reset_otp.dart';
import 'package:camera_v1/features/auth/domain/usecases/change_password.dart';
import 'package:camera_v1/features/auth/presentation/bloc/bloc/auth_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:camera_v1/features/settings/presentation/bloc/settings_cubit.dart';
import 'package:camera_v1/core/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();
  runApp(MyApp(sharedPreferences: sharedPreferences));
}

class MyApp extends StatelessWidget {
  final SharedPreferences sharedPreferences;

  const MyApp({super.key, required this.sharedPreferences});

  @override
  Widget build(BuildContext context) {
    // Initialize dependencies
    final httpClient = http.Client();
    final connectivity = Connectivity();
    final networkInfo = NetworkInfoImpl(connectivity);
    final authRemoteDataSource = AuthRemoteDataSourceImpl(client: httpClient);
    final authLocalDataSource = AuthLocalDataSourceImpl(
      sharedPreferences: sharedPreferences,
    );
    final authRepository = AuthRepositoryImpl(
      remoteDataSource: authRemoteDataSource,
      localDataSource: authLocalDataSource,
      networkInfo: networkInfo,
    );
    final loginUseCase = Login(authRepository);
    final registerUseCase = Register(authRepository);
    final forgotPasswordUseCase = ForgotPassword(authRepository);
    final verifyOtpUseCase = VerifyOtp(authRepository);
    final resendOtpUseCase = ResendOtp(authRepository);
    final checkAuthStatusUseCase = CheckAuthStatus(authRepository);
    final logoutUseCase = Logout(authRepository);
    final resetPasswordUseCase = ResetPassword(authRepository);
    final verifyResetOtpUseCase = VerifyResetOtp(authRepository);
    final changePasswordUseCase = ChangePassword(authRepository);
    final authBloc = AuthBloc(
      loginUseCase: loginUseCase,
      registerUseCase: registerUseCase,
      forgotPasswordUseCase: forgotPasswordUseCase,
      verifyOtpUseCase: verifyOtpUseCase,
      resendOtpUseCase: resendOtpUseCase,
      resetPasswordUseCase: resetPasswordUseCase,
      verifyResetOtpUseCase: verifyResetOtpUseCase,
      checkAuthStatusUseCase: checkAuthStatusUseCase,
      logoutUseCase: logoutUseCase,
      changePasswordUseCase: changePasswordUseCase,
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (context) => authBloc),
        BlocProvider<SettingsCubit>(
          create: (context) =>
              SettingsCubit(sharedPreferences: sharedPreferences),
        ),
      ],
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'Camera Security App',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: state.themeMode,
            locale: state.locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en', 'US'), Locale('vi', 'VN')],
            initialRoute: AppRoutes.splash,
            onGenerateRoute: AppRouter.onGenerateRoute,
          );
        },
      ),
    );
  }
}
