import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/number_trivia/presentation/pages/number_trivia_page.dart';
import 'package:injectable/injectable.dart';
import 'injection.dart';

void main() async {
  await configureInjection(Environment.prod);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Material App',
        theme: ThemeData(
            primaryColor: Colors.green.shade800,
            accentColor: Colors.green.shade600),
        home: const NumberTriviaPage());
  }
}
