import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final String title;
  final VoidCallback onPress;
  const RoundButton({super.key, required this.title, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Container(
        height: 65,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.teal,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Text(
          title,
          style:  const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.normal,
          ),
          ),
      ),
    );
  }
}