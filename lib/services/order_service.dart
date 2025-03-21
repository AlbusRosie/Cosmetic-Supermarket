import '../models/order_item.dart';
import 'pocketbase_client.dart';
import '../models/cart_item.dart';
import '../models/user.dart';

class OrderService {
  Future<List<OrderItem>> fetchAllOrders() async {
    final List<OrderItem> orders = [];
    try {
      final pb = await getPocketbaseInstance();
      final orderModels = await pb!.collection('orders').getFullList();

      for (final orderModel in orderModels) {
        final orderJson = orderModel.toJson();
        final List<CartItem> products = [];

        // Ensure products field exists and is a list
        if (orderJson['products'] == null || orderJson['products'] is! List) {
          print(
              '⚠️ Order ${orderJson['id']} has no products or invalid products field');
          continue; // Skip this order if products field is invalid
        }

        for (final cartId in orderJson['products']) {
          try {
            // Validate cartId
            if (cartId == null || cartId.isEmpty) {
              print('⚠️ Invalid cartId in order ${orderJson['id']}: $cartId');
              products.add(CartItem(
                id: '',
                productId: '',
                title: 'Unknown Product (Invalid Cart ID)',
                price: 0.0,
                quantity: 0,
                status: 'error',
              ));
              continue;
            }

            // Fetch cart item
            final cartModel = await pb.collection('carts').getOne(cartId);
            final cartJson = cartModel.toJson();

            // Validate productId in cart
            if (cartJson['productId'] == null ||
                cartJson['productId'].isEmpty) {
              print(
                  '⚠️ Cart $cartId in order ${orderJson['id']} has no productId');
              products.add(CartItem(
                id: cartJson['id'] ?? '',
                productId: '',
                title: 'Unknown Product (Missing Product ID)',
                price: 0.0,
                quantity: cartJson['quantity'] ?? 0,
                status: cartJson['status'] ?? 'pending',
              ));
              continue;
            }

            // Fetch product
            final productModel =
                await pb.collection('products').getOne(cartJson['productId']);
            final productJson = productModel.toJson();

            products.add(CartItem(
              id: cartJson['id'] ?? '',
              productId: cartJson['productId'] ?? '',
              title: productJson['title'] ?? 'Unknown Product',
              price: productJson['price']?.toDouble() ?? 0.0,
              quantity: cartJson['quantity'] ?? 0,
              status: cartJson['status'] ?? 'pending',
            ));
          } catch (error) {
            print(
                '❌ Error fetching cart or product for cartId $cartId in order ${orderJson['id']}: $error');
            products.add(CartItem(
              id: cartId.toString(),
              productId: '',
              title: 'Error: Product Not Found',
              price: 0.0,
              quantity: 0,
              status: 'error',
            ));
          }
        }

        User? user;
        try {
          if (orderJson['userId'] != null && orderJson['userId'].isNotEmpty) {
            final userModel =
                await pb.collection('users').getOne(orderJson['userId']);
            user = User.fromJson(userModel.toJson());
          }
        } catch (error) {
          print('❌ Error fetching user for order ${orderJson['id']}: $error');
          user = null;
        }

        orders.add(OrderItem.fromJson({
          ...orderJson,
          'products': products.map((p) => p.toJson()).toList(),
          'user': user?.toJson(),
        }));
      }
      return orders;
    } catch (error) {
      print('❌ Error fetching orders: $error');
      return orders;
    }
  }

  Future<OrderItem?> updateOrder(OrderItem order) async {
    try {
      final pb = await getPocketbaseInstance();
      final orderModel = await pb!.collection('orders').update(
        order.id!,
        body: {
          'amount': order.amount,
          'dateTime': order.dateTime.toIso8601String(),
          'status': order.status,
        },
      );
      return order.copyWith(id: orderModel.id);
    } catch (error) {
      print('❌ Error updating order: $error');
      return null;
    }
  }
}
