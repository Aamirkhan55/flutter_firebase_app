import 'package:flutter/widgets.dart';
import 'package:flutter_firebase_app/Utilities/Dialog/generic_dialog.dart';

Future<void> showErrorDailog(BuildContext context, String text) {
  return showGenericDailog<void>(
    context: context,
    title: 'An Error Occured',
    content: text,
    optionBuilder: () => {
      'Ok': null,
    },
  );
}
