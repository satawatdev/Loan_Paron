import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:debtor_check/add_on/button.dart';
import 'package:debtor_check/add_on/chek_box.dart';
import 'package:debtor_check/add_on/dropdown.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../add_on/form_feild.dart';

class addperson extends StatefulWidget {
  const addperson({super.key});

  @override
  State<addperson> createState() => _addpersonState();
}

//? ส่วนนี้ใว้ประกาศตัวแปล___________________________________
final _formKey = GlobalKey<FormState>();
bool isSaving = false; // ตัวแปรสำหรับเก็บสถานะการบันทึกข้อมูล (loading)
TextEditingController ctlname = TextEditingController();
TextEditingController ctlLastname = TextEditingController();
TextEditingController ctlmonney = TextEditingController();
TextEditingController ctlloan = TextEditingController();
TextEditingController ctladdress = TextEditingController();
TextEditingController ctlphoto = TextEditingController();
//

//เตรี่ยม firebase
final Future<FirebaseApp> firebase = Firebase.initializeApp();
CollectionReference usercollection =
    FirebaseFirestore.instance.collection('user');

//? __________________________________________________

final List<String> items = [
  'รอบ 10 วัน',
  'รอบ 15 วัน',
  'รอบ 30 วัน',
];
var selectedValue = 'รอบ 10 วัน';

//todo ส่วนนี้ใว้ทำ Function___________________________________
void onResetTextEditingControllerAll() {
  ctlname.clear();
  ctlLastname.clear();
  selectedValue = 'รอบ 10 วัน';
}
//todo __________________________________________________

class _addpersonState extends State<addperson> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: firebase,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Error'),
            ),
            body: Center(
              child: Text('${snapshot.error}'),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return SafeArea(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Scaffold(
                body: Column(
                  children: <Widget>[
                    const SizedBox(
                      // height: _headerHeight,
                      child: Center(
                        child: Text(
                          "เพิ่มรายชื่อ",
                          // style: Theme.of(context).textTheme.labelLarge,
                          style: TextStyle(
                              fontSize: 19, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Form(
                      key: _formKey,
                      child: Expanded(
                        child: ListView(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: StyledFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'กรุณากรอกชื่อ';
                                  }
                                  return null; // Return null if the input is valid
                                },
                                controller: ctlname,
                                icon: Icons.person,
                                labelText: 'ชื่อ',
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: StyledFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'กรุณากรอกนามสกุล';
                                  }
                                  return null; // Return null if the input is valid
                                },
                                controller: ctlLastname,
                                icon: Icons.person,
                                labelText: 'นามสกุล',
                              ),
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.all(8.0),
                            //   child: StyledFormField(
                            //     validator: (value) {
                            //       if (value == null || value.isEmpty) {
                            //         return 'กรุณากรอกที่อยู่';
                            //       }
                            //       return null; // Return null if the input is valid
                            //     },
                            //     controller: ctladdress,
                            //     icon: Icons.location_on_outlined,
                            //     labelText: 'ที่อยู่',
                            //   ),
                            // ),
                            // Padding(
                            //   padding: const EdgeInsets.all(8.0),
                            //   child: StyledFormField(
                            //     validator: (value) {
                            //       if (value == null || value.isEmpty) {
                            //         return 'กรุณากรอกนามสกุล';
                            //       }
                            //       return null; // Return null if the input is valid
                            //     },
                            //     controller: ctlphoto,
                            //     icon: Icons.photo_camera_front_outlined,
                            //     labelText: 'รูปภาพสัญญา',
                            //   ),
                            // ),
                            // Padding(
                            //   padding: const EdgeInsets.all(8.0),
                            //   child: StyledFormField(
                            //     validator: (value) {
                            //       if (value == null || value.isEmpty) {
                            //         return 'กรุณากรอกยอดเงินกู้';
                            //       }
                            //       return null; // Return null if the input is valid
                            //     },
                            //     controller: ctlmonney,
                            //     icon: Icons.monetization_on_outlined,
                            //     labelText: 'ยอดเงินกู้',
                            //   ),
                            // ),
                            // Padding(
                            //   padding: const EdgeInsets.all(8.0),
                            //   child: StyledFormField(
                            //     validator: (value) {
                            //       if (value == null || value.isEmpty) {
                            //         return 'กรุณากรอกดอกเบี้ย';
                            //       }
                            //       return null; // Return null if the input is valid
                            //     },
                            //     controller: ctlloan,
                            //     icon: Icons.monetization_on_outlined,
                            //     labelText: 'ดอกเบี้ย',
                            //   ),
                            // ),
                            //!dropdown_________________
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  CustomDropdownButton(
                                    items: items,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedValue = value!;
                                        print(selectedValue.toString());
                                      });
                                    },
                                    selectedValue: selectedValue,
                                  ),
                                ],
                              ),
                            ),
                            //!_________________

                            //!Button________________
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: SubmitButton(
                                text: isSaving
                                    ? CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                    : Text('บันทึกข้อมูล'),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    // _formKey.currentState!.save();
                                    setState(() {
                                      isSaving =
                                          true; // แสดงสถานะ loading เมื่อกดปุ่ม
                                    });
                                    await usercollection.add({
                                      'name': ctlname.text,
                                      'lastname': ctlLastname.text,
                                      'day': selectedValue.toString()
                                    });
                                    setState(() {
                                      isSaving =
                                          false; // กำหนดให้ปุ่มหยุดหมุนเมื่อบันทึกข้อมูลเสร็จสิ้น
                                      onResetTextEditingControllerAll();
                                      SnackBar(
                                          content: Text('บันทึกข้อมูลสำเร็จ'));
                                    });
                                  } /* else {
                                    print(
                                        'Form is invalid, please check your input!');
                                  } */
                                },
                                isFormValid:
                                    _formKey.currentState?.validate() ?? false,
                              ),
                            ),
                            //!_________________
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
