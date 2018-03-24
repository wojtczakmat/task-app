import 'package:flutter/material.dart';

import '../models/task.dart';
import '../models/taskOrder.dart';
import 'TaskListItem.dart';

class TaskList extends StatelessWidget {
  final List<Task> _tasks;
  final DeleteTaskAction _deleteTask;
  final EditTaskAction _editTask;
  final TaskOrder _taskOrder;

  TaskList(this._tasks, this._editTask, this._deleteTask, this._taskOrder) {
    switch (_taskOrder) {
      case TaskOrder.Ascending:
        _tasks.sort((t1, t2) => t1.title.compareTo(t2.title));
        break;
      case TaskOrder.Descending:
        _tasks.sort((t1, t2) => t2.title.compareTo(t1.title));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      itemBuilder: (context, index) => new TaskListItem(_tasks[index], this._editTask, this._deleteTask),
      itemCount: _tasks.length,
    );
  }
}