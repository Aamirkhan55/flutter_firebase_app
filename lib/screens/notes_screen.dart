// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_firebase_app/Utilities/Dialog/logout_dailog.dart';
import 'package:flutter_firebase_app/screens/notes_list_view.dart';
import 'package:flutter_firebase_app/services/auth/auth_services.dart';
import 'package:flutter_firebase_app/services/crud/notes_services.dart';
import '../constants/routes.dart';
import '../enums/manu_action.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({super.key});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  late final NotesServices _notesServices;
  String get userEmail => AuthServices.firebase().currentUser!.email!;

  @override
  void initState() {
    _notesServices = NotesServices();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('NoteScreen'), actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(createOrUpdateRoute);
              },
              icon: const Icon(Icons.add)),
          PopupMenuButton<MenuAction>(onSelected: (value) async {
            switch (value) {
              case MenuAction.logout:
                final shouldLogOut = await showLogOutDialog(context);
                if (shouldLogOut) {
                  AuthServices.firebase().logOut();
                   Navigator.of(context)
                      .pushNamedAndRemoveUntil(signInRoute, (_) => false);
                }
            }
          }, itemBuilder: (context) {
            return [
              const PopupMenuItem(
                value: MenuAction.logout,
                child: Text('LogOut'),
              )
            ];
          })
        ]),
        body: FutureBuilder(
            future: _notesServices.getOrCreateUser(email: userEmail),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  return StreamBuilder(
                      stream: _notesServices.allNotes,
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                          case ConnectionState.active:
                            if (snapshot.hasData) {
                              final allNotes =
                                  snapshot.data as List<DatabaseNotes>;
                              return NotesListView(
                                notes: allNotes,
                                onDeleteNote: (note) async {
                                  await _notesServices.deletNote(id: note.id);
                                },
                                onTap: (note) => Navigator.of(context).pushNamed(
                                  createOrUpdateRoute,
                                  arguments: note,
                                  ) ,
                              );
                            } else {
                              return const CircularProgressIndicator();
                            }
                          default:
                            return const CircularProgressIndicator();
                        }
                      });
                default:
                  return const CircularProgressIndicator();
              }
            }));
  }
}
