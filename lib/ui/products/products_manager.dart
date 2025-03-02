import '../../../models/product.dart';
import 'package:flutter/foundation.dart';

class ProductsManager with ChangeNotifier {
  final List<Product> _items = [
    // Snacks & Sweets
    Product(
      pid: 'p1',
      pname: 'Oreo Cookies',
      description: 'Delicious Oreo cookies with chocolate flavor.',
      price: 2.99,
      img: 'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
      isFavorite: false,
      category: 'Snacks & Sweets',
      stockQuantity: 25,
    ),
    Product(
      pid: 'p2',
      pname: 'Lay\'s Chips',
      description: 'Crispy and delicious potato chips.',
      price: 3.49,
      img: 'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
      isFavorite: false,
      category: 'Snacks & Sweets',
      stockQuantity: 30,
    ),
    Product(
      pid: 'p3',
      pname: 'KitKat Bar',
      description: 'Crispy wafers covered in smooth milk chocolate.',
      price: 1.99,
      img: 'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
      isFavorite: false,
      category: 'Snacks & Sweets',
      stockQuantity: 20,
    ),

    // Instant Noodles & Soups
    Product(
      pid: 'p4',
      pname: 'Shin Ramyun Noodles',
      description: 'Korean spicy ramen noodles.',
      price: 4.99,
      img: 'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
      isFavorite: false,
      category: 'Instant Noodles & Soups',
      stockQuantity: 40,
    ),
    Product(
      pid: 'p5',
      pname: 'Maruchan Ramen',
      description: 'Classic instant chicken ramen noodles.',
      price: 2.99,
      img: 'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
      isFavorite: false,
      category: 'Instant Noodles & Soups',
      stockQuantity: 35,
    ),
    Product(
      pid: 'p6',
      pname: 'Nissin Noodles Shrimp',
      description: 'Easy-to-cook shrimp-flavored instant noodles.',
      price: 3.49,
      img: 'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
      isFavorite: false,
      category: 'Instant Noodles & Soups',
      stockQuantity: 50,
    ),

    // Beverages
    Product(
      pid: 'p7',
      pname: 'Coca-Cola',
      description: 'Refreshing Coca-Cola soft drink.',
      price: 1.99,
      img: 'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
      isFavorite: false,
      category: 'Beverages',
      stockQuantity: 100,
    ),
    Product(
      pid: 'p8',
      pname: 'Starbucks Coffee',
      description: 'Premium cold brew coffee by Starbucks.',
      price: 4.49,
      img: 'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
      isFavorite: false,
      category: 'Beverages',
      stockQuantity: 60,
    ),
    Product(
      pid: 'p9',
      pname: 'Lipton Green Tea',
      description: 'Healthy and refreshing green tea drink.',
      price: 2.99,
      img: 'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
      isFavorite: false,
      category: 'Beverages',
      stockQuantity: 70,
    ),

    // Personal Care & Hygiene
    Product(
      pid: 'p10',
      pname: 'Colgate Toothpaste',
      description: 'Refreshing mint-flavored toothpaste.',
      price: 3.49,
      img: 'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
      isFavorite: false,
      category: 'Personal Care & Hygiene',
      stockQuantity: 50,
    ),
    Product(
      pid: 'p11',
      pname: 'Dove Body Wash',
      description: 'Gentle and moisturizing body wash.',
      price: 5.99,
      img: 'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
      isFavorite: false,
      category: 'Personal Care & Hygiene',
      stockQuantity: 40,
    ),
    Product(
      pid: 'p12',
      pname: 'Nivea Men Deodorant',
      description: 'Long-lasting deodorant for men.',
      price: 4.99,
      img: 'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
      isFavorite: false,
      category: 'Personal Care & Hygiene',
      stockQuantity: 35,
    ),

    // Household Essentials
    Product(
      pid: 'p13',
      pname: 'Tide Liquid Detergent',
      description: 'Powerful liquid detergent for clean clothes.',
      price: 12.99,
      img: 'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
      isFavorite: false,
      category: 'Household Essentials',
      stockQuantity: 25,
    ),
    Product(
      pid: 'p14',
      pname: 'Bounty Paper Towels',
      description: 'Durable and absorbent paper towels.',
      price: 8.99,
      img: 'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
      isFavorite: false,
      category: 'Household Essentials',
      stockQuantity: 30,
    ),
    Product(
      pid: 'p15',
      pname: 'Clorox Disinfecting Wipes',
      description: 'Kills 99.9% of germs and bacteria.',
      price: 6.99,
      img: 'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
      isFavorite: false,
      category: 'Household Essentials',
      stockQuantity: 40,
    ),

    // Ready-to-Eat Meals
    Product(
      pid: 'p16',
      pname: 'Michelina\'s Mac & Cheese',
      description: 'Delicious mac and cheese frozen meal.',
      price: 4.99,
      img: 'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
      isFavorite: false,
      category: 'Ready-to-Eat Meals',
      stockQuantity: 20,
    ),
    Product(
      pid: 'p17',
      pname: 'Healthy Choice Chicken & Rice',
      description: 'Healthy frozen meal with chicken and rice.',
      price: 5.99,
      img: 'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
      isFavorite: false,
      category: 'Ready-to-Eat Meals',
      stockQuantity: 15,
    ),
    Product(
      pid: 'p18',
      pname: 'Campbell\'s Tomato Soup',
      description: 'Classic tomato soup, easy to prepare.',
      price: 2.49,
      img: 'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
      isFavorite: false,
      category: 'Ready-to-Eat Meals',
      stockQuantity: 50,
    ),
  ];

  int get itemCount {
    return _items.length;
  }

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((item) => item.isFavorite).toList();
  }

  Product? findById(String id) {
    try {
      return _items.firstWhere((item) => item.pid == id);
    } catch (error) {
      return null;
    }
  }

  void addProduct(Product product) {
    final newProduct =
        product.copyWith(pid: 'p${DateTime.now().toIso8601String()}');
    _items.add(newProduct);
    notifyListeners();
  }

  void updateProduct(Product product) {
    final index = _items.indexWhere((item) => item.pid == product.pid);
    if (index >= 0) {
      _items[index] = product;
      notifyListeners();
    }
  }

  void deleteProduct(String id) {
    _items.removeWhere((item) => item.pid == id);
    notifyListeners();
  }
}
