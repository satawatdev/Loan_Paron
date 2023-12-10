//! 23/8/2023 ตอนนี้ทำถึงเมื่อกดเก็บเงินแล้ว อัพเดทข้อมูลเข้าได้แล้วแต่อยากได้ เมื่อกดตอน awiate ให้มีหมุนๆรอเมื่อบันทึกข้อมูลเสร็จให้กลับมาเป้นเหมือนเดิมตรงปุ่มกดยืนยันการจ่ายเงิน dialog
//! 24/8/2023 ตอนนี้รู้แล้วปัญหาที่หน้า detail จำนวนเงินและดอกเบี้ยไม่อัพเดท เพราะเราส่ง อากูเม้นมาไม่ได้ดึงข้อมูลมาจากฐานข้อมูลโดยตรง พรุ่งนี้ทำต่อ

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:debtor_check/add_on/RoundedGreenButton.dart';
import 'package:debtor_check/add_on/form_feild.dart';
import 'package:debtor_check/add_on/richText.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

var datainterres = '';
var dataLoan = '';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
//todo: controller===================
  TextEditingController ctlCollectInterestAmountManual =
      TextEditingController(); //จำนวนดอกเบี้ย

  TextEditingController ctlCollectAmountOfFine =
      TextEditingController(); //จำนวนค่าปรับ
  TextEditingController ctlCollectLoanAmount =
      TextEditingController(); //เก็บเงินต้น

//todo funtion_______________

  //ฟังชันเคลีย controller
  clearControllers() {
    ctlCollectLoanAmount.clear();
    ctlCollectInterestAmountManual.clear();
    ctlCollectAmountOfFine.clear();
  }

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
                'img': '${arguments['img']}',
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

          datainterres = data['InterestAmount'];
          dataLoan = data['LoanAmount'];

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
                                                return Center(
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
                            const SizedBox(height: 7),
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
                                  text: Text('จ่ายหนี้ทั้งหมด'),
                                ),
                                const SizedBox(
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

    int InterestAmountInt = int.parse(arguments!['InterestAmount']);
    int xxx = int.parse(arguments!['LoanAmount']);
    total = InterestAmountInt + xxx + count;
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

      String fineInputLaon = ctlCollectAmountOfFine.text.trim();

      await MonthlyIncomecollection.add(
        {
          'interest': InterestAmountInt,
          'fine': fineInputLaon,
          'timenow': timenow,
          'month': thaiMonths[month - 1], // ส่งชื่อเดือนปัจจุบันเท่านั้น
          'year': year
        },
      );
    }

    double cardHeight = MediaQuery.of(context).size.height *
        0.5; // ให้ความสูงของ Card เป็น 60% ของความสูงหน้าจอ
    showDialog(
      barrierDismissible: false,
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
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'จ่ายหนี้ทั้งหมด',
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
                        // TextFormField(
                        //   keyboardType: TextInputType.number,
                        //   controller: ctlCollectLoanAmount,
                        //   decoration: const InputDecoration(
                        //     contentPadding: EdgeInsets.symmetric(
                        //         horizontal: 16, vertical: 16),
                        //     labelText: 'กรอกจำนวนเงินต้น',
                        //     prefixIcon: Icon(Icons.monetization_on_outlined),
                        //     // เพิ่มเส้นขอบด้านล่างด้วย UnderlineInputBorder
                        //     enabledBorder: UnderlineInputBorder(
                        //       borderSide:
                        //           BorderSide(color: Colors.grey), // สีขอบเส้น
                        //     ),
                        //     focusedBorder: UnderlineInputBorder(
                        //       borderSide: BorderSide(
                        //           color: Colors
                        //               .blue), // สีขอบเส้นเมื่อได้รับการโฟกัส
                        //     ),
                        //   ),
                        // ),
                        customtextspan(
                          text1: 'จำนวนดอกเบี้ย: ',
                          text2: '${arguments!['InterestAmount']} บาท',
                        ),
                        // TextFormField(
                        //   keyboardType: TextInputType.number,
                        //   controller: ctlCollectInterestAmountManual,
                        //   decoration: const InputDecoration(
                        //     contentPadding: EdgeInsets.symmetric(
                        //         horizontal: 16, vertical: 16),
                        //     labelText: 'กรอกจำนวนดอกเบี้ย',
                        //     prefixIcon: Icon(Icons.monetization_on_outlined),
                        //     // เพิ่มเส้นขอบด้านล่างด้วย UnderlineInputBorder
                        //     enabledBorder: UnderlineInputBorder(
                        //       borderSide:
                        //           BorderSide(color: Colors.grey), // สีขอบเส้น
                        //     ),
                        //     focusedBorder: UnderlineInputBorder(
                        //       borderSide: BorderSide(
                        //           color: Colors
                        //               .blue), // สีขอบเส้นเมื่อได้รับการโฟกัส
                        //     ),
                        //   ),
                        // ),
                        customtextspan(
                          text1: 'จำนวนค่าปรับ: ',
                          text2: '$count',
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          controller: ctlCollectAmountOfFine,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                            labelText: 'กรอกจำนวนค่าปรับ',
                            prefixIcon: Icon(Icons.monetization_on_outlined),
                            // เพิ่มเส้นขอบด้านล่างด้วย UnderlineInputBorder
                            enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey), // สีขอบเส้น
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors
                                      .blue), // สีขอบเส้นเมื่อได้รับการโฟกัส
                            ),
                          ),
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
                    // SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: RoundedGreenButton(
                            colors: Colors.green,
                            onPressed: () {
                              admonneyFormount();
                              payMonneyOnDelete();
                              clearControllers();
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
                              clearControllers();
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
      ),
    );
  }

