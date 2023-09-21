//! 23/8/2023 ตอนนี้ทำถึงเมื่อกดเก็บเงินแล้ว อัพเดทข้อมูลเข้าได้แล้วแต่อยากได้ เมื่อกดตอน awiate ให้มีหมุนๆรอเมื่อบันทึกข้อมูลเสร็จให้กลับมาเป้นเหมือนเดิมตรงปุ่มกดยืนยันการจ่ายเงิน dialog
//! 24/8/2023 ตอนนี้รู้แล้วปัญหาที่หน้า detail จำนวนเงินและดอกเบี้ยไม่อัพเดท เพราะเราส่ง อากูเม้นมาไม่ได้ดึงข้อมูลมาจากฐานข้อมูลโดยตรง พรุ่งนี้ทำต่อ

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:debtor_check/add_on/RoundedGreenButton.dart';
import 'package:debtor_check/add_on/richText.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
//todo funtion_______________
  late int count;
  late int total;
//todo Variable Declaration(ตัวแปล)_______________
  bool isSaving = false; // ตัวแปรสำหรับเก็บสถานะการบันทึกข้อมูล (loading)
  DateTime timenow = DateTime.now();
  // DateTime timenow = DateTime(0, 0, 0);
  var imageUrls = [];

  @override
  Widget build(BuildContext context) {
    //todo รับข้อมูลที่ส่งมาจากหน้าก่อนหน้า
    final Map<String, dynamic>? arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    //*คำนวนค่าปรับ
    int payfine = arguments!['daysOverdue'] * 100;
    count = payfine;
    // String formattedAmount = currencyFormatter.format(pay_fine);
    // count = formattedAmount;
    return Scaffold(
      appBar: AppBar(
        title: Text('รายละเอียด'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/EditPage', arguments: {
                'docID': '${arguments['docID']}',
              });
            },
            icon: Icon(Icons.edit_square),
            tooltip: 'แก้ไขข้อมูล',
          ),
          // IconButton(
          //   onPressed: () {},
          //   icon: Icon(Icons.delete_forever),
          //   tooltip: 'ลบข้อมูลทั้งหมด',
          // )
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('user')
            .doc('${arguments['docID']}')
            .snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(
              child: Text('Document not found.'),
            );
          }

          //* เมื่อคุณมีข้อมูลจาก Firestore ที่stream มาจาก body
          Map<String, dynamic> data =
              (snapshot.data!.data() as Map<String, dynamic>);
          imageUrls = data['img'];

          //* เอาเวลาจาก Firestore เป็น timestamp แปลงเป็น datetime
          var selectedTime = (data['selectedtime'] as Timestamp).toDate();
          //* เอา datime ที่ได้มา format
          var formatselectedTime =
              DateFormat('dd-MM-yyyy').format(selectedTime);

          return SingleChildScrollView(
            child: Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'ภาพสัญญากู้ยืมเงิน',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 15),
                  imageUrls.isEmpty
                      ? Text('ไม่มีรูปภาพ...')
                      : SizedBox(
                          height: 250, // กำหนดความสูงของส่วนภาพ
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: imageUrls.length,
                            itemBuilder: (context, imageIndex) {
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ImagePage(),
                                      settings: RouteSettings(arguments: {
                                        'img': imageUrls[imageIndex]
                                      }),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Card(
                                    elevation: 4.0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ConstrainedBox(
                                          constraints: const BoxConstraints(
                                            minWidth: 200,
                                            minHeight: 200,
                                            maxWidth: 200,
                                            maxHeight: 200,
                                          ),
                                          child: FutureBuilder<void>(
                                            future: precacheImage(
                                              NetworkImage(
                                                  imageUrls[imageIndex]),
                                              context,
                                            ),
                                            builder: (BuildContext context,
                                                AsyncSnapshot<void> snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return const Center(
                                                  child: Column(
                                                    children: [
                                                      CircularProgressIndicator(),
                                                      SizedBox(height: 10),
                                                      Text('กำลังโหลดภาพ...'),
                                                    ],
                                                  ),
                                                );
                                              } else {
                                                return Image.network(
                                                  imageUrls[imageIndex],
                                                  fit: BoxFit.cover,
                                                );
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                  //todo Widged สถานะ
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Card(
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                customtextspancolor(
                                  text1: 'สถานะ : ',
                                  text2: "${arguments['countdownStatusText']}",
                                  colortext1: Colors.black,
                                  colortext2:
                                      arguments['countdownStatusColor'] != null
                                          ? arguments['countdownStatusColor']
                                          : ' 0 บาท',
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 1, // ความหนาของเส้น Divider
                              child: Container(
                                color: Colors.black, // สีของเส้น Divider
                              ),
                            ),
                            SizedBox(
                              height: 0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                customtextspancolor(
                                  text1: 'ค่าปรับ : ',
                                  text2: '$count บาท',
                                  colortext1: Colors.black,
                                  colortext2: arguments['countdownStatusColor'],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  //todo Widged ข้อมูลส่วนุคคล

                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Card(
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'ข้อมูลบุคคล',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 1, // ความหนาของเส้น Divider
                              child: Container(
                                color: Colors.black, // สีของเส้น Divider
                              ),
                            ),
                            customtextspan(
                              text1: 'ชื่อ-สกุล:  ',
                              text2:
                                  '${data['name'] + ' ' + data['lastname']} ',
                            ),
                            customtextspan(
                                text1: 'อายุ:  ',
                                text2: '${data['old']}' + ' ปี'),
                            customtextspan(
                              text1: 'เบอร์โทร:  ',
                              text2: '${data['phone']}',
                            ),
                            customtextspan(
                              text1: 'ที่อยู่:  ',
                              text2: '${data['address']}',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  //todo Widged รายละอียดการกู้เงิน

                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Card(
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'รายละเอียดกู้เงิน',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 1, //* ความหนาของเส้น Divider
                              child: Container(
                                color: Colors.black, //* สีของเส้น Divider
                              ),
                            ),
                            customtextspan(
                              text1: 'เริ่มกู้เมื่อวันที่: ',
                              text2: formatselectedTime,
                            ),
                            customtextspan(
                              text1: 'จ่ายดอกเบี้ยทุก: ',
                              text2: '${arguments['day']} วัน',
                            ),
                            customtextspan(
                              text1: 'ผ่านมาแล้ว: ',
                              text2: '${arguments['daysPassed']} วัน',
                            ),
                            customtextspan(
                              text1: 'จำนวนเงินกู้: ',
                              text2: '${data['LoanAmount'] + ' บาท'}',
                            ),
                            customtextspan(
                              text1: 'จำนวนดอกเบี้ย: ',
                              text2: '${data['InterestAmount'] + ' บาท'}',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  //todo Widged จัดการเงินกู้
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Card(
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'จัดการเงินกู้',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 1, //* ความหนาของเส้น Divider
                              child: Container(
                                color: Colors.black, //* สีของเส้น Divider
                              ),
                            ),
                            customtextspan(
                              text1: 'จำนวนเงินกู้: ',
                              text2: '${data['LoanAmount'] + ' บาท'}',
                            ),
                            customtextspan(
                              text1: 'จำนวนดอกเบี้ย: ',
                              text2: '${data['InterestAmount'] + ' บาท'}',
                            ),
                            customtextspan(
                              text1: 'ค่าปรับ: ',
                              text2: '$count บาท ',
                            ),
                            SizedBox(height: 7),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                RoundedGreenButton(
                                  colors: Colors.green,
                                  onPressed: () async {
                                    setState(() {
                                      showdDialogpaymoney(context);
                                    });
                                  },
                                  text: Text('จ่ายเงิน'),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                RoundedGreenButton(
                                  colors: Colors.green,
                                  onPressed: () async {
                                    showdDialogmonenney(context);
                                  },
                                  text: Text('จ่ายดอกเบี้ย'),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  //*ส่วนของโชไดอาลอก เก็บเงินต้น
  showdDialogpaymoney(BuildContext context) {
    Map<String, dynamic>? arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    int xx = int.parse(arguments!['InterestAmount']);
    int xxx = int.parse(arguments!['LoanAmount']);
    total = xx + xxx + count;
    payMonneyOnDelete() async {
      //เตรี่ยม firebase
      final Future<FirebaseApp> firebase = Firebase.initializeApp();
      CollectionReference usercollection =
          FirebaseFirestore.instance.collection('user');

      await usercollection.doc(arguments!['docID'])
        ..delete();

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('อัพเดทข้อมูลสำเร็จ!'),
        ),
      );
      Navigator.pop(context);
    }

    double cardHeight = MediaQuery.of(context).size.height *
        0.4; // ให้ความสูงของ Card เป็น 60% ของความสูงหน้าจอ
    showDialog(
      context: context,
      builder: (_) => Dialog(
        child: Container(
          height: cardHeight,
          child: Card(
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'เก็บเงิน',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 1, // ความหนาของเส้น Divider
                    child: Container(
                      color: Colors.black, // สีของเส้น Divider
                    ),
                  ),
                  SizedBox(
                    height: 30, // ความหนาของเส้น Divider
                    child: Container(
                        // color: Colors.black, // สีของเส้น Divider
                        ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      customtextspan(
                        text1: 'จำนวนเงินต้น: ',
                        text2: '${arguments!['LoanAmount']} บาท',
                      ),
                      customtextspan(
                        text1: 'จำนวนดอกเบี้ย: ',
                        text2: '${arguments!['InterestAmount']} บาท',
                      ),
                      customtextspan(
                        text1: 'จำนวนค่าปรับ: ',
                        text2: '$count',
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      customtextspan(
                        text1: 'รวม: ',
                        text2: '$total บาท',
                      ),
                    ],
                  ),
                  SizedBox(height: 80),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: RoundedGreenButton(
                          colors: Colors.green,
                          onPressed: () {
                            payMonneyOnDelete();
                          },
                          text: isSaving
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Text('ยืนยัน'),
                        ),
                      ),
                      Expanded(
                        child: RoundedGreenButton(
                          colors: Colors.red,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          text: Text('ยกเลิก'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

//*ส่วนของโชไดอาลอก เก็บดอก
  showdDialogmonenney(BuildContext context) {
    final Map<String, dynamic>? arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    int InterestAmountInt = int.parse(arguments!['InterestAmount']);
    total = InterestAmountInt + count;

    void admonneyFormount() async {
      DateTime timenow = DateTime.now();
      int month = timenow.month;
      int year = timenow.year;

      final List<String> thaiMonths = [
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
        'ธันวาคม'
      ];

      CollectionReference MonthlyIncomecollection =
          FirebaseFirestore.instance.collection('MonthlyIncome');

      await MonthlyIncomecollection.add(
        {
          'interest': InterestAmountInt,
          'fine': count,
          'timenow': timenow,
          'month': thaiMonths[month - 1], // ส่งชื่อเดือนปัจจุบันเท่านั้น
          'year': year
        },
      );
    }

    payinterastmonney() async {
      //เตรี่ยม firebase

      try {
        print('เข้า try จ่ายดอกเบี้ย');
        final Future<FirebaseApp> firebase = Firebase.initializeApp();
        CollectionReference usercollection =
            FirebaseFirestore.instance.collection('user');

        await usercollection
            .doc(arguments!['docID'])
            .update({'InterestAmount': '0', 'timeInterest': timenow});

        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('จ่ายดอกเบี้ยและค่าปรับสำเร็จ!'),
          ),
        );

        Navigator.pop(context);
        admonneyFormount();
      } catch (e) {
        print('ออก catch จ่ายดอกเบี้ย เออเร่อ =' + e.toString());
      }
    }

    double cardHeight = MediaQuery.of(context).size.height *
        0.4; // ให้ความสูงของ Card เป็น 60% ของความสูงหน้าจอ
    showDialog(
      context: context,
      builder: (_) => Dialog(
        child: Container(
          height: cardHeight,
          child: Card(
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'เก็บดอกเบี้ย',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 1, // ความหนาของเส้น Divider
                    child: Container(
                      color: Colors.black, // สีของเส้น Divider
                    ),
                  ),
                  SizedBox(
                    height: 30, // ความหนาของเส้น Divider
                    child: Container(
                        // color: Colors.black, // สีของเส้น Divider
                        ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      customtextspan(
                        text1: 'จำนวนดอกเบี้ย: ',
                        text2: '${arguments!['InterestAmount']} บาท',
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      customtextspan(
                        text1: 'จำนวนค่าปรับ: ',
                        text2: '$count',
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      customtextspan(
                        text1: 'รวม: ',
                        text2: '$total บาท',
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: RoundedGreenButton(
                          colors: Colors.green,
                          onPressed: () async {
                            payinterastmonney();
                          },
                          text: isSaving
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Text('ยืนยัน'),
                        ),
                      ),
                      Expanded(
                        child: RoundedGreenButton(
                          colors: Colors.red,
                          onPressed: () async {
                            Navigator.pop(context);
                          },
                          text: Text('ยกเลิก'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//*ส่วนของภาพหน้าใหญ่
class ImagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    return Scaffold(
      appBar: AppBar(
        title: Text('ภาพสัญญากู้ยืมเงิน'),
      ),
      body: Center(
        child: Image.network(
          '${arguments!['img']}',
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
