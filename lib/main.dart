import 'package:ct312h_project/ui/admin/auth/auth_screen.dart';
import 'package:ct312h_project/ui/admin/products/products_overview_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'ui/admin/auth/auth_manager.dart';
import 'ui/screens.dart';
import 'ui/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables
  await dotenv.load(fileName: ".env");
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthManager()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Cosmetic Supermarket App',
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          textTheme: Theme.of(context).textTheme.apply(
            displayColor: color2,
          ),
          useMaterial3: true,
        ),
        routes: {
          DashboardScreen.routeName: (context) => const DashboardScreen(),
          OrdersScreen.routeName: (context) => const OrdersScreen(),
          Sidebar.routeName: (context) => const Sidebar(),
          ProductsOverviewScreen.routeName: (ctx) =>
              const SafeArea(child: ProductsOverviewScreen()),
        },
        home: Consumer<AuthManager>(
          builder: (ctx, authManager, child) {
            return authManager.isAuth
                ? const SafeArea(child: ProductsOverviewScreen())
                : FutureBuilder(
                    future: authManager.tryAutoLogin(),
                    builder: (ctx, snapshot) {
                      return snapshot.connectionState == ConnectionState.waiting
                          ? const SafeArea(child: SplashScreen())
                          : const SafeArea(child: AuthScreen());
                    },
                  );
          },
        ),
      ),
    );
  }
}