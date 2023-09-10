import 'package:flutter/material.dart';

class RoundedGreenButton extends StatelessWidget {
  RoundedGreenButton(
      {super.key,
      required this.text,
      required this.onPressed,
      required this.colors});
  final text;
  final VoidCallback onPressed;
  final colors;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150, // กำหนดขนาดความกว้างของปุ่ม
      height: 40, // กำหนดขนาดความสูงของปุ่ม
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          primary: colors, // กำหนดสีพื้นหลังของปุ่ม
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0), // กำหนดความโค้งมนของปุ่ม
          ),
        ),
        child: text,
        //   Text(
        //     text,
        //     style: TextStyle(fontSize: 20), // กำหนดขนาดตัวอักษร
        //   ),
      ),
    );
  }
}
