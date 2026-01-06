import 'dart:developer' as developer;

import 'package:camera_v1/config/routes/app_router.dart';
import 'package:camera_v1/config/routes/app_routes.dart';
import 'package:camera_v1/core/di/injection.dart';
import 'package:camera_v1/core/presentation/pages/setup_error_app.dart';
import 'package:camera_v1/core/theme/app_theme.dart';
import 'package:camera_v1/features/auth/presentation/bloc/bloc/auth_bloc.dart';
import 'package:camera_v1/features/settings/presentation/bloc/settings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:camera_v1/core/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await configureDependencies();
    runApp(const MyApp());
  } catch (e, stackTrace) {
    developer.log(
      'Initialization failed',
      error: e,
      stackTrace: stackTrace,
      name: 'main',
    );
    runApp(SetupErrorApp(error: e));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (context) => getIt<AuthBloc>()),
        BlocProvider<SettingsCubit>(
          create: (context) => getIt<SettingsCubit>(),
        ),
      ],
      child: Builder(
        builder: (context) {
          // Select only the specific properties needed for MaterialApp
          // to avoid rebuilding the entire tree on unrelated state changes.
          final themeMode = context.select(
            (SettingsCubit cubit) => cubit.state.themeMode,
          );
          final locale = context.select(
            (SettingsCubit cubit) => cubit.state.locale,
          );

          return MaterialApp(
            title: 'Camera Security App',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,
            locale: locale,
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
