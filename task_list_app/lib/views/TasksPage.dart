import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import '../dataSources/taskds.dart';
import '../models/task.dart';
import '../models/taskOrder.dart';
import 'EditTaskPage.dart';
import 'TaskList.dart';

class TasksPage extends StatefulWidget {
  @override
  TasksPageState createState() {
    return new TasksPageState();
  }
}

class TasksPageState extends State<TasksPage> {
  TaskDataSource _taskDS = new TaskDataSource();

  List<Task> _tasks;
  TaskOrder _taskOrder;

  bool _isLoading = false;

  static const platform = const MethodChannel('task_app');

  TasksPageState() {
    platform.setMethodCallHandler((call) async {
      if (call.method == 'loadPreference') {
        updatePreference(call.arguments);
      }
    });
  }

  @override
    void initState() {
      // TODO: implement initState
      super.initState();

      _tasks = new List();
      _isLoading = true;
      _loadPreferences();

      _taskDS.init()
        .then((_) async {
          var t = await getTasks();
          setState(() {
            _tasks = t;
            _isLoading = false;
          });
        });
    }

  @override
  Widget build(BuildContext context) {
    var body = new TaskList(_tasks, presentEditTask, deleteTask, _taskOrder);
    var loading = new Center(child: const CircularProgressIndicator());

    return new Scaffold(
      appBar: new AppBar(
        title: const Text('Tasky'),
        actions: <Widget>[
          new IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () async => await platform.invokeMethod('showPreferences')
          )
        ],
      ),
      body: _isLoading ? loading : body,
      floatingActionButton: new FloatingActionButton(
        onPressed: () => presentAddTask(context),
        child: const Icon(Icons.add)
      )
    );
  }

  Future _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var order = prefs.get('sort');

    setState(() {
      _taskOrder = TaskOrder.values[int.parse(order ?? '0', onError: (_) => 0)];
    });
  }

  Future<List<Task>> getTasks() async {
    return await _taskDS.getAll();
  }

  void presentAddTask(BuildContext context) async {
    Task task = await Navigator.of(context).push(new MaterialPageRoute<Task>(
      builder: (BuildContext context) {
        return new EditTaskPage(null);
      },
    ));
    if (task != null) {
      await _addTask(task);
    }
  }

  void _addTask(Task task) async {
    setState(() => _isLoading = true);
      await _taskDS.add(task);
      setState(() {
        _tasks.add(task);
        _isLoading = false;
      });
  }

  void presentEditTask(BuildContext context, Task toEdit) async {
    Task task = await Navigator.of(context).push(new MaterialPageRoute<Task>(
      builder: (BuildContext context) {
        return new EditTaskPage(toEdit);
      }
    ));
    if (task != null) {
      setState(() => _isLoading = true);
      await _taskDS.update(task);

      var toUpdate = _tasks.where((x) => x.id == task.id).first;

      setState(() {
        toUpdate.title = task.title;
        toUpdate.description = task.description;

        _isLoading = false;
      });
    }
  }

  void deleteTask(BuildContext context, Task task) async {
    if (_tasks.contains(task)) {
      bool undo = false;
      bool deleted = false;

      Scaffold.of(context).showSnackBar(new SnackBar(
        content: new Text('Task "${task.title}" has been deleted'),
        action: new SnackBarAction(
          label: 'UNDO',
          onPressed: () {
            undo = true;
            if (deleted)
              _addTask(task);
          },
        ),
      ));

      if (undo)
        return;
      
      setState(() => _isLoading = true);
      await _taskDS.delete(task);
      setState(() {
        _tasks.remove(task);
        _isLoading = false;
      });
      deleted = true;
    }
  }

  void updatePreference(String arg) async {
    String key, value;

    if (!arg.startsWith("flutter.")) {
      return;
    }

    key = arg.split(':')[0];
    
    key = key.split('flutter.')[1];

    value = arg.split(':')[1];

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);

    _loadPreferences();
  }
}