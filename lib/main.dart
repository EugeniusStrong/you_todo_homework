import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:you_todo_homework/pages/start_page.dart';

import 'bloc/notes_bloc.dart';
import 'bloc/notes_event.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter BLOC + SQL',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.black54,
          secondary: Colors.purple,
        ),
        textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.purple)),
      ),
      home: BlocProvider<NotesBloc>(
        create: (context) => NotesBloc()..add(NotesAppStarted()),
        child: const StartScreen(),
      ),
    );
  }
}
