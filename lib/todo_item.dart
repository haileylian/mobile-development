import 'package:floor/floor.dart';

@entity
class ToDoItem {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final String task;

  ToDoItem({this.id, required this.task});
}
