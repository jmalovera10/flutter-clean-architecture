import 'dart:convert';

import 'package:flutter_application_1/core/error/exception.dart';
import 'package:flutter_application_1/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:flutter_application_1/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late NumberTriviaRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });

  void setUpMockHttpClientSuccess200() {
    when(() => mockHttpClient.get(any(that: isNotNull),
            headers: any(named: 'headers', that: isNotNull)))
        .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }

  void setUpMockHttpClientFailure404() {
    when(() => mockHttpClient.get(any(that: isNotNull),
            headers: any(that: isNotNull, named: 'headers')))
        .thenAnswer((_) async => http.Response('Something went wrong', 404));
  }

  group('getConcreteNumberTrivia', () {
    const tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
    final tUri = Uri.parse('http://numbersapi.com/$tNumber');

    setUp(() {
      registerFallbackValue(tUri);
    });

    test('''should perform a GET request on a URL with a number being 
        the endpoint and with application/json header''', () async {
      setUpMockHttpClientSuccess200();

      await dataSource.getConcreteNumberTrivia(tNumber);

      verify(() => mockHttpClient
          .get(tUri, headers: {'Content-Type': 'application/json'}));
    });

    test('should return NumberTrivia when the response code is 200 (success)',
        () async {
      setUpMockHttpClientSuccess200();

      final result = await dataSource.getConcreteNumberTrivia(tNumber);

      expect(result, equals(tNumberTriviaModel));
    });

    test(
        'should return a ServerException when the repsonse code is 404 or other',
        () async {
      setUpMockHttpClientFailure404();

      final call = dataSource.getConcreteNumberTrivia;

      expect(
          () => call(tNumber), throwsA(const TypeMatcher<ServerException>()));
    });
  });

  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
    final tUri = Uri.parse('http://numbersapi.com/random');

    setUp(() {
      registerFallbackValue(tUri);
    });

    test('''should perform a GET request on a URL with a number being 
        the endpoint and with application/json header''', () async {
      setUpMockHttpClientSuccess200();

      await dataSource.getRandomNumberTrivia();

      verify(() => mockHttpClient
          .get(tUri, headers: {'Content-Type': 'application/json'}));
    });

    test('should return NumberTrivia when the response code is 200 (success)',
        () async {
      setUpMockHttpClientSuccess200();

      final result = await dataSource.getRandomNumberTrivia();

      expect(result, equals(tNumberTriviaModel));
    });

    test(
        'should return a ServerException when the repsonse code is 404 or other',
        () async {
      setUpMockHttpClientFailure404();

      final call = dataSource.getRandomNumberTrivia;

      expect(
          () => call(), throwsA(const TypeMatcher<ServerException>()));
    });
  });
}
