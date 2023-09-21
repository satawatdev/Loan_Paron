import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:debtor_check/add_on/submitbutton.dart';
import 'package:debtor_check/add_on/chek_box.dart';
import 'package:debtor_check/add_on/dropdown.dart';
import 'package:debtor_check/screen/errorscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import '../add_on/form_feild.dart';

class addperson extends StatefulWidget {
  const addperson({super.key});

  @override
  State<addperson> createState() => _addpersonState();
}

class _addpersonState extends State<addperson> {
  //? ส่วนนี้ใว้ประกาศตัวแปล___________________________________
  final _formKey = GlobalKey<FormState>();
  bool isSaving = false; //* ตัวแปรสำหรับเก็บสถานะการบันทึกข้อมูล (loading)
  //?timenow
  DateTime timeNow = DateTime.now();

//* controlor ขั้อมูลส่วนบุคคล
  TextEditingController ctlname = TextEditingController();
  TextEditingController ctlLastname = TextEditingController();
  TextEditingController ctlold = TextEditingController();
  TextEditingController ctlphone = TextEditingController();
  TextEditingController ctladdress = TextEditingController();
//*controlor ขั้อมูลรายละเอียดกู้เงิน
  TextEditingController ctltimenow = TextEditingController();
  TextEditingController ctlLoanAmount = TextEditingController();
  TextEditingController ctlInterestAmount = TextEditingController();
  //*เก็บข้อมูลจำนวนวันที่อยู่ในdropdown
  final List<String> items = [
    '10',
    '15',
    '30',
  ];

//create function something
//*เตรี่ยม firebase
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  CollectionReference usercollection =
      FirebaseFirestore.instance.collection('user');
  //*เตรี่ยม เก็บ part photo ที่ได้จากฐานข้อมูล
  List<XFile> _image = [];
  //*เตรี่ยม เก็บ part ที่loopจาก _image
  List<String> imageUrls = [];
//* Update to be nullable
  final now = DateTime.now();
  DateTime? selectedDate1 = DateTime.now();

  //*เวลาของการเลือกเอง
  DateTime? selectedDate = DateTime.now();

//? __________________________________________________

  String selectedValue = '10';

//todo ส่วนนี้ใว้ทำ Function___________________________________
  void onResetTextEditingControllerAll() {
    ctlname.clear();
    ctlLastname.clear();
    ctlold.clear();
    ctlphone.clear();
    ctladdress.clear();
    ctltimenow.clear();
    ctlLoanAmount.clear();
    ctlInterestAmount.clear();
    selectedValue = '10';
    _image = [];
  }

  _deleteImage() {
    setState(() {
      _image = [];
      print('เข้าsetimage = null');
    });
  }

  //todo:ฟังชั่นเรียกรูปหรือถ่ายรูป
  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);

    if (pickedImage != null) {
      setState(() {
        _image.add(pickedImage);
      });
    }
  }

  Future<List<String>> uploadImagesToFirebaseStorage(
      List<XFile> imageFiles) async {
    for (XFile imageFile in imageFiles) {
      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('images/${DateTime.now().millisecondsSinceEpoch}.jpg');
      UploadTask uploadTask = storageReference.putFile(File(imageFile.path));
      await uploadTask.whenComplete(() async {
        String imageUrl = await storageReference.getDownloadURL();
        imageUrls.add(imageUrl);
        print('Image uploaded to Firebase Storage');
      });
    }

    return imageUrls;
  }

  //todo: ฟังชั่นเพิ่มข้อมูลเข้าฐานข้อมูล
  addata() async {
    try {
      if (_formKey.currentState!.validate()) {
        if (_image != null) {
          setState(() {
            isSaving = true; // แสดงสถานะ loading เมื่อกดปุ่ม
          });

          List<String> imageUrls = await uploadImagesToFirebaseStorage(_image);

          await usercollection.add({
            'name': ctlname.text,
            'lastname': ctlLastname.text,
            'old': ctlold.text,
            'phone': ctlphone.text,
            'address': ctladdress.text,
            'LoanAmount': ctlLoanAmount.text,
            'InterestAmount': ctlInterestAmount.text,
            'day': selectedValue.toString(),
            'img': imageUrls,
            'selectedtime': selectedDate,
            'timenow': timeNow,
            'timeInterest': selectedDate
          });
          setState(
            () {
              isSaving =
                  false; // กำหนดให้ปุ่มหยุดหมุนเมื่อบันทึกข้อมูลเสร็จสิ้น
              onResetTextEditingControllerAll();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('เพิ่มข้อมูลสำเร็จ!'),
                ),
              );
            },
          );
        } else {
          setState(() {
            isSaving = true; //* แสดงสถานะ loading เมื่อกดปุ่ม
          });

          // await uploadImageAndDataToFirestore(
          //     _image!);

          await usercollection.add({
            'name': ctlname.text,
            'lastname': ctlLastname.text,
            'old': ctlold.text,
            'phone': ctlphone.text,
            'address': ctladdress.text,
            'LoanAmount': ctlLoanAmount.text,
            'InterestAmount': ctlInterestAmount.text,
            'day': selectedValue.toString(),
            'img': imageUrls,
            'selectedtime': selectedDate,
            'timenow': timeNow,
            'timeInterest': selectedDate
          });
          setState(
            () {
              isSaving =
                  false; //* กำหนดให้ปุ่มหยุดหมุนเมื่อบันทึกข้อมูลเสร็จสิ้น
              onResetTextEditingControllerAll();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('เพิ่มข้อมูลสำเร็จ!'),
                ),
              );
            },
          );
        }
      }
    } catch (e) {
      runApp(errorscreen());
      print('แตกฟังชัน addata เออเร่อ = ' + e.toString());
    }
  }

