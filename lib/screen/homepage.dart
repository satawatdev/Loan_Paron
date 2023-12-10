import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:marquee/marquee.dart';

// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   //?ตัวแปล----------------------------------------------------------------------
//   //?timenow
//   DateTime timeNow = DateTime.now();
//   //?ค่าDropdown
//   // String valueDropdown = "ทั้งหมด";
//   String dropdownValue = 'ทั้งหมด';
//   int dropdownValueday = 0;

//   //?เก็บค่าค้นหา
//   String searchText = "";

//   int count = 0; //* เพิ่มตัวแปรนับจำนวนรายการที่ตรงกับสถานะ

//   List<String> text = [
//     'เกินกำหนด',
//     'ยังไม่ถึงกำหนด',
//     'ถึงกำหนด',
//   ];

//   //todo:function----------------------------------------------------------------

//   //todo CallDataRealtime
//   Future<List<DocumentSnapshot>> fetchUserDataRealtime() async {
//     final stream = FirebaseFirestore.instance
//         .collection('user')
//         .orderBy('timenow', descending: true)
//         .snapshots();

//     final querySnapshot = await stream.first;

//     return querySnapshot.docs;
//   }

// //!widgets
//   Widget buildUserDataList(List<DocumentSnapshot> snapshots) => Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               decoration: const InputDecoration(
//                 hintText: 'ค้นหาชื่อหรือนามสกุล...',
//                 prefixIcon: Icon(Icons.search),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.all(Radius.circular(8.0)),
//                 ),
//               ),
//               onChanged: (value) {
//                 setState(() {
//                   searchText = value;
//                 });
//               },
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: snapshots.length,
//               itemBuilder: (context, index) {
//                 print('ค่ารายชื่อทั้งหมดมี = ' + snapshots.length.toString());
//                 var userData = snapshots[index].data() as Map<String, dynamic>;
//                 // todo: logic วันเวลาสถานะที่จะแสดง________________________________________
//                 //*ค่าวันเวลาจากดาต้า
//                 var timeInterest =
//                     (userData['timeInterest'] as Timestamp).toDate();
//                 var selectedtime =
//                     (userData['selectedtime'] as Timestamp).toDate();
//                 //*ค่าวันที่กำหนดจ่ายหนี้
//                 String dayString = userData['day'];
//                 int countdown = int.parse(dayString); // แปลง String เป็น int
//                 //*เวาลาปัจจุบัน
//                 DateTime currentDate = DateTime.now();
//                 //*ค่าเริ่มจากวันที่ยืม
//                 int daysPassed =
//                     currentDate.difference(timeInterest).inDays.abs();
//                 //*ค่าวันที่เหลือ
//                 int daysRemaining = daysPassed - countdown;
//                 // todo:________________________________________________________________

//                 //todo: เช็คสถานะและแสดงข้อมูลตามที่คุณต้องการdropdown________________________
//                 bool shouldShowItem = false;
//                 String statusText = ''; // สร้างตัวแปรเพื่อเก็บข้อความสถานะ
//                 Color statusColor =
//                     Colors.black; // สร้างตัวแปรเพื่อเก็บสีของข้อความสถานะ
//                 //todo: logic dropdown_______________________________________________
//                 if (dropdownValue == 'ถึงกำหนด' && daysPassed == countdown) {
//                   shouldShowItem = true;
//                   statusText = 'ถึงกำหนด';
//                   statusColor = Colors.green;
//                 } else if (dropdownValue == 'เกินกำหนด' &&
//                     daysPassed > countdown) {
//                   shouldShowItem = true;
//                   statusText = 'เกินกำหนด $daysRemaining วัน';
//                   statusColor = Colors.red;
//                 } else if (dropdownValue == 'ยังไม่ถึงกำหนด' &&
//                     daysPassed < countdown) {
//                   shouldShowItem = true;
//                   statusText = 'ยังไม่ถึงกำหนด';
//                   statusColor = Colors.blue;
//                 } else if (dropdownValue == 'ทั้งหมด') {
//                   shouldShowItem = true;
//                   statusText = 'ทั้งหมด';
//                 }
//                 // todo:_______________________________________________________ _________
//                 // List<Map<String, dynamic>> itemStatusList = [];
//                 if (shouldShowItem) {
//                   final firstName = userData['name'].toString().toLowerCase();
//                   final lastName =
//                       userData['lastname'].toString().toLowerCase();
//                   final query = searchText.toLowerCase();

