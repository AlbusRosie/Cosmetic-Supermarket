import 'package:flutter/material.dart';
import '../../models/product.dart';
import 'package:provider/provider.dart';
import 'products_manager.dart';
import '../cart/cart_manager.dart';
import 'product_detail_screen.dart';

const Color laranaPink = Color.fromARGB(255, 231, 110, 110);
const Color laranaYellow = Color(0xFFFFF8DC);
class UserProductListTile extends StatelessWidget {
  final Product product;

  const UserProductListTile(this.product, {super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Chuyển đến ProductDetailScreen khi nhấp vào sản phẩm
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => ProductDetailScreen(product),
          ),
        );
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        shadowColor: Colors.grey.withOpacity(0.3),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Phần hình ảnh và icon trái tim
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 143,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey[100],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      product.imageUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            color: laranaPink,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.image_not_supported,
                        size: 39,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                // Icon trái tim (nằm trên ảnh, góc dưới trái)
                Positioned(
                  left: 8,
                  bottom: 0,
                  child: IconButton(
                    onPressed: () {
                      context.read<ProductsManager>().updateProduct(
                            product.copyWith(
                              isFavorite: !product.isFavorite,
                            ),
                          );
                    },
                    icon: Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: Colors.white, // Màu nền trắng
                        borderRadius: BorderRadius.circular(20), // Bo tròn
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1), // Đổ bóng nhẹ
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        product.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: laranaPink, // Màu icon
                        size: 25, // Kích thước icon
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              padding:
                  const EdgeInsets.only(top: 7, left: 12, right: 12, bottom: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tên sản phẩm
                  Text(
                    product.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(201, 0, 0, 0),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "Stock: ${product.stockQuantity}", // Hiển thị số lượng stock
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey, // Màu chữ xám
                    ),
                  ),
                  // Dịch chuyển Row lên trên
                  Transform.translate(
                    offset: const Offset(0, -8), // Dịch chuyển lên trên 8 pixel
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Giá sản phẩm
                        Text(
                          "\$${product.price.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 21,
                            fontFamily: 'Lato',
                            color: laranaPink,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // Nút giỏ hàng
                        IconButton(
                          onPressed: () {
                            // Thêm sản phẩm vào giỏ hàng
                            final cart = context.read<CartManager>();
                            cart.addItem(product);
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                SnackBar(
                                  content: const Text(
                                    'Item added to cart',
                                  ),
                                  duration: const Duration(seconds: 2),
                                  action: SnackBarAction(
                                    label: 'UNDO',
                                    onPressed: () {
                                      cart.removeItem(product.pid!);
                                    },
                                  ),
                                ),
                              );
                          },
                          icon: Container(
                            child: const Icon(
                              Icons.shopping_cart,
                              color: Color.fromARGB(
                                  255, 228, 206, 82), // Màu laranaBlue
                              size: 23, // Kích thước icon
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
