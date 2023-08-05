import 'package:debtor_check/add_on/listTile.dart';
import 'package:flutter/material.dart';

class interestToday extends StatefulWidget {
  const interestToday({super.key});

  @override
  State<interestToday> createState() => _interestTodayState();
}

class _interestTodayState extends State<interestToday> {
  List<String> originalData = [
    "Apple",
    "Banana",
    "Cherry",
    "Durian",
    "Fig",
    "Grape",
    "Honeydew",
    "Jackfruit",
    "Kiwi",
    "Lemon",
    "Mango",
  ];

  List<String> filteredData = [];

  @override
  void initState() {
    super.initState();
    filteredData.addAll(originalData);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("รายชื่อที่ต้องจ่ายดอกเบี้ยวันนี้"),
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) {
                  filterData(value);
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
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Column(
                      children: [
                        listTile(
                          profileImage:
                              'https://i.pinimg.com/736x/5e/b7/4e/5eb74ed4073e2320a23e80fb3554a6c8.jpg',
                          username: 'ชื่อ ${filteredData[index]}',
                          message: 'รายละเอียด',
                          time: 'สถานะ',
                          ontap: () {
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
        ),
      ),
    );
  }

  void filterData(String searchText) {
    setState(() {
      filteredData = originalData
          .where(
              (item) => item.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    });
  }
}
