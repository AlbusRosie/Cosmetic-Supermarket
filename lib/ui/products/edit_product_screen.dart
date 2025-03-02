import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product.dart';
import 'products_manager.dart';
import '../shared/dialog_utils.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit_product';
  EditProductScreen(Product? product, {super.key}) {
    if (product == null) {
      this.product = Product(
        pid: null,
        pname: '',
        price: 0,
        description: '',
        img: '',
        stockQuantity: 0,
        category: '',
      );
    } else {
      this.product = product;
    }
  }
  late final Product product;
  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _editForm = GlobalKey<FormState>();
  late Product _editedProduct;
  double _currentPrice = 0;
  final List<String> _categories = [
    'Snacks & Sweets',
    'Instant Noodles & Soups',
    'Beverages',
    'Personal Care & Hygiene',
    'Household Essentials',
    'Ready-to-Eat Meals',
  ];

  @override
  void initState() {
    _imageUrlFocusNode.addListener(() {
      if (!_imageUrlFocusNode.hasFocus) {
        if (!_isValidImageUrl(_imageUrlController.text)) {
          return;
        }
        setState(() {});
      }
    });
    _editedProduct = widget.product;
    _currentPrice = _editedProduct.price;
    _imageUrlController.text = _editedProduct.img;
    super.initState();
  }

  @override
  void dispose() {
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    final isValid = _editForm.currentState!.validate();
    if (!isValid) {
      return;
    }
    _editForm.currentState!.save();

    try {
      final productsManager = context.read<ProductsManager>();
      if (_editedProduct.pid != null) {
        productsManager.updateProduct(_editedProduct);
      } else {
        productsManager.addProduct(_editedProduct);
      }
    } catch (error) {
      await showErrorDialog(context, 'Something went wrong.');
    }

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Product',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(
                top: 35, bottom: 10),
            child: Center(
              child: Text(
                '𓏸𓈒 Interstella 𓈒𓏸',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _editForm,
                child: ListView(
                  children: <Widget>[
                    _buildTextFieldWithIcon(
                      labelText: 'Title',
                      icon: Icons.title,
                      initialValue: _editedProduct.pname,
                      onSaved: (value) => _editedProduct =
                          _editedProduct.copyWith(pname: value),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      margin: const EdgeInsets.only(left: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Price: \$${_currentPrice.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                          ),
                          Slider(
                            value: _currentPrice,
                            min: 0.0,
                            max: 100.0,
                            divisions: 10000,
                            label: _currentPrice.toStringAsFixed(2),
                            onChanged: (value) {
                              setState(() {
                                _currentPrice = value;
                                _editedProduct =
                                    _editedProduct.copyWith(price: value);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildTextFieldWithIcon(
                      labelText: 'Stock Quantity',
                      icon: Icons.format_list_numbered,
                      initialValue: _editedProduct.stockQuantity.toString(),
                      keyboardType: TextInputType.number,
                      onSaved: (value) => _editedProduct = _editedProduct
                          .copyWith(stockQuantity: int.parse(value!)),
                      validator: (value) {
                        if (value!.isEmpty)
                          return 'Please enter stock quantity.';
                        if (int.tryParse(value) == null)
                          return 'Please enter a valid number.';
                        if (int.parse(value) < 0)
                          return 'Stock quantity cannot be negative.';
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    // Dropdown cho Category
                    DropdownButtonFormField<String>(
                      value: _editedProduct.category.isEmpty
                          ? null
                          : _editedProduct.category,
                      decoration: InputDecoration(
                        labelText: 'Category',
                        labelStyle: TextStyle(
                            color: const Color.fromARGB(255, 47, 117, 106)),
                        prefixIcon: Icon(Icons.category, color: Colors.teal),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: Colors.teal.withOpacity(0.3), width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 201, 201, 201)
                                  .withOpacity(0.5)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: const Color.fromARGB(255, 7, 92, 83)
                                  .withOpacity(0.3),
                              width: 2.0),
                        ),
                        filled: true,
                        fillColor: const Color.fromARGB(255, 255, 255, 255),
                      ),
                      items: _categories.map((String category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _editedProduct =
                              _editedProduct.copyWith(category: value!);
                        });
                      },
                      validator: (value) =>
                          value == null ? 'Please select a category.' : null,
                    ),
                    const SizedBox(height: 20),
                    _buildTextFieldWithIcon(
                      labelText: 'Description',
                      icon: Icons.description,
                      initialValue: _editedProduct.description,
                      maxLines: 3,
                      onSaved: (value) => _editedProduct =
                          _editedProduct.copyWith(description: value),
                      validator: (value) {
                        if (value!.isEmpty)
                          return 'Please enter a description.';
                        if (value.length < 10)
                          return 'Should be at least 10 characters long.';
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildProductPreview(),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ElevatedButton(
                        onPressed: _saveForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Save',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextFieldWithIcon({
    required String labelText,
    required IconData icon,
    String? initialValue,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
    void Function(String?)? onSaved,
  }) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: const Color.fromARGB(255, 47, 117, 106)),
        prefixIcon: Icon(icon, color: Colors.teal),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              BorderSide(color: Colors.teal.withOpacity(0.3), width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
              color: Color.fromARGB(255, 201, 201, 201).withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
              color: const Color.fromARGB(255, 7, 92, 83).withOpacity(0.3),
              width: 2.0),
        ),
        filled: true,
        fillColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      onSaved: onSaved,
    );
  }

  Widget _buildProductPreview() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Container(
          width: 100,
          height: 100,
          margin: const EdgeInsets.only(top: 8, right: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              width: 1,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: _imageUrlController.text.isEmpty
              ? const Center(child: Text('Enter a URL'))
              : ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    _imageUrlController.text,
                    fit: BoxFit.cover,
                  ),
                ),
        ),
        Expanded(child: _buildImageURLField()),
      ],
    );
  }

  TextFormField _buildImageURLField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Image URL',
        labelStyle: TextStyle(color: Colors.grey),
        prefixIcon: Icon(Icons.image, color: Colors.teal),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              BorderSide(color: Colors.teal.withOpacity(0.3), width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
              color: Color.fromARGB(255, 201, 201, 201).withOpacity(0.5),
              width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              BorderSide(color: Colors.teal.withOpacity(0.5), width: 1.0),
        ),
        filled: true,
        fillColor: const Color.fromRGBO(255, 255, 255, 1),
      ),
      keyboardType: TextInputType.url,
      controller: _imageUrlController,
      focusNode: _imageUrlFocusNode,
      validator: (value) =>
          _isValidImageUrl(value!) ? null : 'Please enter a valid image URL.',
      onSaved: (value) => _editedProduct = _editedProduct.copyWith(img: value),
    );
  }

  bool _isValidImageUrl(String value) =>
      (value.startsWith('http') || value.startsWith('https')) &&
      (value.endsWith('.png') ||
          value.endsWith('.jpg') ||
          value.endsWith('.jpeg'));
}
