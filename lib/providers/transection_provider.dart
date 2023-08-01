import 'package:debtor_check/model/transection.dart';
import 'package:flutter/foundation.dart';

class TransectionProvider with ChangeNotifier {
//ตัวอย่างข้อมูล
  List<Transaction> transection = [
    // Transaction(
    //   title: 'ชื่อหนังสือ',
    //   amount: 1500,
    //   date: DateTime.now(),
    // ),
    // Transaction(
    //   title: 'เสื้อผ้า',
    //   amount: 5300,
    //   date: DateTime.now(),
    // ),
    // Transaction(
    //   title: 'กางเกง',
    //   amount: 5500,
    //   date: DateTime.now(),
    // ),
    // Transaction(
    //   title: 'รองเท้า',
    //   amount: 4500,
    //   date: DateTime.now(),
    // ),
  ];

//ดึงข้อมูล
  List<Transaction> getTransection() {
    return transection;
  }

  void addTransection(Transaction statement) {
    transection.insert(0, statement);
    notifyListeners();
    // transection.insert(0, statement);
  }
}
