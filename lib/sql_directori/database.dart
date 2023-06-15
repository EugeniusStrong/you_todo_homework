import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'note_model.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();
  static Database? _database;

  static const notesTable = 'notes';
  static const columnId = 'id';
  static const columnNotes = 'note';
  static const columnTitle = 'title';
  static const columnColor = 'color';

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDB();
    return _database;
  }

  Future<Database?> _initDB() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = '${dir.path}/NewNotePages.db';
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
    );
  }

  void _createDb(Database db, int version) async {
    await db.execute(
      'CREATE TABLE $notesTable'
      '($columnId INTEGER PRIMARY KEY AUTOINCREMENT,'
      ' $columnNotes TEXT,'
      ' $columnTitle TEXT,'
      ' $columnColor INTEGER)',
    );
  }

  Future<List<NotePages>> getNotes() async {
    Database? db = await database;
    final List<Map<String, dynamic>> notesMapList = await db!.query(notesTable);
    final List<NotePages> notesList = [];
    for (var noteMap in notesMapList) {
      notesList.add(NotePages.fromMap(noteMap));
    }
    return notesList;
  }

  Future<NotePages> insertNote(NotePages note) async {
    Database? db = await database;
    await db!.insert(notesTable, note.toMap());
    return note;
  }

  Future<int> updateNote(NotePages note) async {
    Database? db = await database;
    return await db!.update(
      notesTable,
      note.toMap(),
      where: '$columnId = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> deleteNote(int id) async {
    Database? db = await database;
    return await db!.delete(
      notesTable,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }
}
