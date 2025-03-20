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
  Future<int> checkStockQuantity(String productId) async {
    try {
      final pb = await getPocketbaseInstance();
      final productRecord = await pb.collection('products').getOne(productId);
      final stockQuantity = productRecord.data['stockQuantity'] ?? 0;
      return stockQuantity;
    } catch (error) {
      throw Exception('Failed to fetch stock quantity: $error');
    }
  }
  Future<CartItem?> addCartItem(CartItem cartItem) async {
    try {
      // Step 1: Initialize PocketBase and get userId
      final pb = await getPocketbaseInstance();
      final userId = pb.authStore.record?.id;
      if (userId == null) {
        print('Error: No authenticated user found');
        throw Exception(
            'User not authenticated. Please log in to add items to cart.');
      }
      print(
          'Adding cart item for user: $userId, product: ${cartItem.productId}');

      // Step 2: Fetch product details to check stockQuantity
      print('Fetching product with ID: ${cartItem.productId}');
      final productRecord =
          await pb.collection('products').getOne(cartItem.productId);
      final stockQuantity = productRecord.data['stockQuantity'] ?? 0;
      print('Product stock quantity: $stockQuantity');

      // Step 3: Check existing items in the cart
      final existingItems = await pb.collection('carts').getFullList(
            filter:
                "userId='$userId' && productId='${cartItem.productId}' && status='pending'",
          );
      int currentQuantityInCart = 0;

      if (existingItems.isNotEmpty) {
        final existingItem = existingItems.first;
        currentQuantityInCart = existingItem.getIntValue('quantity');
        print(
            'Found existing cart item: ${existingItem.id}, current quantity: $currentQuantityInCart');
      }

      // Step 4: Calculate total quantity and check against stockQuantity
      final totalQuantity = currentQuantityInCart + cartItem.quantity;
      if (totalQuantity > stockQuantity) {
        print(
            'Error: Total quantity ($totalQuantity) exceeds available stock ($stockQuantity)');
        throw Exception(
            'Product is out of stock. Current stock quantity: $stockQuantity');
      }

      // Step 5: Update or create new cart item
      if (existingItems.isNotEmpty) {
        // Update the quantity of the existing cart item
        final existingItem = existingItems.first;
        print(
            'Updating cart item ${existingItem.id} with new quantity: $totalQuantity');
        final updatedItem = await pb.collection('carts').update(
          existingItem.id,
          body: {
            'quantity': totalQuantity,
          },
        );
        print('Cart item updated: ${updatedItem.toJson()}');
        return CartItem.fromJson(updatedItem.toJson());
      } else {
        // Create a new cart item
        print('Creating new cart item for product ${cartItem.productId}');
        final cartModel = await pb.collection('carts').create(
          body: {
            ...cartItem.toJson(),
            'userId': userId,
            'status': 'pending',
          },
        );
        print('Cart item created: ${cartModel.toJson()}');
        return cartItem.copyWith(id: cartModel.id);
      }
    } catch (error) {
      print('Error adding cart item: $error');
      throw Exception('Failed to add cart item: $error');
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
      // Step 1: Check stockQuantity before updating
      final pb = await getPocketbaseInstance();
      final userId = pb.authStore.record?.id;
      if (userId == null) {
        throw Exception('User not authenticated.');
      }

      print('Fetching product with ID: ${cartItem.productId} for update');
      final productRecord =
          await pb.collection('products').getOne(cartItem.productId);
      final stockQuantity = productRecord.data['stockQuantity'] ?? 0;
      print('Product stock quantity: $stockQuantity');

      if (cartItem.quantity > stockQuantity) {
        print(
            'Error: Requested quantity (${cartItem.quantity}) exceeds available stock ($stockQuantity)');
        throw Exception(
            'Product is out of stock. Current stock quantity: $stockQuantity');
      }

      // Step 2: Update cart item
      print(
          'Updating cart item ${cartItem.id} with new quantity: ${cartItem.quantity}');
      final cartModel = await pb.collection('carts').update(
        cartItem.id!,
        body: {
          'quantity': cartItem.quantity,
          'userId': userId,
        },
      );
      print('Cart item updated: ${cartModel.toJson()}');
      return cartItem.copyWith(id: cartModel.id);
    } catch (error) {
      print('Error updating cart item: $error');
      throw Exception('Failed to update cart item: $error');
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
