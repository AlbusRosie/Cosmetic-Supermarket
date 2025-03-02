import '../../models/cart_item.dart';
import 'package:flutter/foundation.dart';
import '../../models/cart_item.dart';
import '../../models/product.dart';
class CartManager with ChangeNotifier{
  final Map<String, CartItem> _items = {
    'p1': CartItem(
      id: 'c1',
      title: 'Red Shirt',
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
      price: 29.99,
      quantity: 2,
    ),
  };

  int get productCount {
    return _items.length;
  }

  List<CartItem> get products {
    return _items.values.toList();
  }

  Iterable<MapEntry<String, CartItem>> get productEntries {
    return {..._items}.entries;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addItem(Product product) {
    if (_items.containsKey(product.pid)) {
      _items.update(
        product.pid!,
        (existingCartItem) => existingCartItem.copyWith(
          quantity: existingCartItem.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        product.pid!,
        () => CartItem(
          id: 'c${DateTime.now().toIso8601String()}',
          title: product.pname,
          imageUrl: product.img,
          price: product.price,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }
  void addItem2(Product product,
      {required int quantity, required String size}) {
    final key = '${product.pid}-$size';

    if (_items.containsKey(key)) {
      _items.update(
        key,
        (existingCartItem) => existingCartItem.copyWith(
          quantity: existingCartItem.quantity + quantity,
        ),
      );
    } else {
      _items.putIfAbsent(
        key,
        () => CartItem(
          id: 'c${DateTime.now().toIso8601String()}',
          title: product.pname,
          imageUrl: product.img,
          price: product.price,
          quantity: quantity,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }

    if (_items[productId]?.quantity as num > 1) {
      _items.update(
        productId,
        (existingCartItem) => existingCartItem.copyWith(
          quantity: existingCartItem.quantity - 1,
        ),
      );
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void clearItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clearAllItems() {
    _items.clear();
    notifyListeners();
  }
}
