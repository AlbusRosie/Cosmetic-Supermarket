import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user_product_list_tile.dart';
import 'products_manager.dart';
import 'edit_product_screen.dart';
import '../shared/app_drawer.dart';

class UserProductsScreen extends StatefulWidget {
  const UserProductsScreen({super.key});
  static const routeName = '/user_products';

  @override
  State<UserProductsScreen> createState() => _UserProductsScreenState();
}

class _UserProductsScreenState extends State<UserProductsScreen> {
  String searchQuery = "";
  String selectedCategory = "All";
  final ScrollController _scrollController = ScrollController();
  int _visibleItemCount = 6;
  final int _loadMoreItemCount = 6;

  final List<Map<String, dynamic>> categories = [
    {"name": "All", "icon": Icons.category},
    {"name": "Snacks & Sweets", "icon": Icons.cookie},
    {"name": "Instant Noodles & Soups", "icon": Icons.ramen_dining},
    {"name": "Beverages", "icon": Icons.local_drink},
    {"name": "Personal Care & Hygiene", "icon": Icons.soap},
    {"name": "Household Essentials", "icon": Icons.cleaning_services},
    {"name": "Ready-to-Eat Meals", "icon": Icons.fastfood},
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

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
      appBar: AppBar(
        title: const Text(
          '·˚𓈒𓏸 Interstella 𓂃 𓈒𓏸',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              icon: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(229, 255, 255, 255),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                width: 40,
                height: 40,
                child: const Icon(
                  Icons.add,
                  color: Color.fromARGB(255, 57, 157, 144),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName);
              },
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 15.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.search,
                    color: Color.fromARGB(255, 76, 175, 147)),
                hintText: 'Search...',
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: Colors.grey.withOpacity(0.2),
                    width: 0.5,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: const Color.fromARGB(185, 0, 0, 0).withOpacity(0.2),
                    width: 1,
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
                  final categoryIcon = categories[index]["icon"] as IconData;
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
                            ? const Color.fromARGB(255, 63, 136, 119)
                            : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            categoryIcon,
                            size: 20,
                            color: selectedCategory == category
                                ? Colors.white
                                : Colors.black54,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            category,
                            style: TextStyle(
                              fontSize: 16,
                              color: selectedCategory == category
                                  ? Colors.white
                                  : Colors.black,
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
          const Center(
            child: Padding(
              padding: EdgeInsets.only(
                  top: 20, bottom: 0), 
              child: Text(
                "﹏﹏﹏·˚𓈒𓏸 Products 𓏸𓈒˚·﹏﹏﹏",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(230, 33, 77, 62),
                ),
              ),
            ),
          ),
          Expanded(
            child: UserProductList(
              searchQuery: searchQuery,
              selectedCategory: selectedCategory,
              visibleItemCount: _visibleItemCount,
              scrollController: _scrollController,
            ),
          ),
        ],
      ),
      drawer: const AppDrawer(),
    );
  }
}

class UserProductList extends StatelessWidget {
  final String searchQuery;
  final String selectedCategory;
  final int visibleItemCount;
  final ScrollController scrollController;

  const UserProductList({
    super.key,
    required this.searchQuery,
    required this.selectedCategory,
    required this.visibleItemCount,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductsManager>(
      builder: (ctx, productsManager, child) {
        final filteredProducts = productsManager.items.where((product) {
          final matchesSearch =
              product.pname.toLowerCase().contains(searchQuery);
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

        return ListView.builder(
          controller: scrollController,
          padding: const EdgeInsets.all(10),
          itemCount: productsToShow.length,
          itemBuilder: (ctx, i) => UserProductListTile(
            productsToShow[i],
          ),
        );
      },
    );
  }
}
