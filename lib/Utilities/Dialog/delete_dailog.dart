import 'package:flutter/widgets.dart';
import 'package:flutter_firebase_app/Utilities/Dialog/generic_dialog.dart';

Future<bool> showDeleteDailog (BuildContext context) {
 return showGenericDailog(
  context: context,
   title: 'Delete', 
   content: 'Are You Sure To Delete Item ?',
    optionBuilder: () => { 
       'Cancle' : false,
       'Yes' : true
     }
     ).then((value) => value ?? false);
}