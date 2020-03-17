import 'dart:async';

import 'package:thongkehanghoa/control/controlMorningSale.dart';
import 'package:thongkehanghoa/model/saleProduct.dart';

class BlocSaleProduct{
  final _controler = StreamController<List<SaleProduct>>();
  Stream<List<SaleProduct>> get locationStream => _controler.stream;
  ControlSaleMorning controlSaleMorning;
  int type;
  BlocSaleProduct(this.controlSaleMorning,this.type){
   getList();
  }
  getList()async{
    // type = 0 is get all element from listSale for page TotalProduct
    if(type==0){
      _controler.sink.add(controlSaleMorning.listSaleProduct);
      return;
    }
    final list =await controlSaleMorning.getListSaleProduct(type);
    _controler.sink.add(list);
  }
  searchlist(String value)async{
    List<SaleProduct> resultsearch = new List();
    if(value==null||value=="") {
      _controler.sink.add(controlSaleMorning.listSaleProduct);
      return;
    }
      controlSaleMorning.listSaleProduct.forEach((saleproduct){
      if(saleproduct.name.toLowerCase().contains(value)){
        resultsearch.add(saleproduct);
      }
    });
    _controler.sink.add(resultsearch);
    return;
  }
  dispose(){
    _controler.close();
  }
}