import 'package:ct312h_project/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'ui/screens.dart';

Future<void> main() async {
  await dotenv.load();
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
      default:
        return MaterialPageRoute(
          builder: (ctx) => const SafeArea(
              child: Scaffold(body: Center(child: Text('Page not found')))),
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
        ChangeNotifierProvider(create: (ctx) => ProductsManager()),
        ChangeNotifierProvider(create: (ctx) => CartManager()),
        ChangeNotifierProvider(create: (ctx) => OrdersManager()),
        ChangeNotifierProvider(create: (ctx) => AuthManager()),
        ChangeNotifierProvider(create: (ctx) => UsersManager()),
      ],
      child: Consumer<AuthManager>(
        builder: (ctx, authManager, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: themeData,
            home: authManager.isAuth
                ? const SafeArea(child: UserProductsScreen())
                : FutureBuilder(
                    future: authManager.tryAutoLogin(),
                    builder: (ctx, snapshot) {
                      return snapshot.connectionState == ConnectionState.waiting
                          ? const SafeArea(child: SplashScreen())
                          : const SafeArea(child: AuthScreen());
                    },
                  ),
            routes: {
              CartScreen.routeName: (ctx) =>
                  const SafeArea(child: CartScreen()),
              OrdersScreen.routeName: (ctx) =>
                  const SafeArea(child: OrdersScreen()),
              AuthScreen.routeName: (ctx) =>
                  const SafeArea(child: AuthScreen()),
            },
            onGenerateRoute: _onGenerateRoute,
          );
        },
      ),
    );
  }
}
