import 'package:ct312h_project/components/colors.dart';
import 'package:ct312h_project/ui/admin/order/order_manager.dart';
import 'package:ct312h_project/ui/admin/user/user_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'ui/admin/auth/auth_manager.dart';
import 'ui/admin/order/order_screen.dart';
import 'ui/admin/products/edit_product.dart';
import 'ui/admin/products/products_manager.dart';
import 'ui/admin/products/products_screen.dart';
import 'ui/admin/products/add_product.dart';
import 'ui/admin/auth/auth_screen.dart';
import 'ui/admin/user/user_screen.dart';
import 'ui/home.dart';
import 'ui/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    // Load environment variables
    await dotenv.load(fileName: ".env");
    print("✅ Dotenv loaded successfully!");
  } catch (e) {
    print("❌ Dotenv loaded failed!");
  }
  

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthManager()),
        ChangeNotifierProvider(create: (context) => ProductsManager()),
        ChangeNotifierProvider(create: (context) => OrdersManager()),
        ChangeNotifierProvider(create: (context) => UserManager()),
      ],
      child: Consumer<AuthManager>(
        builder: (ctx, authManager, child) {
          print(
              '🔴 Building app: isInitialized=${authManager.isInitialized}, isAuth=${authManager.isAuth}');

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Cosmetic Supermarket App',
            theme: ThemeData(
              scaffoldBackgroundColor: color13,
              useMaterial3: true,
            ),
            home: authManager.isInitialized
                ? (authManager.isAuth 
                    ? (authManager.isStaff
                        ? const ProductsScreen()
                        : const HomeScreen())
                    : const AuthScreen())
                : const SplashScreen(),
            routes: {
              ProductsScreen.routeName: (context) => const ProductsScreen(),
              AddProductScreen.routeName: (context) => const AddProductScreen(),
              EditProductScreen.routeName: (ctx) => EditProductScreen(),
              OrdersScreen.routeName: (ctx) => OrdersScreen(),
              HomeScreen.routeName: (context) => const HomeScreen(),
              UsersScreen.routeName: (context) => const UsersScreen(),
            },
            onUnknownRoute: (settings) {
              return MaterialPageRoute(
                builder: (ctx) => const ProductsScreen(),
              );
            },
          );
        },
      ),
    );
  }
}
