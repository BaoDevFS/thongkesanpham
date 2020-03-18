import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:thongkehanghoa/control/controlMorningSale.dart';
import 'package:thongkehanghoa/model/saleProduct.dart';
import 'package:thongkehanghoa/widget/bloc/BlocSaleProduct.dart';

class TotalProduct extends StatefulWidget {
  ControlSaleMorning controlSaleMorning;

  TotalProduct(
    this.controlSaleMorning,
  );

  @override
  State createState() {
    return _TotalProductState();
  }
}

class _TotalProductState extends State<TotalProduct>
    with WidgetsBindingObserver {
  BlocSaleProduct bloc;
//  FlutterMoneyFormatter formatter = new FlutterMoneyFormatter(amount: null);
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    bloc =new BlocSaleProduct(widget.controlSaleMorning, 0);
//    formatter = new FlutterMoneyFormatter();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    bloc.dispose();
  }

  @override
  void didChangeMetrics() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      cursorColor: Colors.red,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        contentPadding: EdgeInsets.all(10),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      onChanged: (value) {
                        bloc.searchlist(value);
                      },
                    ),
                  ),
                ],
              ),
              Flexible(
                child: StreamBuilder<List<SaleProduct>>(
                  initialData: widget.controlSaleMorning.listSaleProduct,
                  stream: bloc.locationStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<SaleProduct>> snapshot) {
                    if (snapshot.hasData) {
                      List<SaleProduct> list = snapshot.data;
                      return ListView.builder(
                          itemCount: list.length,
                          itemBuilder: (context, i) {
                            var saleproduct = list.elementAt(i);
                            // 1  chage input
                            return _rowOnList(saleproduct);
                          });
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),

            ],
          ),
          Positioned(
            top: 10,
            right: 2,
            child: Text("Tổng :${FlutterMoneyFormatter(amount:  widget.controlSaleMorning.totalMoney()).output.withoutFractionDigits}",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.blue),),
          )
        ],
      ),
    );
  }

  Widget _rowOnList(SaleProduct saleProduct) {
    return Container(
      padding: EdgeInsets.all(5),
      child: Container(
        padding: EdgeInsets.all(6),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            border: Border.all(
                style: BorderStyle.solid, width: 1, color: Colors.black)),
        child: Column(
          children: <Widget>[
            Text(
              "${saleProduct.name}",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              maxLines: 1,
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Nhập : ${saleProduct.amountInput}",
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Text(
                      "Bán được: ${saleProduct.amountInput - saleProduct.amountOutput}",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Tồn: ${saleProduct.amountOutput}",
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Text(
                      "Tổng tiền: ${(saleProduct.amountInput-saleProduct.amountOutput)*saleProduct.price }",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                    )
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
