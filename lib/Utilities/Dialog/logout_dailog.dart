import 'package:flutter/widgets.dart';
import 'package:flutter_firebase_app/Utilities/Dialog/generic_dialog.dart';

Future<bool> showLogOutDialog(BuildContext context) {
  return showGenericDailog<bool>(
      context: context,
      title: 'Log Out',
      content: 'Are you sure to Log out.?',
      optionBuilder: () => {
            'Cancle': false,
            'Log Out': true,
          }).then((value) => value ?? false);
}
