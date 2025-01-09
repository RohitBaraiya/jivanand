class DownloadedFile {
  final String path;
  final String price;
  final String catName;
  final String name;
  final String buyQty;
  final String remark;

  DownloadedFile({required this.path, required this.catName ,required this.price, required this.name, required this.buyQty, required this.remark});

  Map<String, String> toMap() {
    return {
      'path': path,
      'price': price,
      'catName': catName,
      'name': name,
    };
  }

}
