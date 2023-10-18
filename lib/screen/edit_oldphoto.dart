import 'package:flutter/material.dart';

class EditOldPhoto extends StatefulWidget {
  const EditOldPhoto({Key? key}) : super(key: key);

  @override
  State<EditOldPhoto> createState() => _EditOldPhotoState();
}

class _EditOldPhotoState extends State<EditOldPhoto> {
  List<bool> selectedImages = [];
  List<String> images = [];

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    // แปลง String เป็น List<String> โดยแยกด้วยเครื่องหมาย ','
    List<String> imagesFromArgs = (args!['img'] as String).split(',');

    // อัพเดตตัวแปร images ด้วยรายการรูปภาพจาก args
    images = imagesFromArgs;

    return Scaffold(
      appBar: AppBar(
        title: Text('รายการรูปภาพ'),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              'ลบ',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemCount: images.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              // ทำงานเมื่อคลิกที่รายการรูปภาพ
              setState(() {
                // เปลี่ยนสถานะการเลือกรูปภาพ
                selectedImages[index] = !selectedImages[index];
              });
            },
            child: Stack(
              children: [
                Image.network(images[index]), // แสดงรูปภาพ
                if (selectedImages[index])
                  // แสดงสัญลักษณ์เลือกรูปภาพ
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Icon(
                      Icons.check_circle,
                      color: Colors.green,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
