import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../components/colors.dart';
import '../../../models/product.dart';
import 'add_product.dart';
import 'edit_product.dart';
import 'products_manager.dart';
import '../shared/app_drawer.dart'; // Import the AppDrawer

class ProductsScreen extends StatefulWidget {
  static const routeName = '/product_screen';
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductsScreen> {
  String? _selectedCategory;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = true;
  final ScrollController _scrollController =
      ScrollController(); // Add a scroll controller

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    final productsManager =
        Provider.of<ProductsManager>(context, listen: false);
    await productsManager.fetchCategories(); // First fetch categories
    await productsManager.fetchProducts(); // Then fetch all products

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final productsManager = Provider.of<ProductsManager>(context, listen: true);

    return Scaffold(
      key: _scaffoldKey,
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Container(
                margin: EdgeInsets.only(left: 10, top: 10),
                child: Column(
                  children: [
                    // Add a menu icon to open the drawer
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.menu, color: color4, size: 30),
                          onPressed: () {
                            _scaffoldKey.currentState?.openDrawer();
                          },
                        ),
                        SizedBox(width: 10),
                        Container(
                          width:
                              320, // Giới hạn chiều ngang của thanh search bar
                          padding: EdgeInsets.only(left: 15.0, right: 10.0),
                          decoration: BoxDecoration(
                            color: color17,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Search ...",
                                    hintStyle: TextStyle(color: color4),
                                  ),
                                ),
                              ),
                              Icon(Icons.search, color: color4, size: 30.0),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      height: 50,
                      width: 390,
                      margin: EdgeInsets.only(left: 10, right:20),
                      decoration: BoxDecoration(
                        color: color13, // Colorize the bar
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: RawScrollbar(
                        controller:
                            _scrollController, // Attach the scroll controller
                        thumbVisibility: true, // Always show the scrollbar
                        thumbColor: color4.withOpacity(0.5), // Scrollbar color
                        radius: Radius.circular(
                            10), // Rounded corners for the scrollbar
                        thickness: 4, // Thin scrollbar
                        minThumbLength:
                            50, // Minimum length of the scrollbar thumb
                        scrollbarOrientation: ScrollbarOrientation
                            .bottom, // Place scrollbar at the bottom
                        child: ListView.builder(
                          controller:
                              _scrollController, // Attach the scroll controller
                          scrollDirection: Axis.horizontal,
                          itemCount: productsManager.categories.length +
                              1, // +1 for "All"
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              // "All" button
                              return GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    _selectedCategory = null;
                                    _isLoading = true;
                                  });

                                  await productsManager
                                      .fetchProducts(); // Fetch all products

                                  setState(() {
                                    _isLoading = false;
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.only(right: 10),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: _selectedCategory == null
                                        ? color17
                                        : color13,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'All',
                                      style: TextStyle(
                                        color: _selectedCategory == null
                                            ? color4
                                            : color1,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              // Category buttons
                              final category =
                                  productsManager.categories[index - 1];
                              return GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    _selectedCategory = category;
                                    _isLoading = true;
                                  });

                                  await productsManager.fetchProducts(
                                      category:
                                          category); // Fetch products by category

                                  setState(() {
                                    _isLoading = false;
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.only(right: 10),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: _selectedCategory == category
                                        ? color17
                                        : color13,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Center(
                                    child: Text(
                                      category,
                                      style: TextStyle(
                                        color: _selectedCategory == category
                                            ? color4
                                            : color1,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    _isLoading
                        ? Expanded(
                            child: Center(child: CircularProgressIndicator()),
                          )
                        : productsManager.items.isEmpty
                            ? Expanded(
                                child: Center(
                                  child: Text(
                                    _selectedCategory != null
                                        ? "No products found in $_selectedCategory category"
                                        : "No products found",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                            : Expanded(
                                child: GridView.builder(
                                  padding: EdgeInsets.only(left: 8, right: 16),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                    childAspectRatio: 0.65,
                                  ),
                                  itemCount: productsManager.items.length,
                                  itemBuilder: (context, index) {
                                    final product =
                                        productsManager.items[index];
                                    return ProductItem(product: product);
                                  },
                                ),
                              ),
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(
            AddProductScreen.routeName,
            arguments: null, // Pass null to indicate a new product
          );
        },
        backgroundColor: color14,
        child: const Icon(
          Icons.add,
          color: color4,
        ),
      ),
    );
  }
}

class ProductItem extends StatelessWidget {
  final Product product;

  const ProductItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: color2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(8), // Add padding around the image
              child: Center(
                child: product.imageUrl.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(
                            10), // Border radius for the image
                        child: Image.network(
                          product.imageUrl,
                          width: double.infinity, // Chiếm toàn bộ chiều rộng
                          height: double.infinity, // Chiếm toàn bộ chiều cao
                          fit: BoxFit.fill, // Adjust the image fit
                        ),
                      )
                    : Placeholder(), // Fallback for empty imageUrl
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title,
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold, color: color4),
                ),
                SizedBox(height: 4),
                Text(
                  'Type: ${product.category}',
                  style: TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500, color: color4),
                ),
                SizedBox(height: 4),
                Text(
                  'Price: \$${product.price.toStringAsFixed(2)}',
                  style: TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500, color: color4),
                ),
                SizedBox(height: 4),
                Text(
                  'In Stock: ${product.stockQuantity.toStringAsFixed(0)}',
                  style: TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500, color: color4),
                ),
                SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Edit Button
                    IconButton(
                      icon: Icon(Icons.edit, color: color7),
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                          EditProductScreen.routeName,
                          arguments: product
                              .pid, // Pass ID instead of the whole product
                        );
                      },
                    ),
                    // Delete Button
                    IconButton(
                      icon: Icon(Icons.delete, color: color7),
                      onPressed: () async {
                        final confirm = await showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: Text("Confirm Delete"),
                            content: Text(
                                "Are you sure you want to delete this product?"),
                            actions: [
                              TextButton(
                                child: Text("Cancel"),
                                onPressed: () {
                                  Navigator.of(ctx).pop(false);
                                },
                              ),
                              TextButton(
                                child: Text("Delete"),
                                onPressed: () {
                                  Navigator.of(ctx).pop(true);
                                },
                              ),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          Provider.of<ProductsManager>(context, listen: false)
                              .deleteProduct(product.pid!);
                        }
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
