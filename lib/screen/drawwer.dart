import 'package:debtor_check/screen/body.dart';
import 'package:debtor_check/screen/testpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

final ZoomDrawerController z = ZoomDrawerController();

class drawwer extends StatefulWidget {
  const drawwer({Key? key}) : super(key: key);

  @override
  _drawwerState createState() => _drawwerState();
}

class _drawwerState extends State<drawwer> {
  @override
  Widget build(BuildContext context) {
    // return ZoomDrawer(
    //   controller: z,
    //   borderRadius: 50,
    //   // showShadow: true,
    //   openCurve: Curves.fastOutSlowIn,
    //   slideWidth: MediaQuery.of(context).size.width * 0.65,
    //   duration: const Duration(milliseconds: 500),
    //   // angle: 0.0,
    //   menuBackgroundColor: Colors.white,
    //   mainScreen: const Body(),
    //   // moveMenuScreen: false,
    //   menuScreen: Scaffold(
    //     backgroundColor: Colors.white,
    //     body: Scaffold(
    //       backgroundColor: Colors.white,
    //       body: Center(
    //         child: Padding(
    //           padding: const EdgeInsets.all(8.0),
    //           child: Column(
    //             crossAxisAlignment: CrossAxisAlignment.center,
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             children: [
    //               InkWell(
    //                 onTap: () {
    //                   final navigator = Navigator.of(
    //                     context,
    //                   );
    //                   z.close?.call()?.then(
    //                         (value) => navigator.push(
    //                           MaterialPageRoute(
    //                             builder: (_) => TestPage(),
    //                           ),
    //                         ),
    //                       );
    //                 },
    //                 child: Text(
    //                   "เพิ่มลูกหนี้รายใหม่",
    //                   style: TextStyle(fontSize: 24.0, color: Colors.black),
    //                 ),
    //               ),
    //               SizedBox(
    //                 height: 20,
    //               ),
    //               InkWell(
    //                 onTap: () {
    //                   final navigator = Navigator.of(
    //                     context,
    //                   );
    //                   z.close?.call()?.then(
    //                         (value) => navigator.push(
    //                           MaterialPageRoute(
    //                             builder: (_) => TestPage(),
    //                           ),
    //                         ),
    //                       );
    //                 },
    //                 child: Text(
    //                   "ยังคิดไม่ออก",
    //                   style: TextStyle(fontSize: 24.0, color: Colors.black),
    //                 ),
    //               ),
    //               SizedBox(
    //                 height: 20,
    //               ),
    //               InkWell(
    //                 onTap: () {
    //                   final navigator = Navigator.of(
    //                     context,
    //                   );
    //                   z.close?.call()?.then(
    //                         (value) => navigator.push(
    //                           MaterialPageRoute(
    //                             builder: (_) => TestPage(),
    //                           ),
    //                         ),
    //                       );
    //                 },
    //                 child: Text(
    //                   "ยังคิดไม่ออก",
    //                   style: TextStyle(fontSize: 24.0, color: Colors.black),
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //       ),
    //     ),
    //   ),
    // );
    return ZoomDrawer(
      controller: z,
      borderRadius: 24,
      // showShadow: true,
      openCurve: Curves.fastOutSlowIn,
      slideWidth: MediaQuery.of(context).size.width * 0.65,
      duration: const Duration(milliseconds: 500),
      // angle: 0.0,
      menuBackgroundColor: Colors.white,
      mainScreen: const Body(),
      moveMenuScreen: false,
      menuScreen: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: InkWell(
            onTap: () {
              final navigator = Navigator.of(
                context,
              );
              z.close?.call()?.then(
                    (value) => navigator.push(
                      MaterialPageRoute(
                        builder: (_) => TestPage(),
                      ),
                    ),
                  );
            },
            child: Text(
              "Push Page",
              style: TextStyle(fontSize: 24.0, color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }
}
