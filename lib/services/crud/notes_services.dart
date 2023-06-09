// import 'dart:async';

// import 'package:flutter/foundation.dart';
// import 'package:flutter_firebase_app/extension/lists/filter.dart';
// import 'package:flutter_firebase_app/services/crud/crud_exception.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:path/path.dart' show join;


// class NotesServices {
//   Database? _db;

//   List<DatabaseNotes> _notes = [];

//   DatabaseUser? _user;
 
//   static final NotesServices _shared = NotesServices._sharedInstance();
//   NotesServices._sharedInstance() {
//    _notesStreamController = StreamController<List<DatabaseNotes>>.broadcast(
//     onListen: () {
//       _notesStreamController.sink.add(_notes);
//     }
//    );
//   }
//   factory NotesServices() => _shared;

//  late final StreamController<List<DatabaseNotes>> _notesStreamController; 

//   Stream<List<DatabaseNotes>> get allNotes => _notesStreamController.stream.filter((note) {
//     final currentUser = _user;
//     if (currentUser != null) {
//       return note.userId == currentUser.id;
//     } else {
//       throw UserShouldBeSetBeforeReadingAllNotes();
//     }
//   });

//   Future<void> _ensureDbIsOpen() async{
//     try {
//       await openDb();
//     } on DatabaseAlreadyOpenException {
//        'Please Sure Db Is Open';
//     }
//   }

//   Future<void> _cacheNotes() async{
//     final allNotes = await getAllNotes();
//     _notes = allNotes.toList();
//     _notesStreamController.add(_notes);
//   }

//  Future<DatabaseUser> getOrCreateUser({
//   required String email,
//   bool setAsCurrentUser = true,
//   }) async{
//   try {
//     final user = await getUser(email: email);
//     if (setAsCurrentUser) {
//       _user = user;
//     }
//     return user;
//   } on CouldNotFindUserException {
//     final createdUser = await createUser(email: email);
//     if(setAsCurrentUser){
//       _user = createdUser;
//     }
//     return createdUser;
//   } catch (e) {
//     rethrow;
//   }
//  }

//   Future<DatabaseNotes> updateNotes ({
//     required DatabaseNotes note, 
//     required String text
//     }) async{
//      await _ensureDbIsOpen();
//     final db = _getDataBaseOrThrow();
//     await getNote(id: note.id);
//     final updateCount = await db.update(noteTable, {
//       textColumn : text,
//       isSyncedWithCloudColumn : 0,
//     },
//     where: 'id = ?',
//     whereArgs: [note.id],
//     );
//     if (updateCount == 0) {
//       throw CouldNotUpdateException();
//     } else {
//       final updateNotes = await getNote(id: note.id);
//       _notes.removeWhere((note) => note.id == updateNotes.id);
//       _notes.add(updateNotes);
//       _notesStreamController.add(_notes);
//       return updateNotes;
//     }
//   }

//   Future<Iterable<DatabaseNotes>> getAllNotes() async{
//     await _ensureDbIsOpen();
//     final db = _getDataBaseOrThrow();
//     final notes = await db.query(noteTable);
//     return notes.map((noteRow) => DatabaseNotes.fromRow(noteRow));
//   }

//   Future<DatabaseNotes> getNote({required int id}) async{
//     await _ensureDbIsOpen();
//     final db = _getDataBaseOrThrow();
//     final notes =  await db.query(
//       noteTable,
//       limit: 1,
//       where: 'id = ?',
//       whereArgs: [id],
//       );
//       if (notes.isEmpty) {
//         throw CouldNotFindNoteException();
//       } else {
//         final note = DatabaseNotes.fromRow(notes.first);
//         _notes.removeWhere((note) => note.id == id);
//         _notes.add(note);
//         _notesStreamController.add(_notes);
//         return note;
//       }
//   }

//   Future<int> deleteAllNotes() async{
//      await _ensureDbIsOpen();
//     final db = _getDataBaseOrThrow();
//     final numberOfDeletion = await db.delete(noteTable);
//     _notes = [];
//     _notesStreamController.add(_notes);
//     return numberOfDeletion;
//   }
 
//    Future<void> deletNote({required int id}) async{
//      await _ensureDbIsOpen();
//     final db = _getDataBaseOrThrow();
//     final deletedCount = await db.delete(
//       noteTable,
//       where: 'id = ?',
//       whereArgs: [id],
//       );
//       if (deletedCount == 0) {
//         throw CouldNotDeleteNoteException();
//       }else {
//         _notes.removeWhere((note) => note.id == id);
//         _notesStreamController.add(_notes);
//       }
//    }

//   Future<DatabaseNotes> createNote({required DatabaseUser owner}) async{
//     await _ensureDbIsOpen();
//     final db = _getDataBaseOrThrow();

//    final dbUser = await getUser(email: owner.email);
//    if(dbUser != owner){
//     throw CouldNotFindUserException();
//    }
//     const text = '';

//    final noteId = await db.insert(noteTable, {
//       userIdColumn : owner.id,
//       textColumn : text,
//       isSyncedWithCloudColumn : 1,
//     });

