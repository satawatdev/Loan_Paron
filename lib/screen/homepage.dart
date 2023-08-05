import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../add_on/listTile.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var images =
      'https://i.pinimg.com/736x/5e/b7/4e/5eb74ed4073e2320a23e80fb3554a6c8.jpg';

  String searchText = ""; // ตัวแปรสำหรับเก็บคำที่ต้องการค้นหา

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("รายชื่อลูกหนี้ทั้งหมด"),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('user').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            // กรองข้อมูลด้วยคำที่ค้นหา (ชื่อหรือนามสกุล)
            var filteredData = snapshot.data!.docs.where((doc) {
              String name = doc['name'].toString().toLowerCase();
              String lastname = doc['lastname'].toString().toLowerCase();
              return name.contains(searchText.toLowerCase()) ||
                  lastname.contains(searchText.toLowerCase());
            }).toList();

            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        searchText =
                            value; // เก็บค่าคำที่ต้องการค้นหาในตัวแปร searchText
                      });
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: "ค้นหาชื่อ...",
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredData.length,
                    itemBuilder: (context, index) {
                      var data = filteredData[index];
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Column(
                          children: [
                            listTile(
                              profileImage: images,
                              username:
                                  'ชื่อ ${data['name']}  ${data['lastname']}',
                              message: 'รายละเอียด',
                              time: 'สถานะ',
                              ontap: () {
                                Navigator.pushNamed(context, '/detail',
                                    arguments: {
                                      'name': '${data['name']}',
                                      'lastname': '${data['lastname']}',
                                      'old': '${data['old']}',
                                      'phone': '${data['phone']}',
                                      'address': '${data['address']}',
                                      'LoanAmount': '${data['LoanAmount']}',
                                      'InterestAmount':
                                          '${data['InterestAmount']}',
                                      'day': '${data['day']}',
                                    });
                                debugPrint('กดรายชื่อ');
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
