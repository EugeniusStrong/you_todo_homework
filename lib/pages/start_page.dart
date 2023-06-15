import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/notes_bloc.dart';
import '../bloc/notes_event.dart';
import '../bloc/notes_state.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  final _noteNameController = TextEditingController();
  final _titleNameController = TextEditingController();
  Color? _selectedColor;

  static const colorRed = Color(0xFFF44336);
  static const colorBlue = Color(0xFF2196F3);
  static const colorGreen = Color(0xFF4CAF50);

  @override
  Widget build(BuildContext context) {
    final screenBloc = BlocProvider.of<NotesBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'YOUR TODO',
          style: TextStyle(fontStyle: FontStyle.italic, fontSize: 20),
        ),
      ),
      body: BlocBuilder<NotesBloc, NotesState>(
        builder: (context, state) {
          if (state is NotesLoadSuccess) {
            if (state.todoList.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.create,
                      size: 100,
                      color: Colors.black54,
                    ),
                    Text(
                      'To add a note press +',
                      style: TextStyle(fontSize: 30),
                    ),
                  ],
                ),
              );
            }
            return ListView.builder(
              itemCount: state.todoList.length,
              itemBuilder: (BuildContext context, int index) {
                final itemData = state.todoList[index];
                return Dismissible(
                  key: Key(itemData.id.toString()),
                  child: Card(
                    color: itemData.color,
                    child: ListTile(
                      title: TextButton(
                        onPressed: () {
                          _showInputForm(
                            context,
                            () => screenBloc.add(
                              NotesUpdateRequested(
                                note: _noteNameController.text,
                                title: _titleNameController.text,
                                originalNote: itemData,
                                color: _selectedColor,
                              ),
                            ),
                            title: itemData.title,
                            note: itemData.note,
                            color: itemData.color,
                            titleInput: 'UPDATE NOTE',
                            buttonText: 'UPDATE',
                          );
                        },
                        child: Text(
                          itemData.note,
                          style: const TextStyle(
                              fontSize: 30,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      subtitle: Text(
                        itemData.title,
                        style: const TextStyle(
                            fontSize: 20, color: Colors.black87),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_sweep_outlined,
                            color: Colors.black54),
                        onPressed: () {
                          _onDelete(context, itemData.id);
                        },
                      ),
                    ),
                  ),
                  onDismissed: (direction) {
                    _onDelete(context, itemData.id);
                  },
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showInputForm(
            context,
            () => screenBloc.add(
              NotesCreatedRequested(
                  note: _noteNameController.text,
                  title: _titleNameController.text,
                  color: _selectedColor),
            ),
            titleInput: 'ADD NOTE',
            buttonText: 'ADD',
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  void _onDelete(BuildContext context, int id) {
    BlocProvider.of<NotesBloc>(context).add(NotesDeleteRequested(id));
  }

  void _showInputForm(BuildContext context, VoidCallback onButtonPressed,
      {String? title,
      String? note,
      Color? color,
      required String titleInput,
      required String buttonText}) {
    _titleNameController.text = title ?? '';
    _noteNameController.text = note ?? '';
    _selectedColor = color;

    showDialog<void>(
      context: context,
      builder: (BuildContext context) => StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  titleInput,
                  style: const TextStyle(
                      color: Colors.purple,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 25),
                TextField(
                  controller: _noteNameController,
                  cursorColor: Colors.white,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'Enter TITLE',
                    hintStyle: TextStyle(
                        color: Colors.white38, fontStyle: FontStyle.italic),
                    filled: true,
                    fillColor: Colors.black54,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(30.0),
                        ),
                        borderSide: BorderSide.none),
                    icon: Icon(
                      Icons.create,
                      color: Colors.black87,
                      size: 50.0,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  cursorColor: Colors.black54,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'Enter NOTE',
                    hintStyle: TextStyle(
                        color: Colors.white38, fontStyle: FontStyle.italic),
                    filled: true,
                    fillColor: Colors.black54,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(30.0),
                        ),
                        borderSide: BorderSide.none),
                    icon: Icon(
                      Icons.edit_note_outlined,
                      color: Colors.black87,
                      size: 50.0,
                    ),
                  ),
                  controller: _titleNameController,
                ),
                const SizedBox(height: 30),
                const Text(
                  'Choose color for note:',
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildColorButton(colorRed, (color) {
                      setState(() => _selectedColor = color);
                    }),
                    _buildColorButton(colorBlue, (color) {
                      setState(() => _selectedColor = color);
                    }),
                    _buildColorButton(colorGreen, (color) {
                      setState(() => _selectedColor = color);
                    }),
                  ],
                ),
                const SizedBox(height: 50),
                TextButton(
                  onPressed: () {
                    onButtonPressed();
                    Navigator.pop(context);
                  },
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(Colors.purple),
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: const BorderSide(color: Colors.purple)),
                    ),
                  ),
                  child: Text(
                    buttonText,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildColorButton(Color color, ValueChanged<Color> onSelect) {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black54,
      ),
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(3),
      child: FloatingActionButton(
        onPressed: () {
          onSelect(color);
        },
        backgroundColor: color,
        child: color == _selectedColor ? const Icon(Icons.done) : null,
      ),
    );
  }
}
