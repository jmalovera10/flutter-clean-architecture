import 'package:mocktail/mocktail.dart';
import 'dart:convert';

import 'package:flutter_application_1/core/error/exception.dart';
import 'package:flutter_application_1/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:flutter_application_1/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late NumberTriviaLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = NumberTriviaLocalDataSourceImpl(
        sharedPreferences: mockSharedPreferences);
  });

  group('getLastNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia_cached.json')));

    test(
        'should return NumberTrivia from SharedPreferences when there is one in the cache',
        () async {
      when(()=> mockSharedPreferences.getString(any(that: isNotNull)))
          .thenReturn(fixture('trivia_cached.json'));

      final result = await dataSource.getLastNumberTrivia();

      verify(()=> mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA));
      expect(result, equals(tNumberTriviaModel));
    });

    test('should throw a CacheException when there is not a cached value',
        () async {
      when(()=> mockSharedPreferences.getString(any(that: isNotNull))).thenReturn(null);

      final call = dataSource.getLastNumberTrivia;

      expect(() => call(), throwsA(const TypeMatcher<CacheException>()));
    });
  });
  group('getLastNumberTrivia', () {
    const tNumberTriviaModel =
        NumberTriviaModel(text: 'Test Trivia', number: 1);

    test('should call SharedPreferences to cache the data', () async {
      when(()=> mockSharedPreferences.setString(any(that: isNotNull), any(that: isNotNull)))
          .thenAnswer((invocation) => Future(() => true));

      dataSource.cacheNumberTrivia(tNumberTriviaModel);

      final expectedJsonString = json.encode(tNumberTriviaModel.toJson());
      verify(()=> mockSharedPreferences.setString(
          CACHED_NUMBER_TRIVIA, expectedJsonString));
    });
  });
}
