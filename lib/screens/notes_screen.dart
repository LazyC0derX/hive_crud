import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_crud/controller/notes_controller.dart';
import 'package:hive_crud/model/notes.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({Key? key}) : super(key: key);

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  final controller = Get.put(NotesController());
  final TextEditingController titleController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    titleController.dispose();
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CRUD with hive"),
      ),
      body: GetBuilder<NotesController>(
          builder: (cont) => ListView.builder(
              itemCount: cont.notesCount,
              itemBuilder: (context, index) {
                if (cont.notesCount > 0) {
                  Note? note = cont.observableBox.getAt(index);
                  return Card(
                    child: ListTile(
                      title: Text(note?.title ?? "N/A"),
                      subtitle: Text(note?.note ?? "Blank"),
                      leading: IconButton(
                          onPressed: () =>
                              addEditNote(index: index, note: note),
                          icon: const Icon(Icons.edit)),
                      trailing: IconButton(
                          onPressed: () => cont.deleteNote(index: index),
                          icon: const Icon(Icons.delete)),
                    ),
                  );
                } else {
                  return const Center(
                    child: Text("List is Empty"),
                  );
                }
              })),
      floatingActionButton: FloatingActionButton(
        onPressed: () => addEditNote(),
        child: const Icon(Icons.add),
      ),
    );
  }

  addEditNote({
    int? index,
    Note? note,
  }) {
    showDialog(
        context: context,
        builder: (context) {
          if (note != null) {
            titleController.text = note.title.toString();
            noteController.text = note.note.toString();
          } else {
            titleController.clear();
            noteController.clear();
          }
          return Material(
            child: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: ListView(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(hintText: "Title"),
                      controller: titleController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(hintText: "Notes"),
                      controller: noteController,
                      maxLines: 5,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          bool? isValidated = formKey.currentState?.validate();
                          if (isValidated == true) {
                            String titleText = titleController.text;
                            String noteText = noteController.text;
                            if (index != null) {
                              controller.updateNote(
                                  index: index,
                                  note: Note(title: titleText, note: noteText));
                            } else {
                              controller.createNote(
                                  note: Note(title: titleText, note: noteText));
                            }
                            Navigator.pop(context);
                          } else {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Enter valid values")));
                          }
                        },
                        child: const Text("Submit"))
                  ],
                ),
              ),
            ),
          );
        });
  }
}