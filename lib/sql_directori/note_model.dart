import 'dart:ui';

class NotePages {
  final int id;
  final String note;
  final String title;
  final Color? color;

  NotePages(this.id, this.note, this.title, this.color);

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['title'] = note;
    map['note'] = title;
    map['color'] = color?.value;
    return map;
  }

  factory NotePages.fromMap(Map<String, dynamic> map) {
    final rawColor = map['color'];

    return NotePages(
      map['id'] ?? 0,
      map['title'],
      map['note'],
      rawColor != null ? Color(rawColor) : null,
    );
  }

  NotePages copyWith({
    int? id,
    String? note,
    String? title,
    Color? color,
  }) {
    return NotePages(
      id ?? this.id,
      note ?? this.note,
      title ?? this.title,
      color ?? this.color,
    );
  }
}
