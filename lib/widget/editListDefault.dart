import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thongkehanghoa/control/controlEditListDefault.dart';
import 'package:thongkehanghoa/funtion/loadImage.dart';
import 'package:thongkehanghoa/model/product.dart';
import 'package:thongkehanghoa/widget/detailEditProductDefault.dart';

class EditListDefault extends StatefulWidget {
  ControlEditListDefault controlEditListDefault;

  EditListDefault(this.controlEditListDefault);

  @override
  State createState() {
    return _EditListDefaultState();
  }
}

class _EditListDefaultState extends State<EditListDefault> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit"),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.add_box),
          onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context)=> DetailEditLProductDeafault(widget.controlEditListDefault,),
            ));
          },
          )
        ],
      ),
      body: FutureBuilder<List<Product>>(
        future: widget.controlEditListDefault.getListProductDefault(),
        builder: (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
          if (snapshot.hasData) {
            var list = snapshot.data;
            return ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, i) {
                  return _rowOnList(list.elementAt(i), i);
                });
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
  BoxDecoration getImage(Product product){
      if(product.image!="") {
        return BoxDecoration(
          image: DecorationImage(
              image: MemoryImage(LoadImage.uint8listFromBase64(product.image)),
              fit: BoxFit.contain
          ),
        );
      }else {
        return BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/thumnail/camerapicker2.png")
          ),
        );
      }
  }

  Widget _rowOnList(Product product, index) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  color: Colors.black, width: 1, style: BorderStyle.solid)
          ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width: 130,
            height: 130,
            decoration: getImage(product),
          ),
          Flexible(
            flex: 1,
            child: Column(
              children: <Widget>[
                Text(
                  product.name,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 17),
                ),
                SizedBox(height: 10,),
                Text("${product.price}", softWrap: true,maxLines: 3,style: TextStyle(fontSize: 15)),
              ],
            ),
          ),
          Flexible(
            flex: 1,
            child:Column(
              children: <Widget>[
                RaisedButton(
                  child: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(context,MaterialPageRoute(
                      builder: (context)=>DetailEditLProductDeafault(widget.controlEditListDefault,product: product,),
                    ));
                  },
                ),
                RaisedButton(
                  child: Icon(
                    Icons.delete,
                  ),
                  onPressed: () {
                    widget.controlEditListDefault.daoProductDefault.deleteProduct(product.id);
                    setState(() {
                    });
                  },
                ),
              ],
            ) ,
          ),

        ],
      ),
    );
  }
}
