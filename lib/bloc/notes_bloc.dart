import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../sql_directory/database.dart';
import '../sql_directory/note_model.dart';
import 'notes_event.dart';
import 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  NotesBloc() : super(NoteInitial()) {
    on<NotesCreatedRequested>((event, emit) async {
      DBProvider.db.insertNote(
        NotePages(Random().nextInt(100), event.note, event.title, event.color),
      );
      final notesList = await DBProvider.db.getNotes();
      emit(NotesLoadSuccess(todoList: notesList));
    });
    on<NotesDeleteRequested>((event, emit) async {
      DBProvider.db.deleteNote(event.id);
      final notesList = await DBProvider.db.getNotes();
      emit(NotesLoadSuccess(todoList: notesList));
    });
    on<NotesUpdateRequested>((event, emit) async {
      DBProvider.db.updateNote(
        (event.originalNote.copyWith(
          note: event.note,
          title: event.title,
          color: event.color,
        )),
      );
      final notesList = await DBProvider.db.getNotes();
      emit(NotesLoadSuccess(todoList: notesList));
    });
    on<NotesAppStarted>((event, emit) async {
      final notesList = await DBProvider.db.getNotes();
      emit(NotesLoadSuccess(todoList: notesList));
    });
  }
}
