import 'package:flutter/material.dart';

import 'views/TasksPage.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  MyApp() {
    MaterialPageRoute.debugEnableFadingRoutes = true;
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Tasky',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new TasksPage()
    );
  }
}
