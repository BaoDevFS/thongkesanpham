import 'package:flutter/material.dart';
import 'package:thongkehanghoa/control/controlMorningSale.dart';
import 'package:thongkehanghoa/funtion/loadImage.dart';
import 'package:thongkehanghoa/model/saleProduct.dart';
import 'package:thongkehanghoa/widget/bloc/BlocSaleProduct.dart';

class OutputProduct extends StatefulWidget {
  ControlSaleMorning controlSaleMorning;
  int type;

  OutputProduct(
    this.controlSaleMorning,
    this.type,
  );

  @override
  State createState() {
    return _OutputProductState();
  }
}

class _OutputProductState extends State<OutputProduct> with WidgetsBindingObserver{
  List<TextEditingController> textControlers = new List();
  BlocSaleProduct bloc;
  @override
  void didChangeMetrics() {
    setState(() {
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    bloc =new BlocSaleProduct(widget.controlSaleMorning,widget.type);
  }
// close all textControler free memory
  Future closeedit()async{
    if(textControlers.length!=0) {
      await textControlers.forEach((item) {
        item.dispose();
      });
    }
  }
  @override
  void dispose() async{
    super.dispose();
    await closeedit();
    WidgetsBinding.instance.removeObserver(this);
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
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

                  },
                ),
              )
            ],
          ),
          Expanded(
            child: StreamBuilder<List<SaleProduct>>(
              initialData: widget.controlSaleMorning.listSaleProduct,
              stream: bloc.locationStream,
              builder:
                  (BuildContext context, AsyncSnapshot<List<SaleProduct>> snapshot) {
                if (snapshot.hasData) {
                  List<SaleProduct> list = snapshot.data;
                  return ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, i) {
                        var saleproduct = list.elementAt(i);
                        if (i >= textControlers.length) {
                          textControlers.add(new TextEditingController(
                            text: saleproduct.amountOutput.toString(),));
                          textControlers.elementAt(i).selection =TextSelection.collapsed(offset: saleproduct.amountOutput.toString().length);
                        }else{
                          textControlers.removeAt(i);
                          textControlers.insert(i, new TextEditingController(
                              text: saleproduct.amountOutput.toString()));
                          textControlers.elementAt(i).selection =TextSelection.collapsed(offset: saleproduct.amountOutput.toString().length);
                        }
                        //type 2 change output
                        return _rowInListView(2, saleproduct, context, i);
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
                width: 130, height: 130, decoration: getImage(saleProduct)),
            //image
            Container(
              height: 130,
              width: MediaQuery.of(context).size.width - 130,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(10),topRight:Radius.circular(20) ),
              ),
              child: Column(
                children: <Widget>[
                  Text(
                    saleProduct.name,
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    child: Text(
                      "${saleProduct.price}",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
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
                            widget.controlSaleMorning.changeSaleProduct(saleProduct, type,widget.type, int.parse(cotroler.text));
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
                          controller: textControlers.elementAt(i),
                          textAlign: TextAlign.center,
                          cursorColor: Colors.red,
                          onSubmitted: (string) {
                            try {
                              widget.controlSaleMorning.changeSaleProduct(saleProduct, type,widget.type, int.parse(string));
                            } catch (err) {
                              widget.controlSaleMorning.changeSaleProduct(saleProduct, type,widget.type,0);
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
                              widget.controlSaleMorning.changeSaleProduct(saleProduct, type,widget.type, int.parse(cotroler.text));
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

  // show dialog confirm delete item
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
            )
    );
  }

}
