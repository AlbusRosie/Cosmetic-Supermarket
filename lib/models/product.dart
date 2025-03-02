class Product {
  final String? pid;
  final String pname;
  final String description;
  final double price;
  final String img;
  final bool isFavorite;
  final int stockQuantity;
  final String category;

  Product({
    this.pid,
    required this.pname,
    required this.description,
    required this.price,
    required this.img,
    this.isFavorite = false,
    required this.stockQuantity,
    required this.category,
  });

  Product copyWith({
    String? pid,
    String? pname,
    String? description,
    double? price,
    String? img,
    bool? isFavorite,
    int? stockQuantity,
    String? category,
  }) {
    return Product(
      pid: pid ?? this.pid,
      pname: pname ?? this.pname,
      description: description ?? this.description,
      price: price ?? this.price,
      img: img ?? this.img,
      isFavorite: isFavorite ?? this.isFavorite,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      category: category ?? this.category,
    );
  }
}
