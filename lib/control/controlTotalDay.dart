
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
    lists.forEach((product){
      if(!list.containsKey(product.name)){
        list.putIfAbsent(product.name, ()=>(product.amountInput-product.amountOutput));
        listPrice.add(product.price);
      }else{
        list.update(product.name, (value)=>value+(product.amountInput-product.amountOutput));
      }
      total+=(product.price*(product.amountInput-product.amountOutput));
    });
    return list;
  }

}