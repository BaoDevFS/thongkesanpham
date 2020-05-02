
import 'package:thongkehanghoa/dao/Dao_ProductSale.dart';

class ControlTotalDay{
  DaoSaleProductSale daoSaleProductSale;
  Map<String,int> list;
  List<double> listPrice;
  var total=0.0;
  ControlTotalDay(){
    daoSaleProductSale = new DaoSaleProductSale();
    list = new Map();
    listPrice = new List();
  }
  Future<Map<String,int>> getList()async{
    var lists= await daoSaleProductSale.getListAllSaleProduct();
    var lastbarcode = "";
     lists.forEach((product){
       if(product.barcode!="") {
          lastbarcode = " ("+product.barcode.substring(
             product.barcode.length - 5)+")";
       }else{
         lastbarcode="";
       }
      if(!list.containsKey(product.name+lastbarcode)){
        // show last 5 char barcode
        list.putIfAbsent(product.name+lastbarcode, ()=>(product.amountInput-product.amountOutput));
        listPrice.add(product.price);
      }else{
        list.update(product.name+lastbarcode, (value)=>value+(product.amountInput-product.amountOutput));
      }
      total+=(product.price*(product.amountInput-product.amountOutput));
    });
    return list;
  }

}