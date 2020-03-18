import 'package:flutter/material.dart';
import 'package:thongkehanghoa/control/controlMorningSale.dart';
import 'package:thongkehanghoa/widget/detailEditSaleProduct.dart';
import 'package:thongkehanghoa/widget/page/inputProduct.dart';
import 'package:thongkehanghoa/widget/page/outputProduct.dart';
import 'package:thongkehanghoa/widget/page/totalProduct.dart';

class AfternoonSession extends StatefulWidget {
  @override
  State createState() {
    return AfternoonSessionState();
  }
}

class AfternoonSessionState extends State<AfternoonSession> {
  ControlSaleMorning controlSaleMorning;

  @override
  void initState() {
    // TODO: implement initState
    controlSaleMorning = new ControlSaleMorning();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Ca chiều"),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.add_box),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(
                  builder: (context)=>EditSaleProduct(controlSaleMorning.daoSaleProductSale,2),
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
           InputProduct(controlSaleMorning,2),
            OutputProduct(controlSaleMorning,2),
            TotalProduct(controlSaleMorning),
          ],
        ),
      ),
    );
    throw UnimplementedError();
  }
}
