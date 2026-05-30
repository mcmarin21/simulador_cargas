import 'package:flutter/material.dart';
import 'package:simulador_cargas/ui/screens/app_home.dart';
// import 'package:simulador_cargas/ui/screens/app_home.dart';
import 'package:simulador_cargas/ui/screens/test.dart';
import 'ui/theme/util.dart';
import 'ui/theme/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;

    TextTheme textTheme = createTextTheme(
      context,
      "Red Hat Text",
      "Red Hat Display",
    );

    MaterialTheme theme = MaterialTheme(textTheme);

    return MaterialApp(
      title: 'Flutter Demo',
      theme: brightness == Brightness.light ? theme.light() : theme.dark(),
      home: const AppHome(),
    );
  }
}