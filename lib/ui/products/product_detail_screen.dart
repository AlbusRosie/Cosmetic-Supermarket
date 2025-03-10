import 'package:ct312h_project/ui/products/products_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product.dart';
import '../cart/cart_screen.dart';
import '../products/user_products_screen.dart';
import '../cart/cart_manager.dart';
class ProductDetailScreen extends StatefulWidget {
  static const routeName = '/product_detail';
  const ProductDetailScreen(
    this.product, {
    super.key,
  });

  final Product product;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late bool _isFavorite;
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.product.isFavorite;
  }

  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  PageRouteBuilder _createAnimatedRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 500),
    );
  }

  void _navigateToHome(BuildContext context) {
    Navigator.of(context).pushReplacement(
      _createAnimatedRoute(UserProductsScreen()),
    );
  }

  void _navigateToCart(BuildContext context) {
    Navigator.of(context).push(
      _createAnimatedRoute(
        CartScreen(),
      ),
    );
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
    context.read<ProductsManager>().updateProduct(
          widget.product.copyWith(
            isFavorite: _isFavorite,
          ),
        );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isFavorite ? 'Added to Wishlist' : 'Removed from Wishlist',
          textAlign: TextAlign.center,
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color.fromARGB(255, 255, 105, 133), // Màu hồng đậm
      secondary: const Color(0xFFFFF8DC), // Màu kem cho nút
      surface:
          const Color.fromARGB(255, 255, 235, 235), // Màu hồng pastel cho nền
      surfaceTint: const Color.fromARGB(255, 255, 153, 153),
      primary: const Color.fromARGB(255, 255, 153, 153),
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onSurface: Colors.black,
    );
    final priceColor = const Color.fromARGB(255, 255, 105, 133); // Hot pink

    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: colorScheme,
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Color.fromARGB(255, 255, 105, 133),
          actions: [
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () => _navigateToHome(context),
            ),
            Consumer<CartManager>(
              builder: (ctx, cartManager, child) {
                return IconButton(
                  icon: Badge.count(
                    count: cartManager.productCount,
                    child: const Icon(Icons.shopping_cart),
                  ),
                  onPressed: () => _navigateToCart(context),
                );
              },
            ),
          ],
        ),
        backgroundColor: colorScheme.surface, // Nền màu hồng pastel
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: widget.product.pid!,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: AspectRatio(
                    aspectRatio: 1, // Tỷ lệ 1:1 để tạo hình vuông
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        color: Colors.white,
                        padding: const EdgeInsets.all(8),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            widget.product.imageUrl,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 12),
                child: Card(
                  elevation: 0, // Không có đổ bóng
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // Bo góc
                  ),
                  color: const Color.fromARGB(255, 255, 225, 225), // Màu nền
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Tên sản phẩm
                        Text(
                          widget.product.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Giá và đánh giá nằm ngang
                        Row(
                          children: [
                            // Đánh giá sản phẩm (bên trái)
                            Expanded(
                              flex: 2, // Chiếm 2 phần không gian
                              child: Row(
                                children: [
                                  Icon(Icons.star,
                                      color: Colors.amber, size: 20),
                                  Icon(Icons.star,
                                      color: Colors.amber, size: 20),
                                  Icon(Icons.star,
                                      color: Colors.amber, size: 20),
                                  Icon(Icons.star,
                                      color: Colors.amber, size: 20),
                                  Icon(Icons.star_half,
                                      color: Colors.amber, size: 20),
                                  const SizedBox(width: 8),
                                  Text(
                                    '4.5 (100 reviews)',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Giá sản phẩm (bên phải)
                            Expanded(
                              flex: 1, // Chiếm 1 phần không gian
                              child: Text(
                                '\$${widget.product.price}',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: priceColor, // Màu giá
                                ),
                                textAlign: TextAlign.end, // Căn phải
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Mô tả sản phẩm
                        ExpansionTile(
                          title: Text(
                            'Description',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                widget.product.description,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Phần nhập số lượng
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              Text(
                                'Quantity',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                              const Spacer(),
                              Container(
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: colorScheme.secondary),
                                  borderRadius: BorderRadius.circular(8),
                                  color: colorScheme.surface,
                                ),
                                child: Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove,
                                          color: Color.fromARGB(
                                              255, 239, 103, 93)),
                                      onPressed: _decrementQuantity,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12),
                                      child: Text(
                                        '$_quantity',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: colorScheme.onSurface,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.add,
                                          color: Colors.green),
                                      onPressed: _incrementQuantity,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Nút yêu thích và nút Add to Cart
                        Row(
                          children: [
                            // Nút yêu thích
                            Expanded(
                              flex: 1,
                              child: ElevatedButton.icon(
                                onPressed: _toggleFavorite,
                                icon: Icon(
                                  _isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: Colors.white,
                                ),
                                label: Text(
                                  _isFavorite ? 'Liked' : 'Like',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  minimumSize: const Size(0, 48),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(
                                width: 12), // Khoảng cách giữa hai nút

                            // Nút Add to Cart
                            Expanded(
                              flex:
                                  2, // Để nút Add to Cart chiếm nhiều không gian hơn
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  final cart = context.read<CartManager>();
                                  cart.addItem(widget.product,
                                      quantity: _quantity);

                                  ScaffoldMessenger.of(context)
                                    ..hideCurrentSnackBar()
                                    ..showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            'Added $_quantity x ${widget.product.title} to cart'),
                                      ),
                                    );
                                },
                                label: const Text(
                                  'Add To Cart',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: colorScheme.primary,
                                  foregroundColor: colorScheme.onPrimary,
                                  minimumSize: const Size(0, 48),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
