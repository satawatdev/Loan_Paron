import 'package:debtor_check/providers/transection_provider.dart';
import 'package:debtor_check/screen/addperson.dart';
import 'package:debtor_check/screen/errorscreen.dart';

import 'package:debtor_check/screen/tabbar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:postgres/postgres.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const MyApp());
}

const Color p = Color(0xff416d69);
//เตรียม firebase
final Future<FirebaseApp> firebase = Firebase.initializeApp();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: firebase,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return MaterialApp(home: errorscreen());
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Corona Out',
              theme: ThemeData(
                primarySwatch: Colors.blue,
                primaryColor: p,
              ),
              routes: {
                '/': (context) => tabbar(),
              });
        }
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
