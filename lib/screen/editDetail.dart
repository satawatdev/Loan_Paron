import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:debtor_check/add_on/submitbutton.dart';
import 'package:debtor_check/add_on/chek_box.dart';
import 'package:debtor_check/add_on/dropdown.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import '../add_on/form_feild.dart';

class EditPage extends StatefulWidget {
  const EditPage({super.key});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  //? ส่วนนี้ใว้ประกาศตัวแปล___________________________________
  final _formKey = GlobalKey<FormState>();
  bool isSaving = false; //* ตัวแปรสำหรับเก็บสถานะการบันทึกข้อมูล (loading)
  //?timenow
  DateTime timeNow = DateTime.now();

  DocumentSnapshot<Map<String, dynamic>>? document;

//? controlor ขั้อมูลส่วนบุคคล
  TextEditingController ctlname = TextEditingController();
  TextEditingController ctlLastname = TextEditingController();
  TextEditingController ctlold = TextEditingController();
  TextEditingController ctlphone = TextEditingController();
  TextEditingController ctladdress = TextEditingController();
//?controlor ขั้อมูลรายละเอียดกู้เงิน
  TextEditingController ctltimenow = TextEditingController();
  TextEditingController ctlLoanAmount = TextEditingController();
  TextEditingController ctlInterestAmount = TextEditingController();
  //?เก็บข้อมูลจำนวนวันที่อยู่ในdropdown
  final List<String> items = [
    '10',
    '15',
    '30',
  ];

//create function something
//?เตรี่ยม firebase
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  CollectionReference usercollection =
      FirebaseFirestore.instance.collection('user');
  //?เตรี่ยม เก็บ part photo ที่ได้จากฐานข้อมูล
  List<XFile> _image = [];
  //?เตรี่ยม เก็บ part ที่loopจาก _image
  List<String> imageUrls = [];

//? Update to be nullable
  final now = DateTime.now();
  DateTime? selectedDate1 = DateTime.now();

  //?เวลาของการเลือกเอง
  DateTime? selectedDate;
  DateTime? originalDate; // เพิ่มตัวแปรเพื่อเก็บวันที่เดิม;

//? เอาใว้เก็บลิงค์รูปภาพที่ได้จากดาต้าที่เป็นรูปเดิม
  var imageindata = [];

//? ตัวแปล checkbox
  bool isChecked = false; // สถานะเริ่มต้นของช่องติ๊ก
//? __________________________________________________

  String selectedValue = '';

  @override
  void initState() {
    super.initState();
    selectedDate =
        DateTime.now(); // กำหนดค่าเริ่มต้นให้ selectedDate เป็นวันที่ปัจจุบัน
    originalDate = selectedDate; // บันทึกวันที่เดิม
  }

//todo ส่วนนี้ใว้ทำ Function___________________________________

  //todo: CallData to Update Details
  Future<DocumentSnapshot<Map<String, dynamic>>?> callData() async {
    Map<String, dynamic>? arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final document = await FirebaseFirestore.instance
        .collection('user')
        .doc('${arguments!['docID']}')
        .get();

    if (document.exists) {
      print('ข้อมูลมาแล้ว');
      originalDate = (document['selectedtime'] as Timestamp).toDate();
      imageindata = document['img'];
      print('ภาพที่ได้จากฐานข้อมูลตรงคอลดาต้าโดยตรง = ' +
          imageindata.length.toString() +
          imageindata.toString());
      return document;
    } else {
      print('ไม่พบข้อมูล');
      return null;
    }
  }

  void onResetTextEditingControllerAll() {
    ctlname.clear();
    ctlLastname.clear();
    ctlold.clear();
    ctlphone.clear();
    ctladdress.clear();
    ctltimenow.clear();
    ctlLoanAmount.clear();
    ctlInterestAmount.clear();
    selectedValue = '';
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await _showDatePicker(context, selectedDate);
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        originalDate = selectedDate; // บันทึกวันที่เดิมเมื่อมีการเลือกใหม่
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
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
  }

  //todo: checkbox
  void onChangedCallback(bool? newValue) {
    if (newValue != null) {
      // Your code here
      setState(() {
        isChecked = newValue;
      });
    }
  }

