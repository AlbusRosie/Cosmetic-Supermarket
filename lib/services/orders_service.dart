import '../models/order_item.dart';
import 'pocketbase_client.dart';
import '../models/cart_item.dart';
class OrdersService {
  Future<OrderItem?> updateOrder(OrderItem order) async {
    try {
      final pb = await getPocketbaseInstance();
      final orderModel = await pb.collection('orders').update(
        order.id!,
        body: {
          'amount': order.amount,
          'dateTime': order.dateTime.toIso8601String(),
          'status': order.status,
        },
      );
      return order.copyWith(id: orderModel.id);
    } catch (error) {
      print('Error updating order: $error'); // In lỗi nếu có
      return null;
    }
  }

  Future<bool> deleteOrder(String id) async {
    try {
      final pb = await getPocketbaseInstance();
      await pb.collection('orders').delete(id);
      return true;
    } catch (error) {
      return false;
    }
  }
  Future<List<OrderItem>> fetchOrders({bool filteredByUser = false}) async {
    final List<OrderItem> orders = [];

    try {
      final pb = await getPocketbaseInstance();
      final userId = pb.authStore.record?.id;
      if (filteredByUser && userId == null) {
        return orders;
      }
      final orderModels = await pb.collection('orders').getFullList(
            filter: filteredByUser ? "userId='$userId'" : null,
          );
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
            print('Error fetching cart or product: $error');
          }
        }
        orders.add(OrderItem.fromJson({
          ...orderJson,
          'products': products.map((p) => p.toJson()).toList(),
        }));
      }

      return orders;
    } catch (error) {
      return orders;
    }
  }
  Future<OrderItem?> addOrder(OrderItem order) async {
    try {
      final pb = await getPocketbaseInstance();
      final userId = pb.authStore.record?.id;
      if (userId == null) {
        return null;
      }
      final orderData = {
        'amount': order.amount,
        'dateTime': order.dateTime.toIso8601String(),
        'userId': userId,
        'products': order.products
            .map((p) => p.id)
            .toList(),
        'status': 'confirmed',
      };
      final orderModel = await pb.collection('orders').create(
            body: orderData,
          );
      for (var cartItem in order.products) {
        final cartRecords = await pb.collection('carts').getFullList(
              filter:
                  "userId='$userId' && productId='${cartItem.productId}' && status='pending'",
            );
        for (final cart in cartRecords) {
          await pb.collection('carts')
              .update(cart.id, body: {'status': 'checked_out'});
        }
      }
      return order.copyWith(id: orderModel.id);
    } catch (error) {
      return null;
    }
  }
}