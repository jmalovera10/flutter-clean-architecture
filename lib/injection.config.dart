// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart' as _i1;
import 'package:http/http.dart' as _i3;
import 'package:injectable/injectable.dart' as _i2;
import 'package:shared_preferences/shared_preferences.dart' as _i8;

import 'core/external_libraries/external_libraries.module.dart' as _i15;
import 'core/network/network_checker.dart' as _i5;
import 'core/network/network_info.dart' as _i6;
import 'core/util/input_converter.dart' as _i4;
import 'features/number_trivia/data/datasources/number_trivia_local_datasource.dart'
    as _i9;
import 'features/number_trivia/data/datasources/number_trivia_remote_data_source.dart'
    as _i7;
import 'features/number_trivia/data/repositories/number_trivia_repository_impl.dart'
    as _i11;
import 'features/number_trivia/domain/repositories/number_trivia_repository.dart'
    as _i10;
import 'features/number_trivia/domain/usecases/get_concrete_number_trivia.dart'
    as _i12;
import 'features/number_trivia/domain/usecases/get_random_number_trivia.dart'
    as _i13;
import 'features/number_trivia/presentation/bloc/number_trivia_bloc.dart'
    as _i14; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
Future<_i1.GetIt> $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) async {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final externalLibrariesModule = _$ExternalLibrariesModule();
  gh.lazySingleton<_i3.Client>(() => externalLibrariesModule.httpClient);
  gh.lazySingleton<_i4.InputConverter>(() => _i4.InputConverter());
  gh.lazySingleton<_i5.NetworkChecker>(() => _i5.NetworkCheckerImpl());
  gh.lazySingleton<_i6.NetworkInfo>(
      () => _i6.NetworkInfoImpl(get<_i5.NetworkChecker>()));
  gh.lazySingleton<_i7.NumberTriviaRemoteDataSource>(
      () => _i7.NumberTriviaRemoteDataSourceImpl(client: get<_i3.Client>()));
  await gh.factoryAsync<_i8.SharedPreferences>(
      () => externalLibrariesModule.prefs,
      preResolve: true);
  gh.lazySingleton<_i9.NumberTriviaLocalDataSource>(() =>
      _i9.NumberTriviaLocalDataSourceImpl(
          sharedPreferences: get<_i8.SharedPreferences>()));
  gh.lazySingleton<_i10.NumberTriviaRepository>(() =>
      _i11.NumberTriviaRepositoryImpl(
          remoteDataSource: get<_i7.NumberTriviaRemoteDataSource>(),
          localDataSource: get<_i9.NumberTriviaLocalDataSource>(),
          networkInfo: get<_i6.NetworkInfo>()));
  gh.lazySingleton<_i12.GetConcreteNumberTrivia>(
      () => _i12.GetConcreteNumberTrivia(get<_i10.NumberTriviaRepository>()));
  gh.lazySingleton<_i13.GetRandomNumberTrivia>(
      () => _i13.GetRandomNumberTrivia(get<_i10.NumberTriviaRepository>()));
  gh.factory<_i14.NumberTriviaBloc>(() => _i14.NumberTriviaBloc(
      concrete: get<_i12.GetConcreteNumberTrivia>(),
      random: get<_i13.GetRandomNumberTrivia>(),
      inputConverter: get<_i4.InputConverter>()));
  return get;
}

class _$ExternalLibrariesModule extends _i15.ExternalLibrariesModule {}
