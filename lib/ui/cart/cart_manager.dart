import 'package:flutter/foundation.dart';
import '../../models/cart_item.dart';
import '../../models/product.dart';
import '../../services/carts_service.dart';

class CartManager with ChangeNotifier {
  final CartsService _cartsService = CartsService();
  final Map<String, CartItem> _items = {};

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

  Future<void> fetchCartItems() async {
    final cartItems = await _cartsService.fetchCartItems(filteredByUser: true);
    _items.clear();
    for (final item in cartItems) {
      _items[item.id!] = item;
    }
    notifyListeners();
  }

  Future<void> addItem(Product product, {int quantity = 1}) async {
    if (_items.containsKey(product.pid!)) {
      final updatedQuantity = _items[product.pid]!.quantity + quantity;
      _items[product.pid!] = _items[product.pid]!.copyWith(quantity: updatedQuantity);

      await _cartsService.updateCartItem(_items[product.pid]!);
    } else {
      final newItem = CartItem(
        productId: product.pid!,
        title: product.title,
        price: product.price,
        quantity: quantity,
        imageUrl: product.imageUrl,
      );
      final addedItem = await _cartsService.addCartItem(newItem);
      if (addedItem != null) {
        _items[product.pid!] = addedItem;
      }
    }
    notifyListeners();
  }
  Future<void> updateItem(CartItem item) async {
    final updatedItem = await _cartsService.updateCartItem(item);
    if (updatedItem != null) {
      _items[item.id!] = updatedItem;
      notifyListeners();
    }
  }

  Future<void> removeItem(String productId) async {
    if (!_items.containsKey(productId)) {
      return;
    }

    if (_items[productId]!.quantity > 1) {
      _items.update(
        productId,
        (existingCartItem) => existingCartItem.copyWith(
          quantity: existingCartItem.quantity - 1,
        ),
      );
      await _cartsService.updateCartItem(_items[productId]!);
    } else {
      final success = await _cartsService.deleteCartItem(_items[productId]!.id!);
      if (success) {
        _items.remove(productId);
      }
    }

    notifyListeners();
  }

  Future<void> clearItem(String id) async {
    final key = _items.keys.firstWhere(
      (k) => _items[k]!.id == id,
      orElse: () => '',
    );

    if (key.isNotEmpty) {
      final success = await _cartsService.deleteCartItem(id);
      if (success) {
        _items.remove(key);
        await fetchCartItems();
        notifyListeners();
      }
    }
  }

  Future<void> clearAllItems() async {
    for (final id in _items.keys.toList()) {
      await _cartsService.deleteCartItem(id);
    }
    _items.clear();
    notifyListeners();
  }

  Future<void> updateItemQuantity(String itemId, int newQuantity) async {
    // Thêm debug log
    print(
        "📝 updateItemQuantity được gọi với itemId: $itemId, newQuantity: $newQuantity");
    print("📦 Danh sách keys trong _items: ${_items.keys.toList()}");

    if (_items.containsKey(itemId)) {
      print("✅ Tìm thấy cart item với ID: $itemId");
      final updatedItem = _items[itemId]!.copyWith(quantity: newQuantity);
      print(
          "📤 Đang gửi yêu cầu cập nhật đến PocketBase với ID: ${updatedItem.id}, quantity: ${updatedItem.quantity}");

      final success = await _cartsService.updateCartItem(updatedItem);

      if (success != null) {
        print("✅ Cập nhật thành công trên PocketBase");
        _items[itemId] = updatedItem;
        notifyListeners();
      } else {
        print("❌ Cập nhật thất bại trên PocketBase");
      }
    } else {
      print("❌ Không tìm thấy cart item với ID: $itemId trong _items");
    }
  }
}
