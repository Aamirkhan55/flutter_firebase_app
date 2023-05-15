
import 'package:flutter/material.dart';

typedef DailogOptionBuilder<T> = Map<String, T?> Function();

Future<T?> showGenericDailog<T>({
   required BuildContext context,
   required String title,
   required String content,
   required DailogOptionBuilder optionBuilder,
}) {
   final option = optionBuilder();
   return showDialog<T>(
    context: context, 
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: option.keys.map((optionTitle) {
          final value = option[optionTitle];
          return TextButton(
            onPressed: () {
              if (value !+ null) {
                Navigator.of(context).pop(value);
              } else {
                Navigator.of(context).pop();              }
            }, 
            child: Text(optionTitle),
            );
        }).toList(),
      );
    }
    );
}