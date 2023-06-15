import '../sql_directory/note_model.dart';

abstract class NotesState {}

class NoteInitial extends NotesState {}

class NotesLoadSuccess extends NotesState {
  final List<NotePages> todoList;

  NotesLoadSuccess({required this.todoList});
}
