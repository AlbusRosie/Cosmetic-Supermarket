import 'package:ct312h_project/components/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth/auth_manager.dart';
import '../products/add_product.dart';
import '../products/products_screen.dart';

class AppDrawer extends StatelessWidget {
  static const routeName = '/AppDrawer';
  const AppDrawer({super.key});

  Widget _buildListTile(
      BuildContext context, IconData icon, String title, String routeName) {
    return ListTile(
      leading: Icon(icon, color: color4),
      title: Text(title, style: const TextStyle(color: color4)),
      onTap: () {
        Navigator.of(context)
            .pushNamed(routeName); // Sửa lại từ pushReplacementNamed
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: color13,
      child: Column(
        children: <Widget>[
          AppBar(
            backgroundColor: color13,
            title:
                const Text('Larana Cosmetics', style: TextStyle(color: color4)),
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                icon: const Icon(Icons.close, color: color4),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          const Divider(),
          _buildListTile(
              context, Icons.dashboard, 'Dashboard', ProductsScreen.routeName),
          const Divider(),
          _buildListTile(context, Icons.edit, 'Add Products',
              AddProductScreen.routeName),
          const Divider(),
          _buildListTile(context, Icons.payment, 'Manage Orders', '/'),
          const Divider(),
          _buildListTile(context, Icons.people, 'Manage Customers', '/'),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app, color: color4),
            title: const Text('Logout', style: TextStyle(color: color4)),
            onTap: () {
              Navigator.of(context)
                ..pop()
                ..pushReplacementNamed('/');
              context.read<AuthManager>().logout();
            },
          ),
        ],
      ),
    );
  }
}
