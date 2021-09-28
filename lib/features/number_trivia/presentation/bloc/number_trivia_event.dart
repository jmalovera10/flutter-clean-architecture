part of 'number_trivia_bloc.dart';

abstract class NumberTriviaEvent extends Equatable {
  const NumberTriviaEvent();
}

class GetTriviaForConcreteNumberEvent extends NumberTriviaEvent {
  final String numberString;

  const GetTriviaForConcreteNumberEvent(this.numberString);

  @override
  List<Object?> get props => [numberString]; 
}

class GetTriviaForRandomNumberEvent extends NumberTriviaEvent {
  const GetTriviaForRandomNumberEvent();

  @override
  List<Object?> get props => []; 
}
