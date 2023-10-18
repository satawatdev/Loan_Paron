import 'package:debtor_check/firebase_options.dart';
import 'package:debtor_check/screen/detail_person.dart';
import 'package:debtor_check/screen/editDetail.dart';
import 'package:debtor_check/screen/editDetail.dart';
import 'package:debtor_check/screen/edit_oldphoto.dart';
import 'package:debtor_check/screen/errorscreen.dart';
import 'package:debtor_check/screen/tabbar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //* เช็คการเชื่อมต่อกับ Firebase
  try {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  } catch (e) {
    print(e.toString());
    // หากเกิดข้อผิดพลาดในการเชื่อมต่อกับ Firebase
    runApp(ErrorApp()); //* แสดงหน้า Errorscreen
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

const Color p = Color(0xff416d69);
//*เตรียม firebase
final Future<FirebaseApp> firebase = Firebase.initializeApp();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  //* This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('th', 'TH'), //* Thai
      ],
      locale: const Locale('th', 'TH'),
      debugShowCheckedModeBanner: false,
      title: 'Corona Out',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        primaryColor: p,
      ),
      routes: {
        '/': (context) => tabbar(),
        '/detail': (context) => const ProfileScreen(),
        '/EditPage': (context) => const EditPage(),
        '/editoldphoto': (context) => const EditOldPhoto(),
      },
    );
  }
}

class ErrorApp extends StatelessWidget {
  const ErrorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home:
          errorscreen(), //* แสดงหน้า Errorscreen ในกรณีที่เกิดข้อผิดพลาดในการเชื่อมต่อกับ Firebase
    );
  }
}
