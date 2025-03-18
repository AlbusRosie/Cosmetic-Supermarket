import 'package:http/http.dart' as http;
import 'package:pocketbase/pocketbase.dart';

import '../models/product.dart';

import 'pocketbase_client.dart';

class ProductsService {
  String _getFeaturedImageUrl(PocketBase pb, RecordModel productModel) {
    final featuredImageName = productModel.getStringValue('featuredImage');
    return pb.files.getUrl(productModel, featuredImageName).toString();
  }
  Future<List<Product>> fetchProducts({bool filteredByUser = false}) async {
    final List<Product> products = [];
    try {
      final pb = await getPocketbaseInstance();
      final userId = pb.authStore.record!.id;
      final productModels = await pb
          .collection('products')
          .getFullList(filter: filteredByUser ? "userId='$userId'" : null);
      for (final productModel in productModels) {
        products.add(
          Product.fromJson(
            productModel.toJson()
              ..addAll({'imageUrl': _getFeaturedImageUrl(pb, productModel)}),
          ),
        );
      }
      return products;
    } catch (error) {
      print('Error fetching products: $error'); // Thêm log lỗi
      return products;
    }
  }

  Future<Product?> updateProduct(Product product) async {
    try {
      final pb = await getPocketbaseInstance();

      final productModel = await pb.collection('products').update(
            product.pid!,
            body: product.toJson(),
            files: product.featuredImage != null
                ? [
                    http.MultipartFile.fromBytes(
                      'featuredImage',
                      await product.featuredImage!.readAsBytes(),
                      filename: product.featuredImage!.uri.pathSegments.last,
                    ),
                  ]
                : [],
          );

      return product.copyWith(
        imageUrl: product.featuredImage != null
            ? _getFeaturedImageUrl(pb, productModel)
            : product.imageUrl,
      );
    } catch (error) {
      return null;
    }
  }
}
