import 'dart:ui';

import 'package:equatable/equatable.dart';

import '../sql_directory/note_model.dart';

abstract class NotesEvent extends Equatable {
  @override
  bool? get stringify => true;
}

class NotesAppStarted extends NotesEvent {
  @override
  List<Object?> get props => const [];
}

class NotesCreatedRequested extends NotesEvent {
  final String note;
  final String title;
  final Color? color;
  NotesCreatedRequested(
      {required this.note, required this.title, required this.color});
  @override
  List<Object?> get props => [note, title, color];
}

class NotesUpdateRequested extends NotesEvent {
  final String note;
  final String title;
  final Color? color;
  final NotePages originalNote;
  NotesUpdateRequested(
      {required this.note,
      required this.title,
      required this.color,
      required this.originalNote});
  @override
  List<Object?> get props => [note, title, color, originalNote];
}

class NotesDeleteRequested extends NotesEvent {
  final int id;

  NotesDeleteRequested(this.id);
  @override
  List<Object?> get props => [id];
}
