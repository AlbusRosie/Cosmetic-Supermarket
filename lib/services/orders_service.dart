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

      // Kiểm tra xem userId có tồn tại không
      if (filteredByUser && userId == null) {
        print('Error: User ID is null');
        return orders;
      }

      // Lấy danh sách đơn hàng từ PocketBase
      final orderModels = await pb.collection('orders').getFullList(
            filter: filteredByUser ? "userId='$userId'" : null,
          );

      // In ra số lượng đơn hàng lấy được
      print('Fetched ${orderModels.length} orders');

      // Duyệt qua từng đơn hàng và parse dữ liệu
      for (final orderModel in orderModels) {
        final orderJson = orderModel.toJson();

        // In ra dữ liệu của đơn hàng
        print('Order JSON: $orderJson');

        // Parse danh sách sản phẩm từ JSON
        final List<CartItem> products = [];
        for (final cartId in orderJson['products']) {
          try {
            // Lấy thông tin cart từ PocketBase
            final cartModel = await pb.collection('carts').getOne(cartId);
            final cartJson = cartModel.toJson();

            // Lấy thông tin sản phẩm từ collection products
            final productModel =
                await pb.collection('products').getOne(cartJson['productId']);
            final productJson = productModel.toJson();

            // Tạo đối tượng CartItem với kiểm tra null
            products.add(CartItem(
              id: cartJson['id'] ?? '',
              productId: cartJson['productId'] ?? '',
              title: productJson['title'] ?? 'Unknown Product',
              price: productJson['price'] ?? 0.0,
              quantity: cartJson['quantity'] ?? 0,
              status: cartJson['status'] ?? 'pending',
            ));
          } catch (error) {
            // In lỗi nếu có
            print('Error fetching cart or product: $error');
          }
        }

        // Thêm vào danh sách đơn hàng
        orders.add(OrderItem.fromJson({
          ...orderJson,
          'products': products.map((p) => p.toJson()).toList(),
        }));
      }

      return orders;
    } catch (error) {
      // In lỗi nếu có
      print('Error fetching orders: $error');
      return orders;
    }
  }
  Future<OrderItem?> addOrder(OrderItem order) async {
    try {
      final pb = await getPocketbaseInstance();
      final userId = pb.authStore.record?.id;
      if (userId == null) {
        print('Error: User ID is null');
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
      print('Order data after saving: ${orderModel.toJson()}');
      for (var cartItem in order.products) {
        final cartRecords = await pb.collection('carts').getFullList(
              filter:
                  "userId='$userId' && productId='${cartItem.productId}' && status='pending'",
            );
        for (final cart in cartRecords) {
          // Cập nhật trạng thái của cart từ 'pending' sang 'checked_out'
          await pb
              .collection('carts')
              .update(cart.id, body: {'status': 'checked_out'});
        }
      }

      // Trả về đơn hàng đã được tạo
      return order.copyWith(id: orderModel.id);
    } catch (error) {
      // In lỗi nếu có
      print('Error adding order: $error');
      return null;
    }
  }
}
