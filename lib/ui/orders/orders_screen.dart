import 'package:flutter/material.dart';
import '../shared/app_drawer.dart';
import 'orders_manager.dart';
import '../orders/order_item_cart.dart';
import 'package:provider/provider.dart';

// Định nghĩa màu sắc chính cho ứng dụng - phù hợp với màu laranaPink
const Color primaryColor = Color.fromARGB(255, 231, 110, 110);
const Color secondaryColor = Color(0xFFFFF8DC);
const Color backgroundColor = Color(0xFFFAFAFA);

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});
  static const routeName = '/orders';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  var _isLoading = false;
  late Future<void> _fetchOrders;

  @override
  void initState() {
    super.initState();
    _fetchOrders = context.read<OrdersManager>().fetchOrders();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<OrdersManager>(context, listen: false)
          .fetchOrders()
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: secondaryColor,
        title: Text(
          "My Orders",
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        iconTheme: IconThemeData(color: primaryColor),
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: _fetchOrders,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 60,
                    color: primaryColor.withOpacity(0.7),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Something went wrong",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Error: ${snapshot.error}",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Consumer<OrdersManager>(
              builder: (ctx, ordersManager, child) {
                if (ordersManager.orderCount == 0) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_bag_outlined,
                          size: 80,
                          color: primaryColor.withOpacity(0.7),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "No orders yet",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Your order history will appear here",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListView.builder(
                    itemCount: ordersManager.orderCount,
                    itemBuilder: (ctx, i) =>
                        OrderItemCard(ordersManager.orders[i]),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