//todo: เลือกวันที่
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await _showDatePicker(context, selectedDate);
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

//todo: โชเลือกวันที่
  Future<DateTime?> _showDatePicker(
      BuildContext context, DateTime? initialDate) async {
    // Update the return type
    return await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
  }

//todo __________________________________________________

//! widget
  @override
  Widget build(BuildContext context) {
    DateTime selectedDate2 = DateTime.now();

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
                              padding: const EdgeInsets.all(16.0),
                              child: Card(
                                  elevation: 4.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Column(
                                    children: [
                                      const Text(
                                        'ภาพสัญญากู้ยืมเงิน',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      if (_image.isNotEmpty)
                                        SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: [
                                              for (var image in _image)
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(1.0),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          IconButton(
                                                            onPressed: () {
                                                              setState(() {
                                                                _image.remove(
                                                                    image);
                                                              });
                                                            },
                                                            icon: Icon(Icons
                                                                .delete_forever),
                                                          ),
                                                        ],
                                                      ),
                                                      Image.file(
                                                        File(image.path),
                                                        width: 150,
                                                        height: 150,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                            ],
                                          ),
                                        )
                                      else
                                        Text('ยังไม่มีภาพ!'),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: IconButton(
                                              onPressed: () {
                                                // for (var i in _image)
                                                //   print('ออกนี่' + i.path);
                                                _pickImage(ImageSource.camera);
                                              },
                                              icon: Icon(Icons.add_a_photo),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: IconButton(
                                              onPressed: () {
                                                _pickImage(ImageSource.gallery);
                                              },
                                              icon: Icon(Icons.image_search),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: StyledFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'กรุณากรอกชื่อ';
                                  }
                                  return null; // Return null if the input is valid
                                },
                                keyboardType: TextInputType.name,
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
                                keyboardType: TextInputType.name,
                                controller: ctlLastname,
                                icon: Icons.person,
                                labelText: 'นามสกุล',
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: StyledFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'กรุณากรอกอายุ';
                                  }
                                  return null; // Return null if the input is valid
                                },
                                keyboardType: TextInputType.number,
                                controller: ctlold,
                                icon: Icons.location_on_outlined,
                                labelText: 'อายุ',
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: StyledFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'กรุณากรอกเบอร์โทร';
                                  }
                                  return null; // Return null if the input is valid
                                },
                                keyboardType: TextInputType.phone,
                                controller: ctlphone,
                                icon: Icons.location_on_outlined,
                                labelText: 'เบอร์โทร',
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: StyledFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'กรุณากรอกที่อยู่';
                                  }
                                  return null; // Return null if the input is valid
                                },
                                keyboardType: TextInputType.streetAddress,
                                controller: ctladdress,
                                icon: Icons.location_on_outlined,
                                labelText: 'ที่อยู่',
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: StyledFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'กรุณากรอกยอดเงินกู้';
                                  }
                                  return null; // Return null if the input is valid
                                },
                                keyboardType: TextInputType.number,
                                controller: ctlLoanAmount,
                                icon: Icons.monetization_on_outlined,
                                labelText: 'ยอดเงินกู้',
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: StyledFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'กรุณากรอกดอกเบี้ย';
                                  }
                                  return null; // Return null if the input is valid
                                },
                                keyboardType: TextInputType.number,
                                controller: ctlInterestAmount,
                                icon: Icons.monetization_on_outlined,
                                labelText: 'ดอกเบี้ย',
                              ),
                            ),

                            //!dropdown_________________
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
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
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      IconButton(
                                        onPressed: () => _selectDate(context),
                                        icon: Icon(
                                          Icons.calendar_month,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20.0,
                                      ),
                                      Text(
                                        selectedDate != null
                                            ? DateFormat.yMd("th").format(
                                                selectedDate!
                                                    .toLocal()) // แปลงวันที่เป็นภาษาไทย
                                            : 'ยังไม่ได้เลือกวัน', // จัดการกรณีที่วันที่เป็น null
                                        style: TextStyle(
                                          // fontSize: 55,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            //!_________________

                            //!Button________________
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: SubmitButton(
                                text: isSaving
                                    ? const CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                    : Text('บันทึกข้อมูล'),
                                onPressed: () {
                                  addata();
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
