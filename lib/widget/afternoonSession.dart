import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thongkehanghoa/control/controlEditListDefault.dart';
import 'package:thongkehanghoa/control/controlMorningSale.dart';
import 'package:thongkehanghoa/control/controlTotalDay.dart';
import 'package:thongkehanghoa/widget/detailEditSaleProduct.dart';
import 'package:thongkehanghoa/widget/morningSession.dart';
import 'package:thongkehanghoa/widget/page/inputProduct.dart';
import 'package:thongkehanghoa/widget/page/outputProduct.dart';
import 'package:thongkehanghoa/widget/page/totalProduct.dart';
import 'package:thongkehanghoa/widget/totalDay.dart';

import 'countmoney.dart';
import 'editListDefault.dart';

class AfternoonSession extends StatefulWidget {
  @override
  State createState() {
    return AfternoonSessionState();
  }
}

class AfternoonSessionState extends State<AfternoonSession> {
  ControlSaleMorning controlSaleMorning;
  var bol;
  @override
  void initState() {
    // TODO: implement initState
    controlSaleMorning = new ControlSaleMorning();
    controlSaleMorning.setCurrentPage(2);
    getStatusWork();
  }
  Future<bool> getStatusWork() async {
    final sharePreferent = await SharedPreferences.getInstance();
    final tmp = sharePreferent.getBool("WORK") ?? false;
    setState(() {
      bol = tmp;
    });
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if (bol == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else if (bol == false) {
      return Scaffold(
        appBar: AppBar(),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              ListTile(
                title: Row(
                  children: <Widget>[
                    Icon(
                      Icons.list,
                      textDirection: TextDirection.rtl,
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Text('Danh sách mặc định')
                  ],
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            EditListDefault(new ControlEditListDefault()),
                      ));
                },
              ),
              ListTile(
                title: Row(
                  children: <Widget>[
                    Icon(
                      Icons.monetization_on,
                      textDirection: TextDirection.rtl,
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Text('Đếm tiền')
                  ],
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CountMoney(),
                      ));
                },
              ),
            ],
          ),
        ),
        body: Center(
          child: RaisedButton(
            child: Text("Tạo phiên mới"),
            onPressed: () async {
              final wait = await controlSaleMorning.createNewSessionWork();
              if (wait) {
                setState(() {
                  bol = true;
                });
              }
            },
          ),
        ),
      );
    } else {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Ca chiều"),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.add_box),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) =>
                      EditSaleProduct(controlSaleMorning.daoSaleProductSale, 2),
                ));
              },)
          ],
          bottom: TabBar(tabs: <Widget>[
            Tab(
              child: Text('Nhập'),
            ),
            Tab(
              child: Text('Tồn'),
            ),
            Tab(
              child: Text('Tổng kết'),
            )
          ]),
        ),
        body: TabBarView(
          children: <Widget>[
            InputProduct(controlSaleMorning, 2),
            OutputProduct(controlSaleMorning, 2),
            TotalProduct(controlSaleMorning),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              ListTile(
                title: Row(
                  children: <Widget>[
                    Icon(
                      Icons.wb_sunny,
                      textDirection: TextDirection.rtl,
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Text('Ca sáng')
                  ],
                ),
                onTap: () {
                  controlSaleMorning.saveDataTonKho();
                  Navigator.of(context).pop();
                  Timer(Duration(milliseconds: 500), () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyHomePage(),
                        ));
                  });
                },
              ),
              ListTile(
                title: Row(
                  children: <Widget>[
                    Icon(
                      Icons.format_align_justify,
                      textDirection: TextDirection.rtl,
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Text('Ca Chiều')
                  ],
                ),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Row(
                  children: <Widget>[
                    Icon(
                      Icons.score,
                      textDirection: TextDirection.rtl,
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Text('Tổng kết ngày')
                  ],
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TotalDay(
                          controlTotalDay: new ControlTotalDay(),
                        ),
                      ));
                },
              ),
              ListTile(
                title: Row(
                  children: <Widget>[
                    Icon(
                      Icons.list,
                      textDirection: TextDirection.rtl,
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Text('Danh sách mặc định')
                  ],
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            EditListDefault(new ControlEditListDefault()),
                      ));
                },
              ),
              ListTile(
                title: Row(
                  children: <Widget>[
                    Icon(
                      Icons.monetization_on,
                      textDirection: TextDirection.rtl,
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Text('Đếm tiền')
                  ],
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CountMoney(),
                      ));
                },
              ),
              ListTile(
                title: Row(
                  children: <Widget>[
                    Icon(
                      Icons.delete,
                      textDirection: TextDirection.rtl,
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Text('Đóng phiên và xuất file')
                  ],
                ),
                onTap: () {
                  closeSesion();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
  }
  deleteStatusWork() async {
    final sharePreferent = await SharedPreferences.getInstance();
    sharePreferent.remove("WORK");
  }
  closeSesion()async{
    await controlSaleMorning.saveDataTonKho();
    showAlert("");
    final bl =await controlSaleMorning.saveFile();
    if(bl==true) {
      await controlSaleMorning.daoSaleProductSale
          .deleteAllSaleProduct();
      deleteStatusWork();
    }
    Navigator.of(context).pop();
    setState(() {
      bol = false;
    });

  }
  showAlert(String content) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(backgroundColor: Colors.black12,
            content:  Container(
              width: 250,
              height: 100,
              child: Center(
                child: RefreshProgressIndicator(),
              ),
            ),
          );
        });
  }
  @override
  void dispose() {
    controlSaleMorning.saveDataTonKho();
    super.dispose();
  }

}
