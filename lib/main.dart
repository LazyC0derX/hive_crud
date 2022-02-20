import 'package:flutter/material.dart';
import 'package:hive_crud/screens/notes_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'model/notes.dart';
import 'repository/box_repository.dart';


void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(NoteAdapter());
  await BoxRepository.openBox();
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'CRUD',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return const NoteScreen();
  }
}