//                   if (firstName.contains(query) || lastName.contains(query)) {
//                     return Padding(
//                       padding: const EdgeInsets.all(4.0),
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(8),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.grey.withOpacity(0.5),
//                               spreadRadius: 1,
//                               blurRadius: 2,
//                               offset: Offset(0, 1),
//                             ),
//                           ],
//                         ),
//                         child: ListTile(
//                           title: Text(
//                               'ชื่อ: ${userData['name']} ${userData['lastname']}'),
//                           // subtitle: Text(
//                           //   'เริ่มยืม:${DateFormat('dd-MM-yyyy').format(selectedtime)} ',
//                           // ),
//                           trailing: SingleChildScrollView(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 statusText == 'ทั้งหมด'
//                                     ? daysPassed < countdown
//                                         ? const Text(
//                                             'ยังไม่ถึงกำหนด',
//                                             style:
//                                                 TextStyle(color: Colors.blue),
//                                           )
//                                         : daysPassed == countdown
//                                             ? const Text(
//                                                 'ถึงกำหนด',
//                                                 style: TextStyle(
//                                                     color: Colors.green),
//                                               )
//                                             : Text(
//                                                 'เกินกำหนด $daysRemaining วัน',
//                                                 style: TextStyle(
//                                                     color: Colors.red),
//                                               )
//                                     : Text(
//                                         statusText,
//                                         style: TextStyle(color: statusColor),
//                                       ),
//                                 Text('จ่ายดอกเบี้ยทุก: $countdown วัน'),
//                                 Text('ผ่านมาแล้ว: $daysPassed วัน'),
//                                 daysPassed > countdown
//                                     ? SizedBox.shrink()
//                                     : Text(
//                                         'ถึงกำหนดในอีก: ${daysRemaining.abs()} วัน'),
//                               ],
//                             ),
//                           ),
//                           onTap: () {
//                             // var countdownStatusText = 1;
//                             // var daysOverdue = 1;
//                             // var countdownStatusColor = Colors.green;

//                             var countdownStatusText = statusText;
//                             var daysOverdue = daysRemaining;

//                             var countdownStatusColor = statusText == 'ถึงกำหนด'
//                                 ? Colors.green
//                                 : Colors.red;

//                             if (statusText == 'ทั้งหมด' ||
//                                 statusText == 'ถึงกำหนด' ||
//                                 statusText == 'เกินกำหนด' ||
//                                 statusText == 'ยังไม่ถึงกำหนด') {
//                               countdownStatusText = daysPassed < countdown
//                                   ? 'ยังไม่ถึงกำหนด'
//                                   : daysPassed == countdown
//                                       ? 'ถึงกำหนด'
//                                       : 'เกินกำหนด $daysRemaining วัน';
//                               daysOverdue =
//                                   daysPassed > countdown ? daysRemaining : 0;
//                               countdownStatusColor = daysPassed < countdown
//                                   ? Colors.blue
//                                   : daysPassed == countdown
//                                       ? Colors.green
//                                       : Colors.red;
//                             }

//                             Navigator.pushNamed(context, '/detail', arguments: {
//                               'docID': snapshots[index].id,
//                               'name': '${userData['name']}',
//                               'lastname': '${userData['lastname']}',
//                               'old': '${userData['old']}',
//                               'phone': '${userData['phone']}',
//                               'address': '${userData['address']}',
//                               'LoanAmount': '${userData['LoanAmount']}',
//                               'InterestAmount': '${userData['InterestAmount']}',
//                               'day': '${userData['day']}',
//                               'img': '${userData['img']}',
//                               'countdownStatusText': countdownStatusText,
//                               'countdownStatusColor': countdownStatusColor,
//                               'daysOverdue': daysOverdue,
//                               'daysPassed': daysPassed,
//                             });

//                             // Navigator.pushNamed(context, '/detail', arguments: {
//                             //   'docID': snapshots[index].id,
//                             //   'name': '${userData['name']}',
//                             //   'lastname': '${userData['lastname']}',
//                             //   'old': '${userData['old']}',
//                             //   'phone': '${userData['phone']}',
//                             //   'address': '${userData['address']}',
//                             //   'LoanAmount': '${userData['LoanAmount']}',
//                             //   'InterestAmount': '${userData['InterestAmount']}',
//                             //   'day': '${userData['day']}',
//                             //   'img': '${userData['img']}',
//                             //   // 'shouldShowItem': '$shouldShowItem',
//                             //   'countdownStatusText': statusText,
//                             //   // 'countdownStatusColor': countdownStatusColor,
//                             //   // 'daysOverdue': daysOverdue
//                             // });
//                           },
//                         ),
//                       ),
//                     );
//                   }
//                 }

//                 return SizedBox.shrink();
//               },
//             ),
//           ),
//         ],
//       );

