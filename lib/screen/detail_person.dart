import 'package:debtor_check/add_on/RoundedGreenButton.dart';
import 'package:debtor_check/add_on/richText.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    //todo รับข้อมูลที่ส่งมาจากหน้าก่อนหน้า
    final Map<String, dynamic>? arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    return Scaffold(
      appBar: AppBar(
        title: Text('รายละเอียด'),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.delete))],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ImagePage(),
                  ),
                );
                // _showImageDialog(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'ภาพสัญญากู้ยืมเงิน',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Image.network(
                        'https://www.dharmniti.co.th/wp-content/uploads/2019/09/1-6-300x193.png', // URL ของรูปภาพที่ต้องการแสดงใน Card
                        fit: BoxFit.cover,
                        height: 200,
                      ),
                    ],
                  ),
                ),
              ),
            ),
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
                            '${arguments!['name'] + ' ' + arguments['lastname']} ',
                      ),
                      customtextspan(
                          text1: 'อายุ:  ',
                          text2: '${arguments['old']}' + ' ปี'),
                      customtextspan(
                        text1: 'เบอร์โทร:  ',
                        text2: '${arguments['phone']}',
                      ),
                      customtextspan(
                        text1: 'ที่อยู่:  ',
                        text2: '${arguments['address']}',
                      ),
                    ],
                  ),
                ),
              ),
            ),
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
                        height: 1, // ความหนาของเส้น Divider
                        child: Container(
                          color: Colors.black, // สีของเส้น Divider
                        ),
                      ),
                      customtextspan(
                        text1: 'เริ่มกู้เมื่อวันที่: ',
                        text2: '1/8/2566 ',
                      ),
                      customtextspan(
                        text1: 'จำนวนเงินกู้: ',
                        text2: '${arguments['LoanAmount'] + ' บาท'}',
                      ),
                      customtextspan(
                        text1: 'จำนวนดอกเบี้ย: ',
                        text2: '${arguments['InterestAmount'] + ' บาท'}',
                      ),
                      customtextspan(
                        text1: 'จ่ายดอกเบี้ยทุก: ',
                        text2: '${arguments['day']}',
                      ),
                    ],
                  ),
                ),
              ),
            ),
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
                        height: 1, // ความหนาของเส้น Divider
                        child: Container(
                          color: Colors.black, // สีของเส้น Divider
                        ),
                      ),
                      customtextspan(
                        text1: 'จำนวนเงินกู้: ',
                        text2: '1,000 บาท ',
                      ),
                      customtextspan(
                        text1: 'จำนวนดอกเบี้ย: ',
                        text2: '200 บาท',
                      ),
                      SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          RoundedGreenButton(
                            colors: Colors.green,
                            onPressed: () {},
                            text: 'เก็บต้น',
                          ),
                          RoundedGreenButton(
                            colors: Colors.green,
                            onPressed: () {
                              showdDialogmonenney(context);
                            },
                            text: 'เก็บดอกเบี้ย',
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
  }
}

//*ส่วนของโชไดอาลอก เก็บดอก
void showdDialogmonenney(BuildContext context) {
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
                customtextspan(
                  text1: 'จำนวนดอกเบี้ย: ',
                  text2: '200 บาท',
                ),
                SizedBox(height: 100),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: RoundedGreenButton(
                        colors: Colors.green,
                        onPressed: () {},
                        text: 'ยืนยัน',
                      ),
                    ),
                    Expanded(
                      child: RoundedGreenButton(
                        colors: Colors.red,
                        onPressed: () {},
                        text: 'ยกเลิก',
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

//*ส่วนของโชไดอาลอก ภาพ
void _showImageDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (_) => Dialog(
      child: Image.network(
        'https://www.dharmniti.co.th/wp-content/uploads/2019/09/1-6-300x193.png',
        fit: BoxFit.contain,
      ),
    ),
  );
}

//*ส่วนของภาพหน้าใหญ่
class ImagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ภาพสัญญากู้ยืมเงิน'),
      ),
      body: Center(
        child: Image.network(
          'https://www.dharmniti.co.th/wp-content/uploads/2019/09/1-6-300x193.png',
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
