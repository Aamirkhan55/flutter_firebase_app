import 'package:flutter/material.dart';
import 'package:flutter_firebase_app/Utilities/Dialog/delete_dailog.dart';
import 'package:flutter_firebase_app/services/cloud/cloud_notes.dart';


typedef NoteCallback = void Function(CloudNote note);

class NotesListView extends StatelessWidget {
  final Iterable<CloudNote> notes;
  final NoteCallback onDeleteNote;
  final NoteCallback onTap;

  const NotesListView(
      {super.key,
      required this.notes,
      required this.onDeleteNote,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes.elementAt(index);
          return ListTile(
            onTap: () => onTap(note),  
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
