import 'package:flutter/material.dart';
import 'package:qrscan/qrscan.dart';
import 'package:thongkehanghoa/control/controlEditListDefault.dart';
import 'package:thongkehanghoa/funtion/loadImage.dart';
import 'package:thongkehanghoa/funtion/processImage.dart';
import 'package:thongkehanghoa/model/product.dart';

class DetailEditLProductDeafault extends StatefulWidget {
  ControlEditListDefault controlEditListDefault;
  Product product;

  DetailEditLProductDeafault(this.controlEditListDefault, {this.product});

  @override
  State createState() {
    return _DetailEditLProductDeafaultState();
  }
}

class _DetailEditLProductDeafaultState
    extends State<DetailEditLProductDeafault> {
  TextEditingController nameControler, priceControler, barcodeControler;

  @override
  void initState() {
    if (widget.product != null) {
      nameControler = new TextEditingController(text: widget.product.name);
      priceControler =
          new TextEditingController(text: "${widget.product.price}");
      barcodeControler =
          new TextEditingController(text: "${widget.product.barcode}");
    } else {
      widget.product = new Product(image: "");
      nameControler = new TextEditingController();
      priceControler = new TextEditingController();
      barcodeControler = new TextEditingController();
    }
  }

  ImageProvider getImage() {
    print("image:${widget.product.image}");
    if (widget.product.image != "") {
      return MemoryImage(LoadImage.uint8listFromBase64(widget.product.image));
    } else {
      return AssetImage("assets/thumnail/camerapicker2.png");
    }
  }

  changeImage() async {
    var imageRoot = await ProcessImage.pickImage();
    var image = await ProcessImage.resizeImage(imageRoot);
    var list = await ProcessImage.getUint8ListFromImage(image);
    widget.product.image = LoadImage.base64FromImage(list);
    setState(() {});
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
            onPressed: () {
              if (widget.product.id == null) {
                widget.product.name = nameControler.text;
                widget.product.price = double.parse(priceControler.text);
                widget.product.barcode = barcodeControler.text;
                widget.controlEditListDefault.daoProductDefault
                    .addProductDefault(widget.product);
                Navigator.of(context).pop();
              } else {
                widget.product.name = nameControler.text;
                widget.product.price = double.parse(priceControler.text);
                widget.product.barcode = barcodeControler.text;
                widget.controlEditListDefault.daoProductDefault
                    .updateProduct(widget.product);
                Navigator.of(context).pop();
              }
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
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
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
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
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
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              labelText: "Barcode"),
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
