import 'products_grid.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user_product_list_tile.dart';
import 'products_manager.dart';
import '../cart/cart_screen.dart';
import '../shared/app_drawer.dart';
import '../cart/cart_manager.dart';

const Color laranaPink = Color.fromARGB(255, 255, 158, 158);
const Color laranaYellow = Color(0xFFFFF8DC);

enum FilterOptions { favorites, all }

class UserProductsScreen extends StatefulWidget {
  const UserProductsScreen({super.key});
  static const routeName = '/user_products';

  @override
  State<UserProductsScreen> createState() => _UserProductsScreenState();
}

class _UserProductsScreenState extends State<UserProductsScreen> {
  int _visibleItemCount = 6;

  String searchQuery = "";
  String selectedCategory = "All";

  final ScrollController _scrollController = ScrollController();
  final int _loadMoreItemCount = 6;

  var _currentFilter = FilterOptions.all;

  late Future<void> _fetchProducts;

  @override
  void initState() {
    super.initState();
    _fetchProducts = context.read<ProductsManager>().fetchProducts();
    context.read<CartManager>().fetchCartItems();
    _scrollController.addListener(_onScroll);
  }

  final List<Map<String, dynamic>> categories = [
    {"name": "All", "icon": Icons.category},
    {"name": "Lipsticks", "icon": Icons.face},
    {"name": "Lip Glosses", "icon": Icons.face_retouching_natural},
    {"name": "Blushes", "icon": Icons.brush},
    {"name": "Foundations", "icon": Icons.format_paint},
    {"name": "Concealers", "icon": Icons.blur_on},
    {"name": "Powders", "icon": Icons.cloud},
    {"name": "Eyeshadows", "icon": Icons.visibility},
    {"name": "Eyeliners", "icon": Icons.edit},
    {"name": "Mascaras", "icon": Icons.remove_red_eye},
  ];

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 50) {
      setState(() {
        _visibleItemCount += _loadMoreItemCount;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: laranaYellow,
        elevation: 0,
        title: Transform.translate(
          offset: Offset(-40, 0),
          child: Image.asset(
            'assets/images/lanara.png',
            height: 140,
            fit: BoxFit.contain,
          ),
        ),
        actions: <Widget>[
          ProductFilterMenu(
            currentFilter: _currentFilter,
            onFilterSelected: (filter) {
              setState(() {
                _currentFilter = filter;
              });
            },
          ),
          ShoppingCartButton(
            onPressed: () {
              Navigator.of(context).pushNamed(CartScreen.routeName);
            },
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: _fetchProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 15.0),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value.toLowerCase();
                      });
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(
                        Icons.search,
                        color: laranaPink,
                      ),
                      hintText: 'Search...',
                      hintStyle: TextStyle(color: laranaPink.withOpacity(0.7)),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: laranaPink.withOpacity(0.2),
                          width: 0.5,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: laranaPink.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: const Color.fromARGB(255, 244, 95, 95),
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: SizedBox(
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      itemBuilder: (ctx, index) {
                        final category = categories[index]["name"] as String;
                        final categoryIcon =
                            categories[index]["icon"] as IconData;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedCategory = category;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 15),
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              color: selectedCategory == category
                                  ? laranaPink
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 2,
                                  offset: Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  categoryIcon,
                                  size: 20,
                                  color: selectedCategory == category
                                      ? Colors.white
                                      : laranaPink,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  category,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: selectedCategory == category
                                        ? Colors.white
                                        : laranaPink,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 15, bottom: 0),
                    child: Text(
                      "P r o d u c t s",
                      style: TextStyle(
                        fontFamily: 'Genty',
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 242, 186, 186),
                        shadows: [
                          Shadow(
                            color: Color.fromARGB(255, 238, 241, 204),
                            offset: Offset(3, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: _currentFilter == FilterOptions.favorites
                      ? ProductsGrid(true)
                      : UserProductList(
                          searchQuery: searchQuery,
                          selectedCategory: selectedCategory,
                          visibleItemCount: _visibleItemCount,
                          scrollController: _scrollController,
                          showFavorites:
                              _currentFilter == FilterOptions.favorites,
                        ),
                ),
              ],
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

class UserProductList extends StatelessWidget {
  final String searchQuery;
  final String selectedCategory;
  final int visibleItemCount;
  final ScrollController scrollController;
  final bool showFavorites;

  const UserProductList({
    super.key,
    required this.searchQuery,
    required this.selectedCategory,
    required this.visibleItemCount,
    required this.scrollController,
    required this.showFavorites,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductsManager>(
      builder: (ctx, productsManager, child) {
        // First apply favorite filter if needed
        final baseProducts = showFavorites
            ? productsManager.favoriteItems
            : productsManager.items;

        // Then apply search and category filters
        final filteredProducts = baseProducts.where((product) {
          final matchesSearch =
              product.title.toLowerCase().contains(searchQuery);
          final matchesCategory =
              selectedCategory == "All" || product.category == selectedCategory;
          return matchesSearch && matchesCategory;
        }).toList();

        final productsToShow = filteredProducts.sublist(
          0,
          visibleItemCount < filteredProducts.length
              ? visibleItemCount
              : filteredProducts.length,
        );

        return GridView.builder(
          controller: scrollController,
          padding: const EdgeInsets.all(10),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 5,
            mainAxisSpacing: 10,
            childAspectRatio: 0.75,
          ),
          itemCount: productsToShow.length,
          itemBuilder: (ctx, i) => UserProductListTile(
            productsToShow[i],
          ),
        );
      },
    );
  }
}

class ProductFilterMenu extends StatelessWidget {
  const ProductFilterMenu({
    super.key,
    this.currentFilter,
    this.onFilterSelected,
  });

  final FilterOptions? currentFilter;
  final void Function(FilterOptions selectedValue)? onFilterSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      initialValue: currentFilter,
      onSelected: onFilterSelected,
      icon: const Icon(
        Icons.more_vert,
        color: laranaPink, // Đổi từ màu xanh sang laranaPink
      ),
      itemBuilder: (ctx) => [
        const PopupMenuItem(
          value: FilterOptions.favorites,
          child: Text('Only Favorites'),
        ),
        const PopupMenuItem(
          value: FilterOptions.all,
          child: Text('Show All'),
        ),
      ],
    );
  }
}

class ShoppingCartButton extends StatelessWidget {
  const ShoppingCartButton({super.key, this.onPressed});

  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Consumer<CartManager>(
      builder: (ctx, cartManager, child) {
        return IconButton(
          icon: Badge.count(
            count: cartManager.productCount,
            child: const Icon(
              Icons.shopping_cart,
              color: laranaPink, // Đổi từ màu xanh sang laranaPink
            ),
          ),
          onPressed: onPressed,
        );
      },
    );
  }
}
