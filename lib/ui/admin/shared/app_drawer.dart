import 'package:ct312h_project/components/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth/auth_manager.dart';
import '../order/order_screen.dart';
import '../products/add_product.dart';
import '../products/products_screen.dart';
import '../user/user_screen.dart';

class AdminAppDrawer extends StatelessWidget {
  static const routeName = '/AdminAppDrawer';
  const AdminAppDrawer({super.key});

  Widget _buildListTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String routeName,
    Color? iconColor,
    Color? textColor,
    Color? backgroundColor,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: iconColor ?? color4, size: 28),
        title: Text(
          title,
          style: TextStyle(
            color: textColor ?? color4,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        onTap: onTap ??
            () {
              Navigator.of(context).pushNamed(routeName);
            },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.transparent, // Transparent to show gradient
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color2, // Assuming color13 is a light shade
              color10.withOpacity(1), 
            ],
          ),
        ),
        child: Column(
          children: <Widget>[
            // Header Section
            Container(
              height: 150,
              width: double.infinity,
              padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
              decoration: BoxDecoration(
                color: color4.withOpacity(0.2), // Subtle background for header
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: color4.withOpacity(0.1),
                        child: const Icon(
                          Icons.store,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Larana Cosmetics',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Admin Panel',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Menu Items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 10),
                children: [
                  _buildListTile(
                    context,
                    icon: Icons.dashboard,
                    title: 'Dashboard',
                    routeName: AdminProductsScreen.routeName,
                    iconColor: Colors.white,
                    textColor: Colors.white,
                    backgroundColor: color4.withOpacity(0.2),
                  ),
                  _buildListTile(
                    context,
                    icon: Icons.edit,
                    title: 'Add Products',
                    routeName: AddProductScreen.routeName,
                    iconColor: Colors.white,
                    textColor: Colors.white,
                    backgroundColor: color4.withOpacity(0.2),
                  ),
                  _buildListTile(
                    context,
                    icon: Icons.payment,
                    title: 'Manage Orders',
                    routeName: AdminOrdersScreen.routeName,
                    iconColor: Colors.white,
                    textColor: Colors.white,
                    backgroundColor: color4.withOpacity(0.2),
                  ),
                  _buildListTile(
                    context,
                    icon: Icons.people,
                    title: 'Manage Users',
                    routeName: AdminUsersScreen.routeName,
                    iconColor: Colors.white,
                    textColor: Colors.white,
                    backgroundColor: color4.withOpacity(0.2),
                  ),
                  _buildListTile(
                    context,
                    icon: Icons.admin_panel_settings,
                    title: 'Admin Profile',
                    routeName: '/',
                    iconColor: Colors.white,
                    textColor: Colors.white,
                    backgroundColor: color4.withOpacity(0.2),
                  ),
                ],
              ),
            ),
            // Logout Button at the Bottom
            Container(
              margin: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.redAccent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ListTile(
                leading: const Icon(Icons.exit_to_app,
                    color: Colors.redAccent, size: 28),
                title: const Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () {
                  Navigator.of(context)
                    ..pop()
                    ..pushReplacementNamed('/');
                  context.read<AuthManager>().logout();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
