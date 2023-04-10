import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {
  final Function()? funtion;
  final Color borderColor;
  final Color backgroundColor;
  final Color textColor;
  final String text;
  const FollowButton(
      {required this.borderColor,
      this.funtion,
      required this.text,
      required this.textColor,
      required this.backgroundColor,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 4),
      child: TextButton(
        onPressed: funtion,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: borderColor),
              color: backgroundColor),
          alignment: Alignment.center,
          width: 250,
          height: 27,
          child: Text(
            text,
            style: TextStyle(color: textColor),
          ),
        ),
      ),
    );
  }
}
