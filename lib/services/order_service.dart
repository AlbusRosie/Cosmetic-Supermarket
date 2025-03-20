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

        for (final cartId in orderJson['products']) {
          try {
            final cartModel = await pb.collection('carts').getOne(cartId);
            final cartJson = cartModel.toJson();
            final productModel =
                await pb.collection('products').getOne(cartJson['productId']);
            final productJson = productModel.toJson();

            products.add(CartItem(
              id: cartJson['id'] ?? '',
              productId: cartJson['productId'] ?? '',
              title: productJson['title'] ?? 'Unknown Product',
              price: productJson['price'] ?? 0.0,
              quantity: cartJson['quantity'] ?? 0,
              status: cartJson['status'] ?? 'pending',
            ));
          } catch (error) {
            print('❌ Error fetching cart or product: $error');
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
          print('❌ Error fetching user: $error');
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
