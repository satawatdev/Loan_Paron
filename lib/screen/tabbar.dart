import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:debtor_check/screen/addperson.dart';
import 'package:debtor_check/screen/homepage.dart';
import 'package:debtor_check/screen/report.dart';
import 'package:debtor_check/screen/teatdata.dart';
import 'package:flutter/material.dart';

class tabbar extends StatefulWidget {
  @override
  _tabbarState createState() => _tabbarState();
}

//? ส่วนนี้ใว้ประกาศตัวแปล___________________________________
int _currentIndex = 0; //ประกาศค่าindexของList_page
//? __________________________________________________

//todo ส่วนนี้ใว้ทำ Function___________________________________

//todo __________________________________________________

class _tabbarState extends State<tabbar> {
  final List<Widget> _pages = [
    HomeScreen(), // หน้าแสดงเนื้อหาของแท็บ รายชื่อ
    ReportPage(), // หน้าแสดงคนที่ต้องจ่ายดอกเบี้ยวันนี้
    addperson(), // หน้าแสดงเนื้อหาของแท็บ เพิ่มรายชื่อ
    // AddDataPage(), // หน้าแสดงเนื้อหาของแท็บ เพิ่มรายชื่อ
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Flutter TabBar View'),

      // ),
      body: _pages[_currentIndex],
      bottomNavigationBar: ConvexAppBar(
        color: Colors.pink[200],
        backgroundColor: Theme.of(context).colorScheme.primary,
        style: TabStyle.react,
        items: const [
          TabItem(icon: Icons.person, title: 'รายชื่อ'),
          TabItem(icon: Icons.assessment, title: 'ประวัติ'),
          TabItem(icon: Icons.person_add, title: 'เพิ่มรายชื่อ'),
          // TabItem(icon: Icons.person_add, title: 'หน้าเทสเพิ่มข้อมูล'),
        ],
        initialActiveIndex:
            0, //เมื่อเปิดแอปให้ตำแน่งของtabbarอยู่ตำแหน่ง index ที่เท่าไหร่
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
