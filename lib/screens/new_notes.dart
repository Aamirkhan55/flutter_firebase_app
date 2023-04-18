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

  @override
  void initState() {
    _textController.text;
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}