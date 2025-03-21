class CartItem {
  final String? id;
  final String productId;
  final String title;
  final double price;
  final int quantity;
  final String imageUrl;
  final String status;

  CartItem({
    this.id,
    required this.productId,
    required this.title,
    required this.price,
    required this.quantity,
    this.imageUrl = '',
    this.status = 'pending'});

  CartItem copyWith({
    String? id,
    String? productId,
    String? title,
    double? price,
    int? quantity,
    String? imageUrl,
    String? status,
  }) {
    return CartItem(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      title: title ?? this.title,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      imageUrl: imageUrl ?? this.imageUrl,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'title': title,
      'price': price,
      'quantity': quantity,
      'status': status,
      'imageUrl': imageUrl,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      productId: json['productId'],
      title: json['title'],
      price: json['price'],
      quantity: json['quantity'],
      imageUrl: json['imageUrl'] ?? '',
      status: json['status'] ?? 'pending',
    );
  }
}
