import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:flutter_application_1/injection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Number Trivia')),
      body: buildBody(context),
    );
  }

  BlocProvider<NumberTriviaBloc> buildBody(BuildContext context) =>
      BlocProvider(
        create: (_) => getIt<NumberTriviaBloc>(),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(children: <Widget>[
              const SizedBox(
                height: 10,
              ),
              // Top half
              BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                builder: (context, state) {
                  if (state is Empty) {
                    return MessageDisplay(
                      message: 'Start searching!',
                    );
                  } else if (state is Loading) {
                    return MessageDisplay(message: '');
                  } else if (state is Loaded) {
                    return MessageDisplay(message: '');
                  } else if (state is Error) {
                    return MessageDisplay(message: state.message);
                  }
                  return MessageDisplay(
                    message: '',
                  );
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                children: <Widget>[
                  const Placeholder(
                    fallbackHeight: 40,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: const <Widget>[
                      Expanded(
                          child: Placeholder(
                        fallbackHeight: 30,
                      )),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: Placeholder(
                        fallbackHeight: 30,
                      ))
                    ],
                  )
                ],
              )
            ]),
          ),
        ),
      );
}

class MessageDisplay extends StatelessWidget {
  late String message;

  MessageDisplay({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      child: Center(
        child: SingleChildScrollView(
          child: Text(
            message,
            style: const TextStyle(fontSize: 25),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}
