import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_manager.dart';
import 'cart_item_card.dart';
import '../orders/orders_manager.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});
  static const routeName = '/cart';

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchCartItems();
  }

  Future<void> _fetchCartItems() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await context.read<CartManager>().fetchCartItems();
    } catch (error) {
      print("Error fetching cart: $error");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartManager>();
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFFFF9AA2), // Màu hồng pastel chủ đạo
      secondary: const Color(0xFFFFB7B2), // Màu hồng nhạt hơn
      surface: Colors.white, // Nền trắng
      surfaceTint: const Color(0xFFFFF0F0), // Màu hồng pastel nhạt
      primary: const Color(0xFFFF9AA2),
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onSurface: Colors.black,
    );

    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: colorScheme,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Your Cart',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          backgroundColor: colorScheme.primary,
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20), // Bo góc dưới của AppBar
            ),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colorScheme.primary,
                  const Color(0xFFFFB7B2), // Màu hồng nhạt
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
        backgroundColor: colorScheme.surface, // Nền trắng
        body: Column(
          children: <Widget>[
            Expanded(
              child: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: colorScheme.primary,
                      ),
                    )
                  : cart.productEntries.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.shopping_cart_outlined,
                                size: 80,
                                color: colorScheme.primary.withOpacity(0.7),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Your cart is empty',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: colorScheme.onSurface,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        )
                      : CartItemList(cart),
            ),
            // Phần Total và nút ORDER NOW cố định ở dưới cùng
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20), // Bo góc trên của khung Total
                ),
              ),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween, // Căn đều các phần tử
                children: [
                  Text(
                    'Total:',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600], // Màu xám pastel
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        '\$${cart.totalAmount.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 28, // Tăng kích thước giá
                          fontWeight: FontWeight.bold, // Đậm hơn
                          color: colorScheme.primary, // Màu hồng pastel
                        ),
                      ),
                      const SizedBox(
                          width: 16), // Khoảng cách giữa giá và nút "ORDER NOW"
                      ElevatedButton(
                        onPressed: cart.totalAmount <= 0
                            ? null
                            : () {
                                context.read<OrdersManager>().addOrder(
                                      cart.products,
                                      cart.totalAmount,
                                    );
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'ORDER NOW',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CartItemList extends StatelessWidget {
  const CartItemList(
    this.cart, {
    super.key,
  });

  final CartManager cart;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      children: cart.productEntries
          .map(
            (entry) => CartItemCard(
              productId: entry.key,
              cartItem: entry.value,
            ),
          )
          .toList(),
    );
  }
}