  //todo: อัพเดทข้อมูลเข้าฐานข้อมูล
  addata() async {
    if (_formKey.currentState!.validate()) {
      if (_image != null) {
        setState(() {
          isSaving = true;
        });

        List imageUrlold = imageindata;
        List<String> imageUrls = await uploadImagesToFirebaseStorage(_image);

        var allImages = imageUrlold + imageUrls;

        print('รูปเก่ามี = ${imageUrlold.length}' + imageUrlold.toString());

        print('รูปใหม่มี = ${imageUrls.length}' + imageUrls.toString());

        print('รวมรูปมี = ${allImages.length}' + allImages.toString());
        String name = ctlname.text.isNotEmpty
            ? ctlname.text
            : (document != null ? document!['name'] : '');
        String lastname = ctlLastname.text.isNotEmpty
            ? ctlLastname.text
            : (document != null ? document!['lastname'] : '');
        String old = ctlold.text.isNotEmpty
            ? ctlold.text
            : (document != null ? document!['old'] : '');
        String phone = ctlphone.text.isNotEmpty
            ? ctlphone.text
            : (document != null ? document!['phone'] : '');
        String address = ctladdress.text.isNotEmpty
            ? ctladdress.text
            : (document != null ? document!['address'] : '');
        String loanAmount = ctlLoanAmount.text.isNotEmpty
            ? ctlLoanAmount.text
            : (document != null ? document!['LoanAmount'] : '');
        String interestAmount = ctlInterestAmount.text.isNotEmpty
            ? ctlInterestAmount.text
            : (document != null ? document!['InterestAmount'] : '');

        // ตรวจสอบว่ามีการเปลี่ยนแปลงในวันที่หรือไม่
        if (selectedDate != null &&
            originalDate != null &&
            selectedDate != originalDate) {
          print('เข้าการส่งข้อมูล if ');
          // มีการเปลี่ยนแปลงในวันที่
          // ทำสิ่งที่คุณต้องการเมื่อมีการเปลี่ยนแปลง
          await usercollection.doc(document!.id).update({
            'name': name,
            'lastname': lastname,
            'old': old,
            'phone': phone,
            'address': address,
            'LoanAmount': loanAmount,
            'InterestAmount': interestAmount,
            'day': selectedValue.toString(),
            'img': allImages,
            'selectedtime': selectedDate,
            'timenow': timeNow,
            'timeInterest': selectedDate
          });
        } else {
          print('เข้าการส่งข้อมูล else ');
          // ไม่มีการเปลี่ยนแปลงในวันที่
          // ใช้วันที่เดิม
          await usercollection.doc(document!.id).update({
            'name': name,
            'lastname': lastname,
            'old': old,
            'phone': phone,
            'address': address,
            'LoanAmount': loanAmount,
            'InterestAmount': interestAmount,
            'day': selectedValue.toString(),
            'img': allImages,
            'selectedtime': originalDate, // ใช้วันที่เดิม
            'timenow': timeNow,
            'timeInterest': originalDate // ใช้วันที่เดิม
          });
        }

        setState(() {
          isSaving = false;
          onResetTextEditingControllerAll();
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('อัพเดทข้อมูลสำเร็จ!'),
            ),
          );
        });
      }
    }
  }

//todo __________________________________________________

