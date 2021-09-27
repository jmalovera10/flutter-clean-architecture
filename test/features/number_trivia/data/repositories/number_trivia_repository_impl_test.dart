import 'package:flutter_application_1/core/platform/network_info.dart';
import 'package:flutter_application_1/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:flutter_application_1/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:flutter_application_1/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import 'number_trivia_repository_impl_test.mocks.dart';

@GenerateMocks(
    [NumberTriviaRemoteDataSource, NumberTriviaLocalDataSource, NetworkInfo])
void main() {
  NumberTriviaRepositoryImpl repository;
  MockNumberTriviaRemoteDataSource mockRemoteDataSource;
  MockNumberTriviaLocalDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockNumberTriviaRemoteDataSource();
    mockLocalDataSource = MockNumberTriviaLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImpl(
      remoteDataSource: mockRemoteDataSource, 
      localDataSource:mockLocalDataSource, 
      networkInfo: mockNetworkInfo 
    );
  });
}
