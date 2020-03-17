import 'package:flutter/material.dart';
import 'package:qrscan/qrscan.dart';
import 'package:thongkehanghoa/dao/Dao_ProductSale.dart';
import 'package:thongkehanghoa/funtion/loadImage.dart';
import 'package:thongkehanghoa/funtion/processImage.dart';
import 'package:thongkehanghoa/model/saleProduct.dart';

class EditSaleProduct extends StatefulWidget {
  DaoSaleProductSale daoSaleProductSale;
  SaleProduct product;
  int type;

  EditSaleProduct(this.daoSaleProductSale, this.type,{this.product});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _EditSaleProductState();
  }
}

class _EditSaleProductState extends State<EditSaleProduct> {
  TextEditingController nameControler, priceControler,barcodeControler;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameControler.dispose();
    priceControler.dispose();
    barcodeControler.dispose();
  }
  @override
  void initState() {
    // TODO: implement initState
    widget.product = new SaleProduct();
    nameControler = new TextEditingController();
    priceControler = new TextEditingController();
    barcodeControler = new TextEditingController();
  }

  changeImage() async {
    var imageRoot = await ProcessImage.pickImage();
    if(imageRoot==null){
      return;
    }
    var image = await ProcessImage.resizeImage(imageRoot);
    var list = await ProcessImage.getUint8ListFromImage(image);
    widget.product.image = LoadImage.base64FromImage(list);
    setState(() {});
  }

  ImageProvider getImage() {
    return AssetImage("assets/thumnail/camerapicker2.png");
  }

  getBarcode() async {
    final barcode = await scan();
    barcodeControler.text = barcode;
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Chi tiết sản phẩm"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: (){
                widget.product.name = nameControler.text;
                widget.product.price = double.parse(priceControler.text);
                widget.product.barcode= barcodeControler.text;
                widget.product.amountInput=0;
                widget.product.amountOutput=0;
                if(widget.product.image==null){
                  widget.product.image="";
                }
                if(widget.type==1) {
                  widget.product.type = 1;
                }else{
                  widget.product.type = 2;
                }
                widget.daoSaleProductSale.addSaleProduct(widget.product);
                Navigator.of(context).pop();
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              InkWell(
                child: Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue,
                    image:
                        DecorationImage(image: getImage(), fit: BoxFit.contain),
                  ),
                ),
                onTap: () {
                  changeImage();
                },
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: nameControler,
                        decoration: InputDecoration(
                          labelText: "Tên sản phẩm",
                          border: OutlineInputBorder( borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: priceControler,
                          decoration: InputDecoration(
                            labelText: "Giá sản phẩm",
                            border: OutlineInputBorder( borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      )
                    ],
                  )),
              SizedBox(
                height: 10,
              ),
              Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: barcodeControler,
                          decoration: InputDecoration(
                            labelText: "Barcode",
                            border: OutlineInputBorder( borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.filter_center_focus),
                        color: Colors.blue,
                        onPressed: () {
                          getBarcode();
                        },
                      )
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
