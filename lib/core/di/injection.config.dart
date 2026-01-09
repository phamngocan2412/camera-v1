// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:connectivity_plus/connectivity_plus.dart' as _i895;
import 'package:get_it/get_it.dart' as _i174;
import 'package:http/http.dart' as _i519;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../../features/auth/data/datasource/auth_local_data_source.dart'
    as _i138;
import '../../features/auth/data/datasource/auth_remote_data_source.dart'
    as _i24;
import '../../features/auth/data/repositories/auth_repository_impl.dart'
    as _i1045;
import '../../features/auth/domain/repositories/auth_repository.dart' as _i481;
import '../../features/auth/domain/usecases/change_password.dart' as _i514;
import '../../features/auth/domain/usecases/check_auth_status.dart' as _i643;
import '../../features/auth/domain/usecases/forgot_password.dart' as _i510;
import '../../features/auth/domain/usecases/login.dart' as _i428;
import '../../features/auth/domain/usecases/logout.dart' as _i597;
import '../../features/auth/domain/usecases/register.dart' as _i480;
import '../../features/auth/domain/usecases/resend_otp.dart' as _i152;
import '../../features/auth/domain/usecases/reset_password.dart' as _i1066;
import '../../features/auth/domain/usecases/verify_otp.dart' as _i975;
import '../../features/auth/domain/usecases/verify_reset_otp.dart' as _i264;
import '../../features/auth/presentation/bloc/bloc/auth_bloc.dart' as _i137;
import '../../features/settings/presentation/bloc/settings_cubit.dart' as _i819;
import '../network/network_info.dart' as _i932;
import 'register_module.dart' as _i291;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => registerModule.prefs,
      preResolve: true,
    );
    gh.lazySingleton<_i519.Client>(() => registerModule.httpClient);
    gh.lazySingleton<_i895.Connectivity>(() => registerModule.connectivity);
    gh.lazySingleton<_i932.NetworkInfo>(
      () => _i932.NetworkInfoImpl(gh<_i895.Connectivity>()),
    );
    gh.factory<_i819.SettingsCubit>(
      () =>
          _i819.SettingsCubit(sharedPreferences: gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i138.AuthLocalDataSource>(
      () => _i138.AuthLocalDataSourceImpl(
        sharedPreferences: gh<_i460.SharedPreferences>(),
      ),
    );
    gh.lazySingleton<_i24.AuthRemoteDataSource>(
      () => _i24.AuthRemoteDataSourceImpl(client: gh<_i519.Client>()),
    );
    gh.lazySingleton<_i481.AuthRepository>(
      () => _i1045.AuthRepositoryImpl(
        remoteDataSource: gh<_i24.AuthRemoteDataSource>(),
        localDataSource: gh<_i138.AuthLocalDataSource>(),
        networkInfo: gh<_i932.NetworkInfo>(),
      ),
    );
    gh.lazySingleton<_i514.ChangePassword>(
      () => _i514.ChangePassword(gh<_i481.AuthRepository>()),
    );
    gh.lazySingleton<_i643.CheckAuthStatus>(
      () => _i643.CheckAuthStatus(gh<_i481.AuthRepository>()),
    );
    gh.lazySingleton<_i510.ForgotPassword>(
      () => _i510.ForgotPassword(gh<_i481.AuthRepository>()),
    );
    gh.lazySingleton<_i428.Login>(
      () => _i428.Login(gh<_i481.AuthRepository>()),
    );
    gh.lazySingleton<_i597.Logout>(
      () => _i597.Logout(gh<_i481.AuthRepository>()),
    );
    gh.lazySingleton<_i480.Register>(
      () => _i480.Register(gh<_i481.AuthRepository>()),
    );
    gh.lazySingleton<_i152.ResendOtp>(
      () => _i152.ResendOtp(gh<_i481.AuthRepository>()),
    );
    gh.lazySingleton<_i1066.ResetPassword>(
      () => _i1066.ResetPassword(gh<_i481.AuthRepository>()),
    );
    gh.lazySingleton<_i975.VerifyOtp>(
      () => _i975.VerifyOtp(gh<_i481.AuthRepository>()),
    );
    gh.lazySingleton<_i264.VerifyResetOtp>(
      () => _i264.VerifyResetOtp(gh<_i481.AuthRepository>()),
    );
    gh.factory<_i137.AuthBloc>(
      () => _i137.AuthBloc(
        loginUseCase: gh<_i428.Login>(),
        registerUseCase: gh<_i480.Register>(),
        forgotPasswordUseCase: gh<_i510.ForgotPassword>(),
        verifyOtpUseCase: gh<_i975.VerifyOtp>(),
        resendOtpUseCase: gh<_i152.ResendOtp>(),
        resetPasswordUseCase: gh<_i1066.ResetPassword>(),
        verifyResetOtpUseCase: gh<_i264.VerifyResetOtp>(),
        checkAuthStatusUseCase: gh<_i643.CheckAuthStatus>(),
        logoutUseCase: gh<_i597.Logout>(),
        changePasswordUseCase: gh<_i514.ChangePassword>(),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i291.RegisterModule {}
