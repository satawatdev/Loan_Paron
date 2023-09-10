import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class AddDataPage extends StatefulWidget {
  const AddDataPage({Key? key}) : super(key: key);

  @override
  _AddDataPageState createState() => _AddDataPageState();
}

class _AddDataPageState extends State<AddDataPage> {
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  CollectionReference monthlyData =
      FirebaseFirestore.instance.collection('monthlyData');

  double principal = 0.0;
  double interest = 0.0;
  double penalty = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('เพิ่มข้อมูล'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'เงินต้น'),
              onChanged: (value) {
                setState(() {
                  principal = double.tryParse(value) ?? 0.0;
                });
              },
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'ดอกเบี้ย'),
              onChanged: (value) {
                setState(() {
                  interest = double.tryParse(value) ?? 0.0;
                });
              },
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'ค่าปรับ'),
              onChanged: (value) {
                setState(() {
                  penalty = double.tryParse(value) ?? 0.0;
                });
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                addMonthData(principal, interest, penalty);
                // กลับไปหน้า "รายงาน" หลังจากเพิ่มข้อมูล
              },
              child: Text('บันทึกข้อมูล'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> addMonthData(
      double principal, double interest, double penalty) async {
    final currentMonth = DateTime.now().month;
    final currentYear = DateTime.now().year;

    final data = {
      'year': currentYear,
      'month': currentMonth,
      'principal': principal,
      'interest': interest,
      'penalty': penalty,
    };

    await monthlyData.add(data);
  }
}
