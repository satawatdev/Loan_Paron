import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({Key? key}) : super(key: key);

  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  @override
  void initState() {
    fetchMonthData(selectedYear, selectedMonth);
    super.initState();
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final List<String> months = [
    'มกราคม',
    'กุมภาพันธ์',
    'มีนาคม',
    'เมษายน',
    'พฤษภาคม',
    'มิถุนายน',
    'กรกฎาคม',
    'สิงหาคม',
    'กันยายน',
    'ตุลาคม',
    'พฤศจิกายน',
    'ธันวาคม',
  ];
  int monthNow = DateTime.now().month;
  String selectedMonth = 'มกราคม'; // เดือนเริ่มต้น
  int selectedYear = DateTime.now().year; // ปีปัจจุบัน
  var fine = 0;
  var interest = 0;

  Future<void> fetchMonthData(int year, String month) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('MonthlyIncome')
          .where('year', isEqualTo: year)
          .where('month', isEqualTo: month)
          .get();

      final totalquerySnapshot = querySnapshot.docs.length;
      print('เอกสารที่พบทั้งหมด : $totalquerySnapshot');

      if (querySnapshot.docs.isNotEmpty) {
        var totalFine = 0; // สร้างตัวแปรสำหรับเก็บค่าปรับทั้งหมด
        var totalInterest = 0;

        for (var index = 0; index < querySnapshot.docs.length; index++) {
          var doc = querySnapshot.docs[index];
          final data = doc.data() as Map<String, dynamic>;

          if (data.containsKey('fine')) {
            var fineData = data['fine'];

            if (fineData is int) {
              totalFine +=
                  fineData; // เพิ่มค่าปรับในแต่ละเอกสารเข้าไปใน totalFine
            } else if (fineData is List<int>) {
              totalFine += fineData.reduce(
                  (a, b) => a + b); // รวมค่าปรับใน List แล้วเพิ่มใน totalFine
            }
          }

          if (data.containsKey('interest')) {
            interest = data['interest'];
            totalInterest += interest;
          }
        }

        setState(() {
          fine = totalFine;
          interest = totalInterest;
        });
      } else {
        setState(() {
          fine = 0;
          interest = 0;
        });
      }
      print(fine);
    } catch (e) {
      print('เกิดข้อผิดพลาด: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('สรุปรายรับ'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      DropdownButton(
                        value: selectedMonth,
                        items: months.map((String month) {
                          return DropdownMenuItem(
                            value: month,
                            child: Text(month),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedMonth = newValue!;
                            fetchMonthData(selectedYear, selectedMonth);
                          });
                        },
                      ),
                      const SizedBox(width: 10.0),
                      DropdownButton(
                        value: selectedYear.toString(),
                        items: List.generate(
                            30,
                            (index) => (DateTime.now().year - 15 + index)
                                .toString()).map((String year) {
                          return DropdownMenuItem(
                            value: year,
                            child: Text(year),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedYear = int.parse(newValue!);
                            fetchMonthData(selectedYear, selectedMonth);
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'เดือน: $selectedMonth',
                        style: const TextStyle(fontSize: 20),
                      ),
                      Text(
                        'ปี: $selectedYear',
                        style: const TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // const Padding(
          //   padding: EdgeInsets.symmetric(vertical: 10),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       Text(
          //         'จำนวนคนที่เก็บเดือนที่เลือก:  ',
          //         style: TextStyle(fontSize: 20),
          //       ),
          //       Text(
          //         ' บาท',
          //         style: TextStyle(fontSize: 20),
          //       ),
          //     ],
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      spreadRadius: 3,
                      blurRadius: 10,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // const Padding(
                    //   padding: EdgeInsets.symmetric(vertical: 10),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       Text(
                    //         'เงินต้น: ',
                    //         style: TextStyle(fontSize: 20),
                    //       ),
                    //       Text(
                    //         ' บาท',
                    //         style: TextStyle(fontSize: 20),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    const Divider(
                      height: 5,
                      color: Colors.black,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'ดอกเบี้ย:',
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            '$interest บาท',
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      height: 5,
                      color: Colors.black,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'ค่าปรับ:',
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            '$fine บาท',
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      height: 5,
                      color: Colors.black,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'ยอดรวม:',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${fine + interest} บาท',
                            style: const TextStyle(
                                fontSize: 20,
                                color: Colors.red,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
