import 'package:flutter/material.dart';

class CustomButton extends RaisedButton {
  CustomButton({this.text, this.onPressed, this.big = false});

  final String text;
  final void Function() onPressed;
  final bool big;

  @override
  Widget build(BuildContext context) => RaisedButton(
        padding: EdgeInsets.symmetric(
            horizontal: big ? 36 : 24, vertical: big ? 18 : 12),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular((big ? 12 : 8)),
            side: BorderSide(color: Colors.grey)),
        color: Theme.of(context).primaryColor,
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
              color: Colors.white,
              fontSize: MediaQuery.of(context).size.height / (big ? 40 : 60)),
        ),
      );
}
