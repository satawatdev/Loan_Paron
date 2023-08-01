import 'package:flutter/material.dart';

class errorscreen extends StatefulWidget {
  const errorscreen({super.key});

  @override
  State<errorscreen> createState() => _errorscreenState();
}

class _errorscreenState extends State<errorscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Error'),
      ),
      body: Center(
        child: Text(' ไม่สามารถเชื่อมต่อฐานข้อมูลได้'),
      ),
    );
  }
}
