
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qrscan/qrscan.dart';
import 'package:thongkehanghoa/control/controlMorningSale.dart';
import 'package:thongkehanghoa/funtion/loadImage.dart';
import 'package:thongkehanghoa/model/saleProduct.dart';
import 'package:thongkehanghoa/widget/bloc/BlocSaleProduct.dart';

class InputProduct extends StatefulWidget {
  ControlSaleMorning controlSaleMorning;
  int type;

  InputProduct(
    this.controlSaleMorning,
    this.type,
  ) {
    if (type == 1) {
      print("new InputMorning");
    } else {
      print("new InputAfternoon");
    }
  }

  @override
  State createState() {
    return _InputProductState();
  }
}

class _InputProductState extends State<InputProduct>
    with WidgetsBindingObserver {
  List<TextEditingController> textControlers = new List();
  TextEditingController textdialogControl;
  BlocSaleProduct bloc;

  @override
  void didChangeMetrics() {
    // rebuild when
    setState(() {});
  }
  // close all control edittext free memory
  Future closeedit() async {
    if (textControlers.length != 0) {
      await textControlers.forEach((item) {
        item.dispose();
      });
    }
  }

  @override
  void dispose() async {
    super.dispose();
    await closeedit();
    WidgetsBinding.instance.removeObserver(this);
    bloc.dispose();
    print("inputdispose");
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    bloc =new BlocSaleProduct(widget.controlSaleMorning,widget.type);
  }
  showDialogEdit() async {
    final barcode = await scan();
    if (barcode == null) {
      return;
    } else {
      var productSale = await widget.controlSaleMorning.daoSaleProductSale
          .getSaleProductByBarcode(barcode);
      textdialogControl = new TextEditingController(text: productSale.amountInput.toString());
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(productSale.name),
              content: TextField(
                controller: textdialogControl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Số lượng",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text("Save"),
                 onPressed: (){
                    productSale.amountInput=int.parse(textdialogControl.text);
                    widget.controlSaleMorning.daoSaleProductSale.updateSaleProduct(productSale);
                    Navigator.of(context).pop();
                    textdialogControl.dispose();
                 },
                )
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                flex: 3,
                child: TextField(
                  cursorColor: Colors.red,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    contentPadding: EdgeInsets.all(10),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  onChanged: (value) {
                    bloc.searchlist(value);
                  },
                ),
              ),
              Expanded(
                flex: 1,
                child: IconButton(
                  icon: Icon(Icons.filter_center_focus),
                  onPressed: () {
                    showDialogEdit();
                  },
                ),
              )
            ],
          ),
          Expanded(
            child: StreamBuilder<List<SaleProduct>>(
              initialData: widget.controlSaleMorning.listSaleProduct,
              //type =1 is listMorning
              stream: bloc.locationStream,
              builder: (BuildContext context,
                  AsyncSnapshot<List<SaleProduct>> snapshot) {
                if (snapshot.hasData) {
                  List<SaleProduct> list = snapshot.data;
                  textControlers.clear();
                  return ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, i) {
                        var saleproduct = list.elementAt(i);
                        if (i >= textControlers.length) {
                          textControlers.add(new TextEditingController(
                              text: saleproduct.amountInput.toString()));
                        }
                        // type 1  chage input
                        return _rowInListView(1, saleproduct, context, i);
                      });
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }

  // index is position in listProduct
  // id is is properti in product
  showdialog(int index, int id) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              actions: <Widget>[
                FlatButton(
                  child: Text("No"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text("Yes"),
                  onPressed: () {
                    widget.controlSaleMorning.listSaleProduct.removeAt(index);
                    widget.controlSaleMorning.daoSaleProductSale
                        .deleteSaleProduct(id);
                    Navigator.of(context).pop();
                  },
                ),
              ],
              title: Text("Bạn muốn xóa sản phẩm này?"),
            ));
  }

  BoxDecoration getImage(SaleProduct saleProduct) {
    if (saleProduct.image != "") {
      return BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20)),
        image: DecorationImage(
            image:
                MemoryImage(LoadImage.uint8listFromBase64(saleProduct.image)),
            fit: BoxFit.contain),
      );
    } else {
      return BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20)),
        image: DecorationImage(
            image: AssetImage("assets/thumnail/camerapicker2.png")),
      );
    }
  }

  Widget _rowInListView(
      int type, SaleProduct saleProduct, BuildContext context, i) {
    return InkWell(
      child: Container(
        padding: EdgeInsets.only(bottom: 10),
        color: Colors.black38,
        child: Row(
          children: <Widget>[
            Container(
              width: 130,
              height: 130,
              decoration: getImage(saleProduct),
            ),
            //image
            Container(
              height: 130,
              width: MediaQuery.of(context).size.width - 130,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(10),
                    topRight: Radius.circular(20)),
              ),
              child: Column(
                children: <Widget>[
                  Text(
                    saleProduct.name,
                    maxLines: 3,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  Padding(
                    child: Text(
                      "${saleProduct.price}",
                      style: TextStyle(fontSize: 13, color: Colors.black),
                    ),
                    padding: EdgeInsets.only(top: 5, bottom: 5),
                  ),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        flex: 1,
                        child: RaisedButton(
                          color: Colors.green,
                          colorBrightness: Brightness.dark,
                          splashColor: Colors.red,
                          onPressed: () {
                            var cotroler = textControlers.elementAt(i);
                            cotroler.text =
                                (int.parse(cotroler.text) - 1).toString();
//                            widget.controlSaleMorning.changeSaleProductFromList(
//                                type, i, int.parse(cotroler.text));
                          widget.controlSaleMorning.changeSaleProduct(saleProduct, type, int.parse(cotroler.text));
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(10.0),
                            side: BorderSide(color: Colors.black),
                          ),
                          child: Icon(Icons.exposure_neg_1),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        flex: 2,
                        child: TextField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(), labelText: "SL"),
                          keyboardType: TextInputType.number,
                          style: TextStyle(color: Colors.black),
                          controller: textControlers.elementAt(i),
                          textAlign: TextAlign.center,
                          cursorColor: Colors.red,
                          onSubmitted: (string) {
                            try {
//                              widget.controlSaleMorning
//                                  .changeSaleProductFromList(
//                                      type, i, int.parse(string));
                              widget.controlSaleMorning.changeSaleProduct(saleProduct, type, int.parse(string));
                            } catch (err) {
                              widget.controlSaleMorning.changeSaleProduct(saleProduct, type,0);
                              textControlers.elementAt(i).text = "0";
                            }
                          },
                          autofocus: false,
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        flex: 1,
                        child: RaisedButton(
                          color: Colors.green,
                          colorBrightness: Brightness.dark,
                          splashColor: Colors.red,
                          onPressed: () {
                            var cotroler = textControlers.elementAt(i);
                            try {
                              cotroler.text =
                                  (int.parse(cotroler.text) + 1).toString();
//                              widget.controlSaleMorning
//                                  .changeSaleProductFromList(
//                                      type, i, int.parse(cotroler.text));
                              widget.controlSaleMorning.changeSaleProduct(saleProduct, type, int.parse(cotroler.text));
                            } on FormatException {
                              cotroler.text = cotroler.text;
                            }
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(10.0),
                            side: BorderSide(color: Colors.black),
                          ),
                          child: Icon(Icons.exposure_plus_1),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                    ],
                  )
                ],
              ),
            )
            //price and name
          ],
        ),
      ),
      onLongPress: () {
        showdialog(i, saleProduct.id);
      },
    );
  }

}
