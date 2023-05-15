import 'package:flutter/material.dart';
import 'package:flutter_firebase_app/Utilities/Dialog/delete_dailog.dart';
import 'package:flutter_firebase_app/services/crud/notes_services.dart';

typedef DeleteNoteCallback = void Function(DatabaseNotes note);

class NotesListView extends StatelessWidget {
  final List<DatabaseNotes> notes;
  final DeleteNoteCallback onDeleteNote;

  const NotesListView(
      {super.key, required this.notes, required this.onDeleteNote});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes[index];
          return ListTile(
            title: Text(
              note.text,
              maxLines: 1,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: IconButton(
                onPressed: () async {
                  final shouldDelete = await showDeleteDailog(context);
                  if (shouldDelete) {
                    onDeleteNote(note);
                  }
                },
                icon: const Icon(
                  Icons.delete,
                  size: 16,
                  color: Colors.red,
                )),
          );
        });
  }
}
