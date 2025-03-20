import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'admin/auth/auth_manager.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  static const routeName = '/home';

  @override
  Widget build(BuildContext context) {
    final authManager = Provider.of<AuthManager>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        backgroundColor: Colors.purple,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () async {
              await authManager.logout();
              // No need for navigation - AuthManager will trigger UI update via notifyListeners
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome to Home Screen!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to another screen or perform an action
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Button Clicked!')),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
              child: const Text('Click Me'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: Icon(Icons.star, color: Colors.purple),
                      title: Text('Item ${index + 1}'),
                      subtitle: const Text('This is a sample item'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Tapped on Item ${index + 1}')),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