//*ส่วนของโชไดอาลอก เก็บดอก
  showdDialogmonenney(BuildContext context) {
    final Map<String, dynamic>? arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    int InterestAmountInt = int.parse(arguments!['InterestAmount']);
    int LoenAmountInt = int.parse(arguments!['LoanAmount']);

    total = InterestAmountInt + LoenAmountInt;

    // void admonneyFormount() async {
    //   DateTime timenow = DateTime.now();
    //   int month = timenow.month;
    //   int year = timenow.year;

    //   final List<String> thaiMonths = [
    //     'มกราคม',
    //     'กุมภาพันธ์',
    //     'มีนาคม',
    //     'เมษายน',
    //     'พฤษภาคม',
    //     'มิถุนายน',
    //     'กรกฎาคม',
    //     'สิงหาคม',
    //     'กันยายน',
    //     'ตุลาคม',
    //     'พฤศจิกายน',
    //     'ธันวาคม'
    //   ];

    //   CollectionReference MonthlyIncomecollection =
    //       FirebaseFirestore.instance.collection('MonthlyIncome');

    //   await MonthlyIncomecollection.add(
    //     {
    //       'interest': InterestAmountInt,
    //       'fine': count,
    //       'timenow': timenow,
    //       'month': thaiMonths[month - 1], // ส่งชื่อเดือนปัจจุบันเท่านั้น
    //       'year': year
    //     },
    //   );
    // }

    //ฟังชั่นจ่ายค่าปรับโดยจะเก็บเข้าในยอดรวมแต่ละเดือนเลย
    Amountoffine() async {
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

      String userInput = ctlCollectInterestAmountManual.text.trim();
      String fineInput = ctlCollectAmountOfFine.text.trim();

      await MonthlyIncomecollection.add(
        {
          'interest': userInput, // ให้ใช้ค่าที่ผู้ใช้กรอกเข้ามา
          'fine': fineInput,
          'timenow': timenow,
          'month': thaiMonths[month - 1],
          'year': year
        },
      );
    }

    //ฟังชั่นจ่ายดอกเบี่้ย
    payinterastmonney() async {
      try {
        // เตรียม Firebase
        final Future<FirebaseApp> firebase = Firebase.initializeApp();
        CollectionReference usercollection =
            FirebaseFirestore.instance.collection('user');

        // ตรวจสอบว่ามีการกรอกข้อมูลหรือไม่
        String userInput = ctlCollectInterestAmountManual.text.trim();
        int calculatedValue;

        if (userInput.isEmpty) {
          // ถ้าไม่มีการกรอกข้อมูลให้ใช้ค่าที่มีอยู่ในฐานข้อมูล
          int interestAmountFromDatabase =
              int.tryParse(arguments['InterestAmount']) ?? 0;
          calculatedValue = interestAmountFromDatabase;
        } else {
          // ถ้ามีการกรอกข้อมูลให้ทำการคำนวณ
          int interestAmountFromDatabase =
              int.tryParse(arguments['InterestAmount']) ?? 0;
          int userInputValue = int.tryParse(userInput) ?? 0;
          calculatedValue = interestAmountFromDatabase - userInputValue;
        }
        ;

        // ตรวจสอบว่ามีการกรอกข้อมูลหรือไม่
        String userInputLoen = ctlCollectLoanAmount.text.trim();
        int LoencalculatedValue;

        if (userInputLoen.isEmpty) {
          // ถ้าไม่มีการกรอกข้อมูลให้ใช้ค่าที่มีอยู่ในฐานข้อมูล
          int LoenAmountFromDatabase =
              int.tryParse(arguments['LoanAmount']) ?? 0;
          LoencalculatedValue = LoenAmountFromDatabase;
        } else {
          // ถ้ามีการกรอกข้อมูลให้ทำการคำนวณ
          int LoneAmountFromDatabase =
              int.tryParse(arguments['LoanAmount']) ?? 0;
          int userInputValue = int.tryParse(userInputLoen) ?? 0;
          LoencalculatedValue = LoneAmountFromDatabase - userInputValue;
        }

        // ทำการ update ข้อมูลใน Firestore
        await usercollection.doc(arguments!['docID']).update({
          'InterestAmount': calculatedValue.toString(),
          'LoanAmount': LoencalculatedValue.toString(),
          'timeInterest': timenow
        });

        Amountoffine();

        // แสดง SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('จ่ายดอกเบี้ยและค่าปรับสำเร็จ!'),
          ),
        );

        // ปิดหน้าต่าง
        Navigator.pop(context);

        // ทำการอัพเดทข้อมูล
        // admonneyFormount();
      } catch (e) {
        print('ออก catch จ่ายดอกเบี้ย เออเร่อ =' + e.toString());
      }
    }

    double cardHeight = MediaQuery.of(context).size.height *
        0.8; // ให้ความสูงของ Card เป็น 60% ของความสูงหน้าจอ
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => Dialog(
        child: Container(
          height: cardHeight,
          child: Card(
            // elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'เก็บดอกเบี้ย/เงินกู้',
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
                          text1: 'จำนวนเงินกู้: ',
                          text2: '${dataLoan} บาท',
                          // text2: '${arguments!['InterestAmount']} บาท',
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          controller: ctlCollectLoanAmount,
                          onChanged: (value) {
                            // ค่าที่ได้จากฐานข้อมูล
                            var LoanAmountFromDatabase =
                                int.tryParse(arguments['LoanAmount']) ?? 0;

                            // แปลงค่าที่กรอกจาก String เป็น int
                            int userInput = int.tryParse(value) ?? 0;

                            // ทำการลบค่าที่กรอกจากค่าที่ได้จากฐานข้อมูล
                            var Loantotal = LoanAmountFromDatabase - userInput;

                            // แสดงผลลัพธ์ที่คำนวณได้ใน console
                            print('❤️ผลลัพธ์คำนวณ❤️: $Loantotal');
                          },
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                            labelText: 'กรอกจำนวนเงินกู้',
                            prefixIcon: Icon(Icons.monetization_on_outlined),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        customtextspan(
                          text1: 'จำนวนดอกเบี้ย: ',
                          text2: '${datainterres} บาท',
                          // text2: '${arguments!['InterestAmount']} บาท',
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          controller: ctlCollectInterestAmountManual,
                          onChanged: (value) {
                            // ค่าที่ได้จากฐานข้อมูล
                            var interestAmountFromDatabase =
                                int.tryParse(arguments['InterestAmount']) ?? 0;

                            // แปลงค่าที่กรอกจาก String เป็น int
                            int userInput = int.tryParse(value) ?? 0;

                            // ทำการลบค่าที่กรอกจากค่าที่ได้จากฐานข้อมูล
                            var interestotal =
                                interestAmountFromDatabase - userInput;

                            // แสดงผลลัพธ์ที่คำนวณได้ใน console
                            print('❤️ผลลัพธ์คำนวณ❤️: $interestotal');
                          },
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                            labelText: 'กรอกจำนวนดอกเบี้ย',
                            prefixIcon: Icon(Icons.monetization_on_outlined),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        customtextspan(
                          text1: 'จำนวนค่าปรับ: ',
                          text2: '$count',
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          controller: ctlCollectAmountOfFine,
                          onChanged: (value) {
                            // ล็อกค่าที่ผู้ใช้กรอก
                            print('ค่าที่กรอก: $value');
                          },
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                            labelText: 'กรอกจำนวนค่าปรับ',
                            prefixIcon: Icon(Icons.monetization_on_outlined),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: customtextspan(
                            text1: 'รวม: ',
                            text2: '$total บาท',
                          ),
                        ),
                      ],
                    ),
                    // SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: RoundedGreenButton(
                            colors: Colors.green,
                            onPressed: () async {
                              clearControllers();
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
                              // ล้างข้อมูลที่กรอกใน TextFormFields
                              clearControllers();
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
