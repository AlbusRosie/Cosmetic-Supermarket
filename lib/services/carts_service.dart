import '../models/cart_item.dart';
import 'pocketbase_client.dart';

class CartsService {
  Future<String> _fetchProductImage(String productId) async {
    try {
      final pb = await getPocketbaseInstance();
      final productModel = await pb.collection('products').getOne(productId);
      final featuredImageName = productModel.getStringValue('featuredImage');

      return pb.files.getUrl(productModel, featuredImageName).toString();
    } catch (error) {
      return '';
    }
  }
  Future<CartItem?> addCartItem(CartItem cartItem) async {
    try {
      final pb = await getPocketbaseInstance();
      final userId = pb.authStore.record!.id;
      final existingItems = await pb.collection('carts').getFullList(
            filter:"userId='$userId' && productId='${cartItem.productId}' && status='pending'",);
      if (existingItems.isNotEmpty) {
        final existingItem = existingItems.first;
        final updatedQuantity =
            existingItem.getIntValue('quantity') + cartItem.quantity;
        final updatedItem = await pb.collection('carts').update(
          existingItem.id,
          body: {
            'quantity': updatedQuantity,
          },
        );
        return CartItem.fromJson(updatedItem.toJson());
      } else {
        // If no pending item exists, create a new one
        final cartModel = await pb.collection('carts').create(
          body: {
            ...cartItem.toJson(),
            'userId': userId,
            'status': 'pending',
          },
        );
        return cartItem.copyWith(id: cartModel.id);
      }
    } catch (error) {
      print("❌ Lỗi khi thêm sản phẩm vào giỏ hàng: $error");
      return null;
    }
  }
  Future<List<CartItem>> fetchCartItems({bool filteredByUser = false}) async {
    final List<CartItem> cartItems = [];

    try {
      final pb = await getPocketbaseInstance();
      final userId = pb.authStore.record!.id;
      String filter;
      if (filteredByUser) {
        filter = "userId='$userId' && status='pending'";
      } else {
        filter = "status='pending'";
      }
      print("🔍 Fetching carts with filter: $filter");
      final cartModels =
          await pb.collection('carts').getFullList(filter: filter);
      print("📋 Found ${cartModels.length} pending cart items");
      for (final cartModel in cartModels) {
        final cartData = cartModel.toJson();
        final productId = cartData['productId'];
        final imageUrl = await _fetchProductImage(productId);
        cartItems.add(
          CartItem.fromJson(cartData).copyWith(imageUrl: imageUrl),
        );
      }
      return cartItems;
    } catch (error) {
      print("❌ Lỗi khi lấy giỏ hàng: $error");
      return cartItems;
    }
  }

  Future<CartItem?> updateCartItem(CartItem cartItem) async {
    try {
      final pb = await getPocketbaseInstance();
      final userId = pb.authStore.record!.id;

      print(
          "🔄 Đang cập nhật cart item với ID: ${cartItem.id}, quantity: ${cartItem.quantity}");

      // Chỉ cập nhật trường quantity
      final cartModel = await pb.collection('carts').update(
        cartItem.id!,
        body: {
          'quantity': cartItem.quantity,
          'userId': userId,
        },
      );

      print("✅ Đã cập nhật cart item trên PocketBase thành công");
      return cartItem.copyWith(id: cartModel.id);
    } catch (error) {
      print("❌ Lỗi khi cập nhật giỏ hàng: $error");
      return null;
    }
  }
  Future<bool> deleteCartItem(String id) async {
    try {
      final pb = await getPocketbaseInstance();
      await pb.collection('carts').delete(id);
      return true;
    } catch (error) {
      return false;
    }
  }
}