//! widget
  @override
  Widget build(BuildContext context) {
    DateTime selectedDate2 = DateTime.now();

    return FutureBuilder(
      future: callData(),
      builder: (context, snapshot) {
        selectedValue = snapshot.data!['day'];
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Error'),
            ),
            body: Center(
              child: Text('${snapshot.error}'),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          document = snapshot.data;
          var timeInterest = (document!['selectedtime'] as Timestamp).toDate();

          // var imageindata = document!['img'];

          // print('รูปภาพจากฐานข้อมูลทั้งหมด = ' + imageindata.toString());
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              appBar: AppBar(
                title: const Text(
                  "แก้ไขข้อมูล",
                  // style: Theme.of(context).textTheme.labelLarge,
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                ),
              ),
              body: Column(
                children: <Widget>[
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
                                    'ภาพสัญญากู้ยืมเงิน เดิม!',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  if (imageindata.isNotEmpty)
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: [
                                          for (var image in imageindata)
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(1.0),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Checkbox(
                                                          value: isChecked,
                                                          onChanged:
                                                              onChangedCallback)
                                                    ],
                                                  ),
                                                  const Text(
                                                    'ภาพเดิม!',
                                                    style: TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 20),
                                                  ),
                                                  Image.network(
                                                    image,
                                                    width: 150,
                                                    height: 150,
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                ],
                                              ),
                                            ),
                                        ],
                                      ),
                                    )
                                  else
                                    const Text('ไม่มีรูปภาพ เดิม!'),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        ElevatedButton(
                                          child: const Text('ลบรูปที่เลือก'),
                                          onPressed: () {},
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
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
                                    'ภาพสัญญากู้ยืมเงิน ใหม่!',
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
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      IconButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            _image
                                                                .remove(image);
                                                          });
                                                        },
                                                        icon: const Icon(Icons
                                                            .delete_forever),
                                                      ),
                                                    ],
                                                  ),
                                                  const Text(
                                                    '+ ภาพใหม่',
                                                    style: TextStyle(
                                                        color: Colors.green,
                                                        fontSize: 20),
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
                                    Text('ไม่มีรูปภาพ'),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: IconButton(
                                          onPressed: () {
                                            // for (var i in _image)
                                            //   print('ออกนี่' + i.path);
                                            _pickImage(ImageSource.camera);
                                          },
                                          icon: const Icon(Icons.add_a_photo),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: IconButton(
                                          onPressed: () {
                                            _pickImage(ImageSource.gallery);
                                          },
                                          icon: const Icon(Icons.image_search),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          //!dropdown_________________
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Text('รอบจ่ายดอกเบี้ย'),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
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
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    const Text('วันที่เริ่มยืม'),
                                    Row(
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
                                          timeInterest != null
                                              ? DateFormat.yMd("th").format(
                                                  timeInterest) // แปลงวันที่เป็นภาษาไทย
                                              : 'ยังไม่มีข้อมูลวันที่', // จัดการกรณีที่ไม่มีข้อมูลวันที่
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          //!_________________

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                StyledFormField(
                                  validator: (value) {},
                                  keyboardType: TextInputType.name,
                                  controller: ctlname,
                                  icon: Icons.person,
                                  labelText:
                                      'ชื่อ : ${document!.data()!['name']}',
                                ),
                              ],
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: StyledFormField(
                              validator: (value) {},
                              keyboardType: TextInputType.name,
                              controller: ctlLastname,
                              icon: Icons.person,
                              labelText:
                                  'นามสกุล : ${document!.data()!['lastname']}',
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: StyledFormField(
                              validator: (value) {},
                              keyboardType: TextInputType.number,
                              controller: ctlold,
                              icon: Icons.location_on_outlined,
                              labelText: 'อายุ : ${document!.data()!['old']}',
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: StyledFormField(
                              validator: (value) {},
                              keyboardType: TextInputType.phone,
                              controller: ctlphone,
                              icon: Icons.location_on_outlined,
                              labelText:
                                  'เบอร์โทร : ${document!.data()!['phone']}',
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: StyledFormField(
                              validator: (value) {},
                              keyboardType: TextInputType.streetAddress,
                              controller: ctladdress,
                              icon: Icons.location_on_outlined,
                              labelText:
                                  'ที่อยู่ : ${document!.data()!['address']}',
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: StyledFormField(
                              validator: (value) {},
                              keyboardType: TextInputType.number,
                              controller: ctlLoanAmount,
                              icon: Icons.monetization_on_outlined,
                              labelText:
                                  'เงินต้น : ${document!.data()!['LoanAmount']}',
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: StyledFormField(
                              validator: (value) {},
                              keyboardType: TextInputType.number,
                              controller: ctlInterestAmount,
                              icon: Icons.monetization_on_outlined,
                              labelText:
                                  'ดอกเบี้ย : ${document!.data()!['InterestAmount']}',
                            ),
                          ),
                          //!Button________________
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: SubmitButton(
                              text: isSaving
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : const Text('บันทึกข้อมูล'),
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
          );
        }
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
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