//     final note = DatabaseNotes(
//       id: noteId,
//        userId: owner.id, 
//        text: text, 
//        isSyncWithCloud: true,
//        );
 
//        _notes.add(note);
//        _notesStreamController.add(_notes);
//        return note;

//   }

//   Future<DatabaseUser> getUser({required String email}) async{
//      await _ensureDbIsOpen();
//     final db = _getDataBaseOrThrow();
//     final result = await db.query(
//       userTable,
//       limit: 1,
//       where: 'email = ?',
//       whereArgs: [email.toLowerCase()]);
//      if (result.isEmpty) {
//       throw CouldNotFindUserException();
//      }else {
//       return DatabaseUser.fromRow(result.first);
//      }
//   }

//   Future<DatabaseUser> createUser({required String email}) async {
//      await _ensureDbIsOpen();
//     final db = _getDataBaseOrThrow();
//     final result = await db.query(
//       userTable,
//         limit: 1, 
//         where: 'email = ?', 
//         whereArgs: [email.toLowerCase()]);
//     if (result.isNotEmpty) {
//       throw UserAlreadyExistException();
//     }
//     final userId =
//         await db.insert(userTable, {emailColumn: email.toLowerCase()});
//     return DatabaseUser(id: userId, email: email);
//   }

//   Future<void> deleteUser({required String email}) async {
//     await _ensureDbIsOpen();
//     final db = _getDataBaseOrThrow();
//     final deletedCount = await db.delete(
//       userTable,
//       where: 'email = ?',
//       whereArgs: [email.toLowerCase()],
//     );
//     if (deletedCount != 1) {
//       throw CouldNotDeletUserException();
//     }
//   }

//   Database _getDataBaseOrThrow() {
//     final db = _db;
//     if (db == null) {
//       throw DatabaseIsNotOpenException();
//     } else {
//       return db;
//     }
//   }

//   Future<void> closeDb() async {
//     final db = _db;
//     if (db == null) {
//       throw DatabaseIsNotOpenException();
//     } else {
//       await db.close();
//       _db = null;
//     }
//   }

//   Future<void> openDb() async {
//     if (_db != null) {
//       throw DatabaseAlreadyOpenException();
//     }
//     try {
//       final docsPath = await getApplicationDocumentsDirectory();
//       final dbPath = join(docsPath.path, dbName);
//       final db = await openDatabase(dbPath);
//       _db = db;
//       // create user table
//       await db.execute(createUserTable);
//       // create note table
//       await db.execute(createNoteTable);
//       await _cacheNotes();
//     } on MissingPlatformDirectoryException {
//       throw UnableToGetDocDorectoryException();
//     }
//   }
// }

// @immutable
// class DatabaseUser {
//   final int id;
//   final String email;

//   const DatabaseUser({required this.id, required this.email});

//   DatabaseUser.fromRow(Map<String, Object?> map)
//       : id = map[idColumn] as int,
//         email = map[emailColumn] as String;

//   @override
//   String toString() => 'Person, ID = $id, email = $email ';

//   @override
//   bool operator ==(covariant DatabaseUser other) => id == other.id;

//   @override
//   int get hashCode => id.hashCode;
// }

// class DatabaseNotes {
//   final int id;
//   final int userId;
//   final String text;
//   final bool isSyncWithCloud;

//   const DatabaseNotes(
//       {required this.id,
//       required this.userId,
//       required this.text,
//       required this.isSyncWithCloud});

//   DatabaseNotes.fromRow(Map<String, Object?> map)
//       : id = map[idColumn] as int,
//         userId = map[userIdColumn] as int,
//         text = map[textColumn] as String,
//         isSyncWithCloud =
//             (map[isSyncedWithCloudColumn] as int) == 1 ? true : false;

//   @override
//   String toString() =>
//       'Note, ID = $id, userId = $userId, text = $text, isSyncedWithCloud = $isSyncWithCloud';

//   @override
//   bool operator ==(covariant DatabaseNotes other) => id == other.id;

//   @override
//   int get hashCode => id.hashCode;
// }

// const dbName = 'notes.db';
// const noteTable = 'note';
// const userTable = 'user';
// const idColumn = 'id';
// const emailColumn = 'email';
// const userIdColumn = 'user_id';
// const textColumn = 'text';
// const isSyncedWithCloudColumn = 'is_synced_with_cloud';
// const createUserTable = '''CREATE TABLE IF NOT EXISTS "user" (
//         "id" INTEGER NOT NULL,
//         "email" TEXT NOT NULL UNIQUE,
//         PRIMARY KEY("id" AUTOINCREMENT)
//       )''';
// const createNoteTable = '''CREATE TABLE IF NOT EXISTS "note" (
//         "id" INTEGER NOT NULL,
//         "user_id" INTEGER NOT NULL,
//         "text" TEXT,
//         "is_synced_with_cloud" INTEGER NOT NULL DEFAULT 0,
//         FOREIGN KEY("user_id") REFERENCES "user"("id"),
//         PRIMARY KEY("id" AUTOINCREMENT)
//       )''';
