import 'package:ct312h_project/components/colors.dart';
import 'package:ct312h_project/models/user.dart';
import 'package:ct312h_project/ui/admin/auth/auth_manager.dart';
import 'package:ct312h_project/ui/admin/order/order_manager.dart';
import 'package:ct312h_project/ui/admin/order/order_screen.dart';
import 'package:ct312h_project/ui/admin/products/edit_product.dart';
import 'package:ct312h_project/ui/admin/products/products_manager.dart';
import 'package:ct312h_project/ui/admin/products/products_screen.dart';
import 'package:ct312h_project/ui/admin/products/add_product.dart';
import 'package:ct312h_project/ui/admin/auth/auth_screen.dart';
import 'package:ct312h_project/ui/admin/user/user_manager.dart';
import 'package:ct312h_project/ui/admin/user/user_screen.dart';
import 'package:ct312h_project/ui/screens.dart';
import 'package:ct312h_project/ui/home.dart';
import 'package:ct312h_project/ui/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: ".env");
    print("✅ Dotenv loaded successfully!");
  } catch (e) {
    print("❌ Dotenv loaded failed: $e");
  }
  runApp(const Larana());
}

class Larana extends StatelessWidget {
  const Larana({super.key});

  Route _onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case EditUserScreen.routeName:
        final user = settings.arguments as User?;
        return MaterialPageRoute(
          builder: (ctx) => SafeArea(child: EditUserScreen(user)),
        );
      case EditProductScreen.routeName:
        return MaterialPageRoute(
          builder: (ctx) => const EditProductScreen(),
        );
      default:
        return MaterialPageRoute(
          builder: (ctx) => const SafeArea(
            child: Scaffold(body: Center(child: Text('Page not found'))),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color.fromARGB(255, 255, 158, 158),
      secondary: const Color(0xFFFFF8DC),
      surface: const Color.fromARGB(255, 255, 245, 245),
      surfaceTint: const Color.fromARGB(255, 255, 158, 158),
      primary: const Color.fromARGB(255, 255, 158, 158),
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onSurface: Colors.black,
    );

    final themeData = ThemeData(
      fontFamily: 'Lato',
      colorScheme: colorScheme,
      scaffoldBackgroundColor: color13,
      useMaterial3: true,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.primary,
        elevation: 4,
      ),
      dialogTheme: DialogTheme(
        titleTextStyle: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        contentTextStyle: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 20,
        ),
      ),
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => AuthManager()),
        ChangeNotifierProvider(create: (ctx) => ProductsManager()),
        ChangeNotifierProvider(create: (ctx) => CartManager()),
        ChangeNotifierProvider(create: (ctx) => OrdersManager()),
        ChangeNotifierProvider(create: (ctx) => UserManager()),
        ChangeNotifierProvider(create: (ctx) => UsersManager()),
      ],
      child: Consumer<AuthManager>(
        builder: (ctx, authManager, child) {
          print(
              '🔴 Building app: isInitialized=${authManager.isInitialized}, isAuth=${authManager.isAuth}');

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Cosmetic Supermarket App',
            theme: themeData,
            home: authManager.isInitialized
                ? (authManager.isAuth
                    ? (authManager.isStaff
                        ? const ProductsScreen()
                        : const HomeScreen())
                    : FutureBuilder(
                        future: authManager.tryAutoLogin(),
                        builder: (ctx, snapshot) {
                          return snapshot.connectionState ==
                                  ConnectionState.waiting
                              ? const SafeArea(child: SplashScreen())
                              : const SafeArea(child: AuthScreen());
                        },
                      ))
                : const SafeArea(child: SplashScreen()),
            routes: {
              AuthScreen.routeName: (ctx) => const SafeArea(child: AuthScreen()),
              CartScreen.routeName: (ctx) => const SafeArea(child: CartScreen()),
              OrdersScreen.routeName: (ctx) => const SafeArea(child: OrdersScreen()),
              ProductsScreen.routeName: (ctx) => const ProductsScreen(),
              AddProductScreen.routeName: (ctx) => const AddProductScreen(),
              HomeScreen.routeName: (ctx) => const HomeScreen(),
              UsersScreen.routeName: (ctx) => const UsersScreen(),
            },
            onGenerateRoute: _onGenerateRoute,
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