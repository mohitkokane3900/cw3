import 'package:flutter/material.dart';
import 'task_page.dart';

void main() {
  runApp(const CW3App());
}

class CW3App extends StatelessWidget {
  const CW3App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CW3 Task Manager',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const TaskPage(),
    );
  }
}
