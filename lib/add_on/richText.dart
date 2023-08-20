import 'package:flutter/material.dart';

class customtextspan extends StatelessWidget {
  customtextspan({required this.text1, required this.text2});

  final text1;
  final text2;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        // style: DefaultTextStyle.of(context).style,
        children: [
          TextSpan(
            text: text1,
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          TextSpan(
            text: text2,
            style: TextStyle(
                fontSize: 16, fontStyle: FontStyle.italic, color: Colors.blue),
          ),
        ],
      ),
    );
  }
}

class customtextspancolor extends StatelessWidget {
  customtextspancolor({
    required this.text1,
    required this.text2,
    required this.colortext1,
    required this.colortext2,
  });

  final text1;
  final text2;
  final colortext1;
  final colortext2;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        // style: DefaultTextStyle.of(context).style,
        children: [
          TextSpan(
            text: text1,
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: colortext1),
          ),
          TextSpan(
            text: text2,
            style: TextStyle(
                fontSize: 16, fontStyle: FontStyle.italic, color: colortext2),
          ),
        ],
      ),
    );
  }
}
