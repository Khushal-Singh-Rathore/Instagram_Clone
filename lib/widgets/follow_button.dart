import 'package:flutter/material.dart';

import 'color.dart';

class FollowButton extends StatelessWidget {
  final Function()? function;
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;
  final String text;
  const FollowButton(
      {required this.textColor,
      required this.backgroundColor,
      required this.borderColor,
      required this.text,
      this.function,
      super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: function,
      child: Container(
        margin: const EdgeInsets.all(3),
        width: double.infinity,
        height: 30,
        decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: borderColor, width: 1)),
        child: Center(
            child: Text(text,
                style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w300))),
      ),
    );
  }
}
