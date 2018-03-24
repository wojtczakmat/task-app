import 'package:uuid/uuid.dart';

class Task {
  String id;
  String title;
  String description;

  Task(this.title, this.description) {
    this.id = new Uuid().v1();
  }
}