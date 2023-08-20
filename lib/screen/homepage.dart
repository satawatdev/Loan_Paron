import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var images =
      'https://i.pinimg.com/736x/5e/b7/4e/5eb74ed4073e2320a23e80fb3554a6c8.jpg';

  String searchText = "";
  String selectedStatus = 'ทั้งหมด';
  String selectedStatusday = 'รอบวัน';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("รายชื่อลูกหนี้"),
          actions: [
            DropdownButton<String>(
              dropdownColor: Colors.grey,
              borderRadius: BorderRadius.circular(10),
              icon: const Icon(
                Icons.arrow_drop_down_sharp,
                color: Colors.white,
              ),
              value: selectedStatus,
              onChanged: (newValue) {
                setState(() {
                  selectedStatus = newValue!;
                });
              },
              items: <String>[
                'ทั้งหมด',
                'ถึงกำหนดในอีก',
                'ถึงวันกำหนด',
                'เกินกำหนด'
              ].map<DropdownMenuItem<String>>(
                (String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(
                          color: Colors.white), // เปลี่ยนสีตรงนี้เป็นสีดำ
                    ),
                  );
                },
              ).toList(),
            ),
          ],
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('user').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            var docs = snapshot.data!.docs;
            docs.sort((a, b) => (b['timenow'] as Timestamp)
                .compareTo(a['timenow'] as Timestamp));

            var filteredData = docs.where((doc) {
              String name = doc['name'].toString().toLowerCase();
              String lastname = doc['lastname'].toString().toLowerCase();
              DateTime dateTime = (doc['timenow'] as Timestamp).toDate();
              int daysPassed = DateTime.now().difference(dateTime).inDays;

              int? countdownDurationInDays = int.tryParse(doc['day']);

              if (selectedStatus == 'ทั้งหมด') {
                return name.contains(searchText.toLowerCase()) ||
                    lastname.contains(searchText.toLowerCase());
              } else if (selectedStatus == 'ถึงกำหนดในอีก') {
                bool isOnTime = daysPassed < countdownDurationInDays!;
                return isOnTime &&
                    countdownDurationInDays == countdownDurationInDays &&
                    (name.contains(searchText.toLowerCase()) ||
                        lastname.contains(searchText.toLowerCase()));
              } else if (selectedStatus == 'ถึงวันกำหนด') {
                bool isExactlyDue = daysPassed == countdownDurationInDays;
                return isExactlyDue &&
                    countdownDurationInDays == countdownDurationInDays &&
                    (name.contains(searchText.toLowerCase()) ||
                        lastname.contains(searchText.toLowerCase()));
              } else if (selectedStatus == 'เกินกำหนด') {
                bool isOverdue = daysPassed > countdownDurationInDays!;
                return isOverdue &&
                    countdownDurationInDays == countdownDurationInDays &&
                    (name.contains(searchText.toLowerCase()) ||
                        lastname.contains(searchText.toLowerCase()));
              } else if (selectedStatusday == 'รอบวัน') {
                bool isOverdue = daysPassed > countdownDurationInDays!;
                return name.contains(searchText.toLowerCase()) ||
                    lastname.contains(searchText.toLowerCase());
              }

              return false;
            }).toList();

            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        searchText = value;
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

                      Timestamp timestamp = data['timenow'];
                      DateTime dateTime = timestamp.toDate();

                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 2,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                          child: ListTile(
                            onTap: () {
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
                                    'img': '${data['img']}'
                                  });
                              debugPrint('กดรายชื่อ');
                            },
                            // leading: CircleAvatar(
                            //   backgroundImage: NetworkImage(images),
                            // ),
                            title: Text(
                                'ชื่อ: ${data['name']} ${data['lastname']}'),
                            subtitle: StreamBuilder<int>(
                              stream: Stream.periodic(
                                  Duration(seconds: 1), (i) => i),
                              builder: (context, snapshot) {
                                DateTime now = DateTime.now();
                                Duration difference = now.difference(dateTime);
                                int daysPassed = difference.inDays;
                                int hoursPassed =
                                    difference.inHours.remainder(24);
                                int minutesPassed =
                                    difference.inMinutes.remainder(60);
                                int secondsPassed = snapshot.data ?? 0;

                                return Text(
                                  'เริ่มยืม: ${DateFormat('dd-MM-yyyy').format(dateTime)}\nเวลา: ${DateFormat('HH:mm:ss').format(dateTime)}',
                                );
                              },
                            ),
                            trailing: StreamBuilder<int>(
                              stream: Stream.periodic(
                                  Duration(seconds: 1), (i) => i),
                              builder: (context, snapshot) {
                                DateTime now = DateTime.now();
                                Duration difference = now.difference(dateTime);
                                int daysPassed = difference.inDays;

                                int? countdownDurationInDays =
                                    int.tryParse(data['day']);

                                bool isOverdue =
                                    daysPassed > countdownDurationInDays!;
                                bool isExactlyDue =
                                    daysPassed == countdownDurationInDays;
                                bool isOnTime =
                                    daysPassed <= countdownDurationInDays;

                                String countdownStatusText;
                                Color countdownStatusColor;
                                if (isOverdue) {
                                  countdownStatusText = 'เกินกำหนด';
                                  countdownStatusColor = Colors.red;

                                  int daysOverdue =
                                      daysPassed - countdownDurationInDays;
                                  countdownStatusText =
                                      'เกินกำหนด $daysOverdue วัน';
                                } else if (isExactlyDue) {
                                  countdownStatusText = 'ถึงวันกำหนด';
                                  countdownStatusColor = Colors.blue;
                                } else {
                                  countdownStatusText = 'ถึงกำหนดในอีก วัน';
                                  countdownStatusColor = Colors.green;
                                  int daysRemaining =
                                      countdownDurationInDays - daysPassed;
                                  countdownStatusText =
                                      'ถึงกำหนดในอีก $daysRemaining วัน';
                                }

                                return Column(
                                  children: [
                                    Text(
                                      'รอบ: $countdownDurationInDays วัน',
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      'ผ่านไป: $daysPassed วัน',
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      '$countdownStatusText',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: countdownStatusColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
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
