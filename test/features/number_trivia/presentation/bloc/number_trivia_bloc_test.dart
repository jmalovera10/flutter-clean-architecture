import 'dart:math';

import 'package:dartz/dartz.dart';
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

    bloc = NumberTriviaBloc(Empty(),
        concrete: mockGetConcreteNumberTrivia,
        random: mockGetRandomNumberTrivia,
        inputConverter: mockInputConverter);
  });

  test('initial state is empty', () {
    expect(bloc.state, Empty());
  });

  group('GetTriviaForConcreteNumber', () {
    final tNumberString = '1';
    final tNumberParsed = 1;
    final tNumberTrivia = NumberTrivia(text: 'Test trivia', number: 1);

    test(
        'should call the InputConverter to validate and convert the string to an unsigned integer',
        () async {
      when(() =>
              mockInputConverter.stringToUnsignedInteger(any(that: isNotNull)))
          .thenReturn(Right(tNumberParsed));

      bloc.add(GetTriviaForConcreteNumberEvent(tNumberString));
      await untilCalled(() =>
          mockInputConverter.stringToUnsignedInteger(any(that: isNotNull)));

      verify(() => mockInputConverter.stringToUnsignedInteger(tNumberString));
    });

    test('should emit [Error] when the input is invalid', () async {
      when(() =>
              mockInputConverter.stringToUnsignedInteger(any(that: isNotNull)))
          .thenReturn(Left(InvalidInputFailure()));

      bloc.add(GetTriviaForConcreteNumberEvent(tNumberString));

      final expected = [
        const Error(message: INVALID_INPUT_FAILURE_MESSAGE)
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      bloc.add(GetTriviaForConcreteNumberEvent(tNumberString));
    });
  });
}
