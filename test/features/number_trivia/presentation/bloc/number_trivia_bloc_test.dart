import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:flutter_application_1/core/error/failures.dart';
import 'package:flutter_application_1/core/usecases/usecase.dart';
import 'package:flutter_application_1/core/util/input_converter.dart';
import 'package:flutter_application_1/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_application_1/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:flutter_application_1/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:flutter_application_1/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  late NumberTriviaBloc bloc;
  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();

    bloc = NumberTriviaBloc(
        concrete: mockGetConcreteNumberTrivia,
        random: mockGetRandomNumberTrivia,
        inputConverter: mockInputConverter);
  });

  test('initial state is empty', () {
    expect(bloc.state, Empty());
  });

  group('GetTriviaForConcreteNumber', () {
    const tNumberString = '1';
    const tNumberParsed = 1;
    const tNumberTrivia = NumberTrivia(text: 'Test trivia', number: 1);
    const tParams = Params(number: tNumberParsed);

    setUp(() {
      registerFallbackValue(tParams);
    });

    void setUpMockInputConverterSuccess() {
      when(() =>
              mockInputConverter.stringToUnsignedInteger(any(that: isNotNull)))
          .thenReturn(const Right(tNumberParsed));
    }

    test(
        'should call the InputConverter to validate and convert the string to an unsigned integer',
        () async {
      setUpMockInputConverterSuccess();
      when(() =>
              mockInputConverter.stringToUnsignedInteger(any(that: isNotNull)))
          .thenReturn(Left(InvalidInputFailure()));

      bloc.add(const GetTriviaForConcreteNumberEvent(tNumberString));
      await untilCalled(() =>
          mockInputConverter.stringToUnsignedInteger(any(that: isNotNull)));

      verify(() => mockInputConverter.stringToUnsignedInteger(tNumberString));
    });

    test('should emit [Error] when the input is invalid', () async {
      when(() =>
              mockInputConverter.stringToUnsignedInteger(any(that: isNotNull)))
          .thenReturn(Left(InvalidInputFailure()));

      final expected = [const Error(message: INVALID_INPUT_FAILURE_MESSAGE)];
      expectLater(bloc.stream, emitsInOrder(expected));

      bloc.add(const GetTriviaForConcreteNumberEvent(tNumberString));
    });

    test('should get data from the concrete use case', () async {
      setUpMockInputConverterSuccess();
      when(() => mockGetConcreteNumberTrivia(any(that: isNotNull)))
          .thenAnswer((_) async => const Right(tNumberTrivia));

      bloc.add(const GetTriviaForConcreteNumberEvent(tNumberString));
      await untilCalled(
          () => mockGetConcreteNumberTrivia(any(that: isNotNull)));

      verify(() => mockGetConcreteNumberTrivia(tParams));
    });

    test('should emit [Loading, Loaded] when data is gotten successfuly',
        () async {
      setUpMockInputConverterSuccess();
      when(() => mockGetConcreteNumberTrivia(any(that: isNotNull)))
          .thenAnswer((_) async => const Right(tNumberTrivia));

      final expected = [Loading(), const Loaded(trivia: tNumberTrivia)];
      expectLater(bloc.stream, emitsInOrder(expected));

      bloc.add(const GetTriviaForConcreteNumberEvent(tNumberString));
    });

    test('should emit [Loading, Error] when getting data fails', () async {
      setUpMockInputConverterSuccess();
      when(() => mockGetConcreteNumberTrivia(any(that: isNotNull)))
          .thenAnswer((_) async => Left(ServerFailure()));

      final expected = [
        Loading(),
        const Error(message: SERVER_FAILURE_MESSAGE)
      ];
      expectLater(bloc.stream, emitsInOrder(expected));

      bloc.add(const GetTriviaForConcreteNumberEvent(tNumberString));
    });

    test(
        'should emit [Loading, Error] with a proper message for the error when getting data fails',
        () async {
      setUpMockInputConverterSuccess();
      when(() => mockGetConcreteNumberTrivia(any(that: isNotNull)))
          .thenAnswer((_) async => Left(CacheFailure()));

      final expected = [Loading(), const Error(message: CACHE_FAILURE_MESSAGE)];
      expectLater(bloc.stream, emitsInOrder(expected));

      bloc.add(const GetTriviaForConcreteNumberEvent(tNumberString));
    });
  });

  group('GetTriviaForRandomNumber', () {
    const tNumberTrivia = NumberTrivia(text: 'Test trivia', number: 1);
    final tNoParams = NoParams();

    setUp(() {
      registerFallbackValue(tNoParams);
    });

    test('should get data from the concrete use case', () async {
      when(() => mockGetRandomNumberTrivia(any(that: isNotNull)))
          .thenAnswer((_) async => const Right(tNumberTrivia));

      bloc.add(const GetTriviaForRandomNumberEvent());
      await untilCalled(() => mockGetRandomNumberTrivia(any(that: isNotNull)));

      verify(() => mockGetRandomNumberTrivia(tNoParams));
    });

    test('should emit [Loading, Loaded] when data is gotten successfuly',
        () async {
      when(() => mockGetRandomNumberTrivia(any(that: isNotNull)))
          .thenAnswer((_) async => const Right(tNumberTrivia));

      final expected = [Loading(), const Loaded(trivia: tNumberTrivia)];
      expectLater(bloc.stream, emitsInOrder(expected));

      bloc.add(const GetTriviaForRandomNumberEvent());
    });

    test('should emit [Loading, Error] when getting data fails', () async {
      when(() => mockGetRandomNumberTrivia(any(that: isNotNull)))
          .thenAnswer((_) async => Left(ServerFailure()));

      final expected = [
        Loading(),
        const Error(message: SERVER_FAILURE_MESSAGE)
      ];
      expectLater(bloc.stream, emitsInOrder(expected));

      bloc.add(const GetTriviaForRandomNumberEvent());
    });

    test(
        'should emit [Loading, Error] with a proper message for the error when getting data fails',
        () async {
      when(() => mockGetRandomNumberTrivia(any(that: isNotNull)))
          .thenAnswer((_) async => Left(CacheFailure()));

      final expected = [Loading(), const Error(message: CACHE_FAILURE_MESSAGE)];
      expectLater(bloc.stream, emitsInOrder(expected));

      bloc.add(const GetTriviaForRandomNumberEvent());
    });
  });
}
