class Product{
  int id;
  String name;
  double price;
  String image = "";
  String barcode;

  @override
  String toString() {
    return 'Product{id: $id, name: $name, price: $price, image: $image, barcode: $barcode}';
  }

  Product({this.id, this.name, this.price, this.image, this.barcode});

  factory Product.fromMap(Map<String, dynamic> json) => new Product(
      id: json["id"],
      name: json["name"],
      price: json["price"],
      image: json["image"],
      barcode: json['barcode']);

  Map<String, dynamic> toMap() =>
      {"name": name, "price": price, "image": image, "barcode": barcode};
}
