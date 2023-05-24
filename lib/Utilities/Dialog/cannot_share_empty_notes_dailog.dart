import 'package:flutter/material.dart';
import 'package:flutter_firebase_app/Utilities/Dialog/generic_dialog.dart';

Future<void> cannotShareEmptyNotesDailog(BuildContext context) {
   return showGenericDailog(
    context: context, 
    title: 'Sharing', 
    content: 'You Cannot Share Empty Notes..!', 
    optionBuilder: () => {
      'OK': null,
    },
    );
}