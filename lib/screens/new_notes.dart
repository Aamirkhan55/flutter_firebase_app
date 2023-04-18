import 'package:flutter/material.dart';
import 'package:flutter_firebase_app/services/auth/auth_services.dart';
import 'package:flutter_firebase_app/services/crud/notes_services.dart';

class NewNotesScreen extends StatefulWidget {
  const NewNotesScreen({super.key});

  @override
  State<NewNotesScreen> createState() => _NewNotesScreenState();
}

class _NewNotesScreenState extends State<NewNotesScreen> {

  DatabaseNotes? _note;
  late final NotesServices _notesServices;
  late final TextEditingController _textController;

  Future<DatabaseNotes> createNewNotes () async{
    final existingNote = _note;
    if (existingNote != null) {
      return existingNote;
    } 
    final currentUser = AuthServices.firebase().currentUser!;
    final email = currentUser.email!;
    final owner = await _notesServices.getUser(email: email);
    return await _notesServices.createNote(owner: owner);
  }

  void _deleteNoteIfTextIsEmpty() {
    final note = _note;
    if (_textController.text.isEmpty && note != null) {
      _notesServices.deletNote(id: note.id);
    }
  }

  void _saveNoteIfTextNotEmpty() async{
    final note = _note;
    final text = _textController.text;
    if (note != null && text.isNotEmpty) {
      await _notesServices.updateNotes(note: note, text: text);
    }
  }

  void _textControllerListener() async{
    final note = _note;
    if (note == null) {
      return;
    } 
    final text = _textController.text;
    await _notesServices.updateNotes(note: note, text: text);
  }

  void _setupTextControllerListener() {
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
  }

  @override
  void initState() {
    _notesServices = NotesServices();
    _textController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    _deleteNoteIfTextIsEmpty();
    _saveNoteIfTextNotEmpty();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar:   AppBar(
        title: const Text('New Notes'),
      ),
      body: FutureBuilder(
        future: createNewNotes(),
        builder: (context, snapshot){
          switch (snapshot.connectionState) {
           case ConnectionState.done:
             _note = snapshot.data as DatabaseNotes;
             _setupTextControllerListener();
              return TextField(
                controller: _textController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: 'Start Yor Text Here....'
                ),
              );
             default :
               return const CircularProgressIndicator();
          }
         }),
    );
  }
}