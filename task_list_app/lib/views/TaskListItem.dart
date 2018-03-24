import 'package:flutter/material.dart';
import '../models/task.dart';

typedef void DeleteTaskAction(BuildContext context, Task task);
typedef void EditTaskAction(BuildContext context, Task task);

class TaskListItem extends  StatelessWidget {
  final Task _task;
  final DeleteTaskAction deleteAction;
  final EditTaskAction editAction;
  
  TaskListItem(this._task, this.editAction, this.deleteAction);

  @override
  Widget build(BuildContext context) {
    return new Dismissible(
      child: new ListTile(
        title: new Text(_task.title),
        subtitle: new Text(_task.description),
        leading: new CircleAvatar(
          child: new Text(_task.title[0]),
        ),
        onTap: () {
          this.editAction(context, _task);
        }
      ),
      key: new Key(_task.id),
      direction: DismissDirection.horizontal,
      onDismissed: (_) {
        this.deleteAction(context, _task); 
      }
    );
  }
}