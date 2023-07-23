import 'dart:math';

import 'package:debtor_check/screen/testpage.dart';
import 'package:debtor_check/screen/drawwer.dart';
import 'package:flutter/material.dart';

class TwoPanels extends StatefulWidget {
  final AnimationController controller;

  const TwoPanels({Key? key, required this.controller}) : super(key: key);

  @override
  _TwoPanelsState createState() => _TwoPanelsState();
}

class _TwoPanelsState extends State<TwoPanels> with TickerProviderStateMixin {
  static const _headerHeight = 32.0;
  late TabController tabController = TabController(length: 3, vsync: this);
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..addListener(() {
      print("SlideValue: ${_controller.value} - ${_controller.status}");
    });
  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(1.5, 0.0),
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.elasticIn,
  ));

  Animation<RelativeRect> getPanelAnimation(BoxConstraints constraints) {
    final _height = constraints.biggest.height;
    final _backPanelHeight = _height - _headerHeight;
    const _frontPanelHeight = -_headerHeight;

    return RelativeRectTween(
      begin: RelativeRect.fromLTRB(
        0.0,
        _backPanelHeight,
        0.0,
        _frontPanelHeight,
      ),
      end: const RelativeRect.fromLTRB(0.0, 100, 0.0, 0.0),
    ).animate(
      CurvedAnimation(parent: widget.controller, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    tabController.dispose();
    super.dispose();
  }

  Widget bothPanels(BuildContext context, BoxConstraints constraints) {
    final ThemeData theme = Theme.of(context);

    return Stack(
      children: <Widget>[
        Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text("Backdrop"),
            elevation: 0.0,
            leading: IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                z.toggle!();
              },
            ),
            bottom: TabBar(
              controller: tabController,
              tabs: const [
                Tab(
                  icon: Icon(Icons.person),
                  text: 'รายชื่อลูกหนี้',
                ),
                Tab(
                  icon: Icon(Icons.home_filled),
                  text: 'ดอกเบี้ยวันนี้',
                ),
                Tab(
                  icon: Icon(Icons.home_filled),
                  text: 'ที่ยังไม่จ่ายดอกเบี้ยห',
                )
              ],
            ),
          ),
          body: TabBarView(
            controller: tabController,
            children: [
              Container(
                color: Colors.grey,
                child: ListView.builder(
                  itemCount: 20,
                  // prototypeItem: ListTile(
                  //   title: Text('items.first'),
                  // ),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Column(
                        children: [
                          _buildFacebookListTile(
                            profileImage:
                                'https://i.pinimg.com/736x/5e/b7/4e/5eb74ed4073e2320a23e80fb3554a6c8.jpg',
                            username: 'สำรี มีนาน้อย',
                            message: 'ลูกหนี้มาสี่เดือนจ่ายแค่ดอก',
                            time: '4 เดือนแล้ว',
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Container(
                color: Colors.grey,
                child: ListView.builder(
                  itemCount: 20,
                  // prototypeItem: ListTile(
                  //   title: Text('items.first'),
                  // ),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Column(
                        children: [
                          _buildFacebookListTile(
                            profileImage:
                                'https://i.pinimg.com/736x/5e/b7/4e/5eb74ed4073e2320a23e80fb3554a6c8.jpg',
                            username: 'นายมอย ขายหอย',
                            message: 'ลูกหนี้มาสี่เดือนจ่ายแค่ดอก',
                            time: '4 เดือนแล้ว',
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Container(
                color: Colors.grey,
                child: ListView.builder(
                  itemCount: 20,
                  // prototypeItem: ListTile(
                  //   title: Text('items.first'),
                  // ),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Column(
                        children: [
                          _buildFacebookListTile(
                            profileImage:
                                'https://i.pinimg.com/736x/5e/b7/4e/5eb74ed4073e2320a23e80fb3554a6c8.jpg',
                            username: 'นางนี นีตา',
                            message: 'ลูกหนี้มาสี่เดือนจ่ายแค่ดอก',
                            time: '4 เดือนแล้ว',
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
        PositionedTransition(
          rect: getPanelAnimation(constraints),
          child: Material(
            elevation: 12.0,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16.0),
              topRight: Radius.circular(16.0),
            ),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: _headerHeight,
                  child: Center(
                    child: Text(
                      "ลูกหนี้ที่ต้องจ่ายวันนี้",
                      // style: Theme.of(context).textTheme.labelLarge,
                      style:
                          TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: 20,
                    // prototypeItem: ListTile(
                    //   title: Text('items.first'),
                    // ),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Column(
                          children: [
                            _buildFacebookListTile(
                              profileImage:
                                  'https://i.pinimg.com/736x/5e/b7/4e/5eb74ed4073e2320a23e80fb3554a6c8.jpg',
                              username: 'นางนี นีตา',
                              message: 'ลูกหนี้มาสี่เดือนจ่ายแค่ดอก',
                              time: '4 เดือนแล้ว',
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: bothPanels,
    );
  }
}

Widget _buildFacebookListTile({
  required String profileImage,
  required String username,
  required String message,
  required String time,
}) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 1,
          blurRadius: 2,
          offset: Offset(0, 1), // เงาในแนวดิ่ง
        ),
      ],
    ),
    child: ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(profileImage),
      ),
      title: Text(
        username,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(message),
      trailing: Text(time),
    ),
  );
}