// //!Mainwidget
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => FocusScope.of(context).unfocus(),
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text("รายชื่อลูกหนี้"),
//           actions: [
//             Row(
//               children: [
//                 DropdownButton<String>(
//                   dropdownColor: Colors.white,
//                   borderRadius: BorderRadius.circular(10),
//                   icon: const Icon(
//                     Icons.arrow_drop_down_sharp,
//                     color: Colors.blueGrey,
//                   ),
//                   value: dropdownValue,
//                   onChanged: (newValue) {
//                     setState(() {
//                       dropdownValue = newValue!;
//                     });
//                   },
//                   items: <String>[
//                     'ทั้งหมด',
//                     'ถึงกำหนด',
//                     'เกินกำหนด',
//                     'ยังไม่ถึงกำหนด'
//                   ].map<DropdownMenuItem<String>>(
//                     (String value) {
//                       return DropdownMenuItem<String>(
//                         value: value,
//                         child: Text(
//                           value,
//                           style: const TextStyle(
//                               color: Colors.black), // เปลี่ยนสีตรงนี้เป็นสีดำ
//                         ),
//                       );
//                     },
//                   ).toList(),
//                 ),
//                 SizedBox(
//                   width: 3,
//                 ),
//                 IconButton(onPressed: () {}, icon: Icon(Icons.refresh))
//               ],
//             ),
//           ],
//         ),
//         body: FutureBuilder<List<DocumentSnapshot>>(
//           future: fetchUserDataRealtime(),
//           builder: (context, snapshot) {
//             if (!snapshot.hasData) {
//               return const Center(
//                 child: CircularProgressIndicator(),
//               );
//             } else if (snapshot.hasError) {
//               return Center(
//                 child: Text('Error: ${snapshot.error}'),
//               );
//             } else {
//               final filteredData = snapshot.data!.where((userData) {
//                 final firstName = userData['name'].toString().toLowerCase();
//                 final lastName = userData['lastname'].toString().toLowerCase();
//                 final query = searchText.toLowerCase();
//                 return firstName.contains(query) || lastName.contains(query);
//               }).toList();
//               return buildUserDataList(filteredData);
//             }
//           },
//         ),
//       ),
//     );
//   }
// }

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime timeNow = DateTime.now();
  String dropdownValue = 'ทั้งหมด';
  int dropdownValueday = 0;
  String searchText = "";
  int count = 0;

  List<String> text = ['เกินกำหนด', 'ยังไม่ถึงกำหนด', 'ถึงกำหนด'];

  // Future<List<DocumentSnapshot>> fetchUserDataRealtime() async {
  //   final stream = FirebaseFirestore.instance
  //       .collection('user')
  //       .orderBy('timenow', descending: true)
  //       .snapshots();

  //   final querySnapshot = await stream.first;

  //   return querySnapshot.docs;
  // }

  Future<List<DocumentSnapshot>> fetchUserDataRealtime() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('user')
        .orderBy('timenow', descending: true)
        .get();

    return querySnapshot.docs;
  }

  Future<void> _refreshData() async {
    try {
      final List<DocumentSnapshot> updatedData = await fetchUserDataRealtime();
      setState(() {
        data = updatedData;
      });
      print('ดึงข้อมูลรายชื่อลูกค้า 🔥= ' + data.length.toString());
    } catch (error) {
      print('Error refreshing data: $error');
    }
  }

  List<DocumentSnapshot> data = [];

  Widget buildUserDataList(List<DocumentSnapshot> snapshots) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'ค้นหาชื่อหรือนามสกุล...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: snapshots.length,
              itemBuilder: (context, index) {
                var userData = snapshots[index].data() as Map<String, dynamic>;

                var timeInterest =
                    (userData['timeInterest'] as Timestamp).toDate();
                var selectedtime =
                    (userData['selectedtime'] as Timestamp).toDate();

                String dayString = userData['day'];
                int countdown = int.parse(dayString);

                DateTime currentDate = DateTime.now();
                int daysPassed =
                    currentDate.difference(timeInterest).inDays.abs();
                int daysRemaining = daysPassed - countdown;

                bool shouldShowItem = false;
                String statusText = '';
                Color statusColor = Colors.black;

                if (dropdownValue == 'ถึงกำหนด' && daysPassed == countdown) {
                  shouldShowItem = true;
                  statusText = 'ถึงกำหนด';
                  statusColor = Colors.green;
                } else if (dropdownValue == 'เกินกำหนด' &&
                    daysPassed > countdown) {
                  shouldShowItem = true;
                  statusText = 'เกินกำหนด $daysRemaining วัน';
                  statusColor = Colors.red;
                } else if (dropdownValue == 'ยังไม่ถึงกำหนด' &&
                    daysPassed < countdown) {
                  shouldShowItem = true;
                  statusText = 'ยังไม่ถึงกำหนด';
                  statusColor = Colors.blue;
                } else if (dropdownValue == 'ทั้งหมด') {
                  shouldShowItem = true;
                  statusText = 'ทั้งหมด';
                }

                if (shouldShowItem) {
                  final firstName = userData['name'].toString().toLowerCase();
                  final lastName =
                      userData['lastname'].toString().toLowerCase();
                  final query = searchText.toLowerCase();

                  if (firstName.contains(query) || lastName.contains(query)) {
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
                          title: Text(
                              'ชื่อ: ${userData['name']} ${userData['lastname']}'),
                          trailing: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                statusText == 'ทั้งหมด'
                                    ? daysPassed < countdown
                                        ? const Text(
                                            'ยังไม่ถึงกำหนด',
                                            style:
                                                TextStyle(color: Colors.blue),
                                          )
                                        : daysPassed == countdown
                                            ? const Text(
                                                'ถึงกำหนด',
                                                style: TextStyle(
                                                    color: Colors.green),
                                              )
                                            : Text(
                                                'เกินกำหนด $daysRemaining วัน',
                                                style: TextStyle(
                                                    color: Colors.red),
                                              )
                                    : Text(
                                        statusText,
                                        style: TextStyle(color: statusColor),
                                      ),
                                Text('จ่ายดอกเบี้ยทุก: $countdown วัน'),
                                Text('ผ่านมาแล้ว: $daysPassed วัน'),
                                daysPassed > countdown
                                    ? SizedBox.shrink()
                                    : Text(
                                        'ถึงกำหนดในอีก: ${daysRemaining.abs()} วัน'),
                              ],
                            ),
                          ),
                          onTap: () {
                            var countdownStatusText = statusText;
                            var daysOverdue = daysRemaining;

                            var countdownStatusColor = statusText == 'ถึงกำหนด'
                                ? Colors.green
                                : Colors.red;

                            if (statusText == 'ทั้งหมด' ||
                                statusText == 'ถึงกำหนด' ||
                                statusText == 'เกินกำหนด' ||
                                statusText == 'ยังไม่ถึงกำหนด') {
                              countdownStatusText = daysPassed < countdown
                                  ? 'ยังไม่ถึงกำหนด'
                                  : daysPassed == countdown
                                      ? 'ถึงกำหนด'
                                      : 'เกินกำหนด $daysRemaining วัน';
                              daysOverdue =
                                  daysPassed > countdown ? daysRemaining : 0;
                              countdownStatusColor = daysPassed < countdown
                                  ? Colors.blue
                                  : daysPassed == countdown
                                      ? Colors.green
                                      : Colors.red;
                            }

                            Navigator.pushNamed(context, '/detail', arguments: {
                              'docID': snapshots[index].id,
                              'name': '${userData['name']}',
                              'lastname': '${userData['lastname']}',
                              'old': '${userData['old']}',
                              'phone': '${userData['phone']}',
                              'address': '${userData['address']}',
                              'LoanAmount': '${userData['LoanAmount']}',
                              'InterestAmount': '${userData['InterestAmount']}',
                              'day': '${userData['day']}',
                              'img': '${userData['img']}',
                              'countdownStatusText': countdownStatusText,
                              'countdownStatusColor': countdownStatusColor,
                              'daysOverdue': daysOverdue,
                              'daysPassed': daysPassed,
                            });
                          },
                        ),
                      ),
                    );
                  }
                }

                return SizedBox.shrink();
              },
            ),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("รายชื่อลูกหนี้"),
          actions: [
            Row(
              children: [
                DropdownButton<String>(
                  dropdownColor: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  icon: const Icon(
                    Icons.arrow_drop_down_sharp,
                    color: Colors.blueGrey,
                  ),
                  value: dropdownValue,
                  onChanged: (newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                    });
                  },
                  items: <String>[
                    'ทั้งหมด',
                    'ถึงกำหนด',
                    'เกินกำหนด',
                    'ยังไม่ถึงกำหนด'
                  ].map<DropdownMenuItem<String>>(
                    (String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: const TextStyle(color: Colors.black),
                        ),
                      );
                    },
                  ).toList(),
                ),
                SizedBox(
                  width: 3,
                ),
                IconButton(
                  onPressed: _refreshData,
                  icon: Icon(Icons.refresh),
                )
              ],
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: _refreshData,
          child: FutureBuilder<List<DocumentSnapshot>>(
            future: fetchUserDataRealtime(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else {
                final filteredData = snapshot.data!.where((userData) {
                  final firstName = userData['name'].toString().toLowerCase();
                  final lastName =
                      userData['lastname'].toString().toLowerCase();
                  final query = searchText.toLowerCase();
                  return firstName.contains(query) || lastName.contains(query);
                }).toList();
                return buildUserDataList(filteredData);
              }
            },
          ),
        ),
      ),
    );
  }
}
