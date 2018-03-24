import 'package:flutter/material.dart';

import '../models/task.dart';

class EditTaskPage extends StatefulWidget {
  Task _task;
  bool isNew() => _task == null;

  EditTaskPage(this._task);

  @override
  EditTaskPageState createState() {
    return new EditTaskPageState();
  }
}

class EditTaskPageState extends State<EditTaskPage> {
  final TextEditingController titleController = new TextEditingController();
  final TextEditingController descController = new TextEditingController();

  @override
    void initState() {
      super.initState();

      if (widget._task != null) {
        titleController.text = widget._task.title;
        descController.text = widget._task.description;
      }
    }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.isNew() ? 'Add new task' : 'Edit task') ,
        actions: <Widget>[
          new IconButton(
            icon: const Icon(Icons.note_add),
            onPressed: () => finishWithTask(context),
          )
        ],
      ),
      body: new Column(
        children: <Widget>[
          new ListTile(
            leading: const Icon(Icons.title),
            title: new TextField(
              decoration: const InputDecoration(hintText: "Title"),
              maxLines: 1,
              controller: titleController,
            )
          ),
          const Divider(height: 1.0),
          new ListTile(
            leading: const Icon(Icons.description),
            title: new TextField(
              decoration: const InputDecoration(hintText: "Description"),
              maxLines: 6,
              controller: descController,
            )
          ),
        ]
      )
    );
  }

  void finishWithTask(BuildContext context) {
    var task = new Task(titleController.text, descController.text);

    if (widget._task != null) {
      task.id = widget._task.id;
    }
    
    Navigator.of(context).pop(task);
  }
}