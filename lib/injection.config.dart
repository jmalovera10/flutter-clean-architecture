// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart' as _i1;
import 'package:http/http.dart' as _i9;
import 'package:injectable/injectable.dart' as _i2;
import 'package:shared_preferences/shared_preferences.dart' as _i7;

import 'core/network/network_checker.dart' as _i4;
import 'core/network/network_info.dart' as _i5;
import 'core/util/input_converter.dart' as _i3;
import 'features/number_trivia/data/datasources/number_trivia_local_datasource.dart'
    as _i6;
import 'features/number_trivia/data/datasources/number_trivia_remote_data_source.dart'
    as _i8;
import 'features/number_trivia/data/repositories/number_trivia_repository_impl.dart'
    as _i11;
import 'features/number_trivia/domain/repositories/number_trivia_repository.dart'
    as _i10;
import 'features/number_trivia/domain/usecases/get_concrete_number_trivia.dart'
    as _i12;
import 'features/number_trivia/domain/usecases/get_random_number_trivia.dart'
    as _i13;
import 'features/number_trivia/presentation/bloc/number_trivia_bloc.dart'
    as _i14;

const String _prod = 'prod';
// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  gh.lazySingleton<_i3.InputConverter>(() => _i3.InputConverter());
  gh.lazySingleton<_i4.NetworkChecker>(() => _i4.NetworkCheckerImpl(),
      registerFor: {_prod});
  gh.lazySingleton<_i5.NetworkInfo>(
      () => _i5.NetworkInfoImpl(get<_i4.NetworkChecker>()));
  gh.lazySingleton<_i6.NumberTriviaLocalDataSource>(() =>
      _i6.NumberTriviaLocalDataSourceImpl(
          sharedPreferences: get<_i7.SharedPreferences>()));
  gh.lazySingleton<_i8.NumberTriviaRemoteDataSource>(
      () => _i8.NumberTriviaRemoteDataSourceImpl(client: get<_i9.Client>()));
  gh.lazySingleton<_i10.NumberTriviaRepository>(() =>
      _i11.NumberTriviaRepositoryImpl(
          remoteDataSource: get<_i8.NumberTriviaRemoteDataSource>(),
          localDataSource: get<_i6.NumberTriviaLocalDataSource>(),
          networkInfo: get<_i5.NetworkInfo>()));
  gh.lazySingleton<_i12.GetConcreteNumberTrivia>(
      () => _i12.GetConcreteNumberTrivia(get<_i10.NumberTriviaRepository>()));
  gh.lazySingleton<_i13.GetRandomNumberTrivia>(
      () => _i13.GetRandomNumberTrivia(get<_i10.NumberTriviaRepository>()));
  gh.factory<_i14.NumberTriviaBloc>(() => _i14.NumberTriviaBloc(
      concrete: get<_i12.GetConcreteNumberTrivia>(),
      random: get<_i13.GetRandomNumberTrivia>(),
      inputConverter: get<_i3.InputConverter>()));
  return get;
}
