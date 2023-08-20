// import 'package:debtor_check/screen/errorscreen.dart';

// import 'package:debtor_check/screen/tabbar.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();

//   SystemChrome.setSystemUIOverlayStyle(
//     const SystemUiOverlayStyle(
//       statusBarColor: Colors.transparent,
//       statusBarIconBrightness: Brightness.dark,
//     ),
//   );

//   runApp(const MyApp());
// }

// const Color p = Color(0xff416d69);
// //เตรียม firebase
// final Future<FirebaseApp> firebase = Firebase.initializeApp();

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         debugShowCheckedModeBanner: false,
//         title: 'Corona Out',
//         theme: ThemeData(
//           primarySwatch: Colors.blue,
//           primaryColor: p,
//         ),
//         routes: {
//           '/': (context) => tabbar(),
//         });
//   }
// }

import 'package:debtor_check/screen/detail_person.dart';
import 'package:debtor_check/screen/errorscreen.dart';

import 'package:debtor_check/screen/tabbar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:postgres/postgres.dart';

import 'model/model_person.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  // try {
  //   await operation();
  // } catch (e) {
  //   runApp(ErrorApp()); // แสดงหน้า Errorscreen
  //   return;
  // }

  WidgetsFlutterBinding.ensureInitialized();
  // เช็คการเชื่อมต่อกับ Firebase
  try {
    await Firebase.initializeApp();
  } catch (e) {
    // หากเกิดข้อผิดพลาดในการเชื่อมต่อกับ Firebase
    runApp(ErrorApp()); // แสดงหน้า Errorscreen
    return;
  }

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const MyApp());
}

//!connectdatabase ตอนนี่กำลังทำตรงนี้12/08/2566

// Future<void> operation() async {
//   var connection = PostgreSQLConnection(
//     "devnickbase.csrtaabsrngd.ap-southeast-2.rds.amazonaws.com",
//     5432,
//     "Paron_platform",
//     username: "postgres",
//     password: "6KzKJk2CyUiBT8zDYVSaQUJIPaJmL6",
//     useSSL: true,
//   );
//   await connection.open();
//   print("Connected");
//   var results = await connection.query('SELECT * FROM master.customers');
// }

//!--------------------------

const Color p = Color(0xff416d69);
//เตรียม firebase
final Future<FirebaseApp> firebase = Firebase.initializeApp();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Corona Out',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: p,
        ),
        routes: {
          '/': (context) => tabbar(),
          '/detail': (context) => ProfileScreen(),
        });
  }
}

class ErrorApp extends StatelessWidget {
  const ErrorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:
          errorscreen(), // แสดงหน้า Errorscreen ในกรณีที่เกิดข้อผิดพลาดในการเชื่อมต่อกับ Firebase
    );
  }
}
