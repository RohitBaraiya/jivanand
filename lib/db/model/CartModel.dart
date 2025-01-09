class CardModel {
  int? id;
  String? pId;
  String? pName;
  String? img;
  String? catId;
  String? catName;
  double? price;
  String? thum;        // New field for thum
  int? stock;          // New field for stock
  int? buyQty;         // New field for buy_qty
  bool isEdit = false;
  String? remark;

  // Constructor with the new fields
  CardModel({
    this.id,
    this.pId,
    this.pName,
    this.img,
    this.catId,
    this.catName,
    this.price,
    this.thum,
    this.stock,
    this.buyQty,
    this.remark,

  });

  // Convert a map to a CardModel object (when fetching from the database)
  factory CardModel.fromMap(Map<String, dynamic> map) {
    return CardModel(
      id: map['id'],
      pId: map['p_id'],
      pName: map['p_name'],
      img: map['img'],
      catId: map['cat_id'],
      catName: map['cat_name'],
      price: map['price'] != null ? map['price'] * 1.0 : null,  // Ensure the price is a double
      thum: map['thum'],
      stock: map['stock'],
      buyQty: map['buy_qty'],
      remark: map['remark']
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'p_id': pId,
      'p_name': pName,
      'img': img,
      'cat_id': catId,
      'cat_name': catName,
      'price': price,
      'thum': thum,
      'stock': stock,
      'buy_qty': buyQty,
      'remark': remark,
    };
  }

  Map<String, dynamic> toJson() {
    return {
     // 'id': id,
      'product_id': pId,
      'p_name': pName,
      'image': img,
      'category_id': catId,
      'category_name': catName,
      'price': price,
      'thumb': thum,
      'stock': stock,
      'buyQty': buyQty,
      'remark': remark,
    };
  }
}
