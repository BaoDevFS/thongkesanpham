
class SaleProduct{
  int id;
  String name;
  int type;
  double price;
  String image;
  String barcode;
  int amountInput;
  int amountOutput;
  SaleProduct({this.id, this.name,this.type, this.price, this.image,this.barcode,this.amountInput,this.amountOutput});
  factory SaleProduct.fromMap(Map<String, dynamic> json) => new SaleProduct(
    id: json["id"],
    name: json["name"],
    type: json["type"],
    price: json["price"],
    image: json["image"],
    barcode: json["barcode"],
    amountInput: json['amountInput'],
    amountOutput: json['amountOutput']
  );

  @override
  String toString() {
    return 'SaleProduct{id: $id, name: $name,type: $type, price: $price, barcode: $barcode, amountInput: $amountInput, amountOutput: $amountOutput}';
  }

  Map<String, dynamic> toMap() => {
    "name": name,
    "price": price,
    "type":type,
    "image": image,
    "barcode":barcode,
    "amountInput":amountInput,
    "amountOutput":amountOutput
  };

}