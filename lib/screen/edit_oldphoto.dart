import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditOldPhoto extends StatefulWidget {
  const EditOldPhoto({Key? key}) : super(key: key);

  @override
  _EditOldPhotoState createState() => _EditOldPhotoState();
}

class _EditOldPhotoState extends State<EditOldPhoto> {
  List<int> selectedImages = []; // รายการรูปภาพที่ถูกเลือก

  Future<DocumentSnapshot> getImageDataFromFirestore(String docID) async {
    final document =
        await FirebaseFirestore.instance.collection('user').doc(docID).get();
    return document;
  }

  void deleteImages(String docID, List<int> selectedImages) async {
    var document =
        await FirebaseFirestore.instance.collection('user').doc(docID).get();
    List<String> argIMG = (document.data()!['img'] as List).cast<String>();

    // ลบรูปภาพตามรายการที่ถูกเลือก
    for (int index in selectedImages) {
      argIMG.removeAt(index);
    }

    // อัปเดตรายการรูปภาพใน Firestore
    await FirebaseFirestore.instance.collection('user').doc(docID).update({
      'img': argIMG,
    });

    setState(() {
      // ล้างรายการรูปภาพที่ถูกเลือก
      selectedImages.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    var arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    var docID = arguments['docID'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('จัดการรูปภาพ'),
        actions: [
          if (selectedImages.isNotEmpty)
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                deleteImages(docID, selectedImages);
              },
            ),
        ],
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: getImageDataFromFirestore(docID),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('เกิดข้อผิดพลาด: ${snapshot.error}');
          } else {
            if (snapshot.hasData) {
              final data = snapshot.data;
              if (data != null) {
                List<String> argIMG = (data['img'] as List).cast<String>();
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // จำนวนคอลัมน์
                    mainAxisSpacing: 1, // ระยะห่างในแนวนอน
                    crossAxisSpacing: 0.0, // ระยะห่างในแนวตั้ง
                  ),
                  itemCount: argIMG.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (selectedImages.contains(index)) {
                            selectedImages.remove(index);
                          } else {
                            selectedImages.add(index);
                          }
                        });
                      },
                      child: Stack(
                        children: [
                          Image.network(argIMG[index]),
                          if (selectedImages.contains(index))
                            Positioned(
                              bottom: 2,
                              right: 2,
                              child: Icon(
                                Icons.check_circle,
                                color: Colors.green,
                                size: 32,
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                );
              } else {
                return Text('ไม่พบข้อมูลหรือรูปภาพ');
              }
            } else {
              return Text('ไม่พบข้อมูลหรือรูปภาพ');
            }
          }
        },
      ),
    );
  }
}
