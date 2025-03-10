import 'package:flutter/material.dart';

import '../orders/orders_screen.dart';

const Color laranaBlue = Color(0xFF78A5FF); // Màu xanh từ logo
const Color laranaYellow = Color(0xFFFFF8DC); // Màu vàng từ logo

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: laranaYellow, // Đổi màu nền của Drawer
      child: Column(
        children: <Widget>[
          AppBar(
            title: const Text(
              'Hello Friend!',
              style: TextStyle(color: laranaBlue), // Đổi màu chữ AppBar
            ),
            automaticallyImplyLeading: false,
            backgroundColor: laranaYellow, // Đổi màu AppBar
            iconTheme: const IconThemeData(color: laranaBlue), // Đổi màu icon trong AppBar
          ),
          const Divider(color:  Color.fromARGB(255, 199, 195, 174)), // Đổi màu đường kẻ
          ListTile(
            leading: const Icon(Icons.shop, color: laranaBlue), // Đổi màu icon
            title: const Text(
              'Shop',
              style: TextStyle(color: laranaBlue), // Đổi màu chữ
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          const Divider(color: Color.fromARGB(255, 199, 195, 174)),
          ListTile(
            leading: const Icon(Icons.payment, color: laranaBlue),
            title: const Text(
              'Orders',
              style: TextStyle(color: laranaBlue),
            ),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(OrdersScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}
