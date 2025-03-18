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
            filter:
                "userId='$userId' && productId='${cartItem.productId}' && status='pending'",
          );
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
      final cartModels =
          await pb.collection('carts').getFullList(filter: filter);
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
      return cartItems;
    }
  }

  Future<CartItem?> updateCartItem(CartItem cartItem) async {
    try {
      final pb = await getPocketbaseInstance();
      final userId = pb.authStore.record!.id;
      final cartModel = await pb.collection('carts').update(
        cartItem.id!,
        body: {
          'quantity': cartItem.quantity,
          'userId': userId,
        },
      );
      return cartItem.copyWith(id: cartModel.id);
    } catch (error) {
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
