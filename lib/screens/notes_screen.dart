import 'package:flutter/material.dart';
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
  void dispose() {
     _notesServices.closeDb();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NoteScreen'),
        actions: [
          PopupMenuButton<MenuAction>(onSelected: (value) async {
            switch (value) {
              case MenuAction.logout:
                final shouldLogOut = await showLogOut(context);
                if (shouldLogOut) {
                   AuthServices.firebase().logOut();
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          signInRoute, (route) => false);
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
        ],
      ),
      body: FutureBuilder(
        future: _notesServices.getOrCreateUser(email: userEmail),
        builder: (context , snapshot) {
         switch(snapshot.connectionState) {
           case ConnectionState.done:
             return StreamBuilder(
              stream: _notesServices.allNotes,
              builder: (context, snapshot) {
               switch (snapshot.connectionState) {
                 case ConnectionState.waiting:
                    return const Text('Waiting for all notes');
                  default:
                     return const CircularProgressIndicator();
               } 
              } );
             default :
              return const CircularProgressIndicator();
         }
      })
    );
  }
}

Future<bool> showLogOut(BuildContext context) async {
  return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('LogOut'),
          content: const Text('Are You Sure To Log Out'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancle'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Log Out'),
            )
          ],
        );
      }).then(
    (value) => value ?? false,
  );
}
