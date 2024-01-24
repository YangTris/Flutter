import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:note_app/note.dart';

class AddNoteScreen extends StatefulWidget {
  final Note? note; // Pass the existing Note if it's an update operation

  const AddNoteScreen({this.note});

  @override
  _AddNoteScreenState createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  late TextEditingController titleController;
  late TextEditingController contentController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.note?.title ?? '');
    contentController = TextEditingController(text: widget.note?.content ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'Add Note' : 'Update Note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                hintText: 'Note title...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: TextField(
                controller: contentController,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  hintText: 'Note content...',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                if (widget.note == null) {
                  addNoteToFirestore(context);
                } else {
                  updateNoteInFirestore(context);
                }
              },
              child: Text(widget.note == null ? 'Add Note' : 'Update Note'),
            ),
          ],
        ),
      ),
    );
  }

  void addNoteToFirestore(BuildContext context) {
    if (titleController.text.isNotEmpty || contentController.text.isNotEmpty) {
      FirebaseFirestore.instance.collection('notes').add({
        'title': titleController.text,
        'content': contentController.text,
        'timestamp': Timestamp.now(),
      });

      Navigator.pop(context); // Close the AddNoteScreen after adding the note
    } else {
      // Optionally, show a snackbar or alert if title or content is empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter title and content.'),
        ),
      );
    }
  }

  void updateNoteInFirestore(BuildContext context) {
    if (titleController.text.isNotEmpty || contentController.text.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('notes')
          .doc(widget.note!.id)
          .update({
        'title': titleController.text,
        'content': contentController.text,
        'timestamp': Timestamp.now(),
      });

      Navigator.pop(context); // Close the AddNoteScreen after updating the note
    } else {
      // Optionally, show a snackbar or alert if title or content is empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter title and content.'),
        ),
      );
    }
  }
}