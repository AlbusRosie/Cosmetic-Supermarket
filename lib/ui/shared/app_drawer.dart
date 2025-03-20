import 'package:flutter/material.dart';
import '../orders/orders_screen.dart';
import '../cart/cart_screen.dart';
import '../user/edit_user_screen.dart';
import 'package:provider/provider.dart';
import '../user/users_manager.dart';
import '../auth/auth_manager.dart';

const Color laranaPink = Color.fromARGB(255, 255, 158, 158);
const Color laranaPinkLight = Color(0xFFFFF0F0);

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isLoadingUser = true; // Track loading state for user data

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.forward();

    // Fetch user data when the drawer is opened
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    setState(() {
      _isLoadingUser = true;
    });
    try {
      await Provider.of<UsersManager>(context, listen: false).fetchUser();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load user data: $error'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    } finally {
      setState(() {
        _isLoadingUser = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userManager = Provider.of<UsersManager>(context);
    final user = userManager.currentUser;

    return Drawer(
      backgroundColor: Colors.white,
      elevation: 5,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(20)),
      ),
      child: Column(
        children: <Widget>[
          Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [laranaPink.withOpacity(0.3), Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(20)),
            ),
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _isLoadingUser
                      ? const CircularProgressIndicator(
                          color: laranaPink,
                        )
                      : CircleAvatar(
                          radius: 45,
                          backgroundColor: laranaPink.withOpacity(0.2),
                          child: user?.avatar != null &&
                                  user!.avatar!.isNotEmpty
                              ? ClipOval(
                                  child: Image.network(
                                    user.avatar!,
                                    width: 90,
                                    height: 90,
                                    fit: BoxFit.cover,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return const CircularProgressIndicator(
                                        color: laranaPink,
                                      );
                                    },
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(
                                      Icons
                                          .favorite, // Use the original icon as fallback
                                      size: 50,
                                      color: laranaPink,
                                    ),
                                  ),
                                )
                              : const Icon(
                                  Icons.favorite, // Original placeholder
                                  size: 50,
                                  color: laranaPink,
                                ),
                        ),
                  const SizedBox(height: 12),
                  _isLoadingUser
                      ? const Text(
                          'Loading...',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: laranaPink,
                            fontFamily: 'Pacifico',
                          ),
                        )
                      : Text(
                          user?.name != null && user!.name!.isNotEmpty
                              ? 'Hello, ${user.name}!'
                              : 'Hello, Friend!',
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: laranaPink,
                            fontFamily: 'Pacifico',
                            shadows: [
                              Shadow(
                                color: Colors.black12,
                                offset: Offset(1, 1),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                        ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 15),
          _buildMenuItem(
            context: context,
            icon: Icons.shop,
            title: 'Shop',
            route: '/',
          ),
          _buildDivider(),
          _buildMenuItem(
            context: context,
            icon: Icons.payment,
            title: 'Orders',
            route: OrdersScreen.routeName,
          ),
          _buildDivider(),
          _buildMenuItem(
            context: context,
            icon: Icons.shopping_cart,
            title: 'Cart',
            route: CartScreen.routeName,
          ),
          _buildDivider(),
          _buildMenuItem(
            context: context,
            icon: Icons.person,
            title: 'Edit User',
            route: EditUserScreen.routeName,
          ),
          _buildDivider(),
          _buildMenuItem(
            context: context,
            icon: Icons.exit_to_app,
            title: 'Logout',
            route: '/',
            onTap: () async {
              try {
                await Provider.of<AuthManager>(context, listen: false).logout();
                Navigator.of(context)
                  ..pop() // Close Drawer
                  ..pushReplacementNamed('/'); // Navigate to home screen
              } catch (error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Logout failed: $error'),
                    backgroundColor: Colors.red,
                    duration: const Duration(seconds: 3),
                  ),
                );
              }
            },
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Made with ',
                  style: TextStyle(
                    color: laranaPink,
                    fontSize: 14,
                    fontFamily: 'Pacifico',
                  ),
                ),
                const Icon(
                  Icons.favorite,
                  color: laranaPink,
                  size: 16,
                ),
                const Text(
                  ' by Larana',
                  style: TextStyle(
                    color: laranaPink,
                    fontSize: 14,
                    fontFamily: 'Pacifico',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String route,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: ListTile(
          leading: Icon(
            icon,
            color: laranaPink,
            size: 30,
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: laranaPink,
              fontFamily: 'Pacifico',
            ),
          ),
          tileColor: laranaPinkLight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          onTap: onTap ??
              () {
                Navigator.of(context).pushReplacementNamed(
                  route,
                  arguments: Provider.of<UsersManager>(context, listen: false)
                      .currentUser,
                );
              },
          hoverColor: laranaPink.withOpacity(0.2),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Divider(
        color: laranaPink.withOpacity(0.4),
        thickness: 1.5,
        height: 20,
      ),
    );
  }
}
