import 'package:ct312h_project/ui/screens.dart';
import 'package:flutter/material.dart';

class UpsideLogin extends StatelessWidget {
  const UpsideLogin({super.key, required this.imgUrl});
  final String imgUrl;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        // Background Image
        Container(
          width: size.width,
          height: size.height / 2.2, // Giảm chiều cao để ảnh gần đỉnh hơn
          color: const Color(0xFFffffff),
          alignment: Alignment.center, // Căn ảnh sát đỉnh
          child: SizedBox(
            width: size.width * 1, // Điều chỉnh kích thước ảnh nếu cần
            child: Image.asset(
              imgUrl,
              fit: BoxFit.contain, // Không kéo dãn ảnh
            ),
          ),
        ),
        // Back Button
        Padding(
          padding: const EdgeInsets.only(
              top: 20, left: 10), // Giảm khoảng cách với đỉnh
          child: IconButton(
            color: color4,
            iconSize: 28,
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context); // Quay lại màn hình trước đó
            },
          ),
        ),
      ],
    );
  }
}

class UpsideRegister extends StatelessWidget {
  const UpsideRegister({super.key, required this.imgUrl});
  final String imgUrl;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        // Background Image
        Container(
          width: size.width,
          height: size.height / 2.5, // Giảm chiều cao để ảnh gần đỉnh hơn
          color: const Color(0xFFffffff),
          alignment: Alignment.center, 
          child: SizedBox(
            width: size.width * 1, // Điều chỉnh kích thước ảnh nếu cần
            child: Image.asset(
              imgUrl,
              fit: BoxFit.contain, // Không kéo dãn ảnh
            ),
          ),
        ),
        // Back Button
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 10), // Giảm khoảng cách với đỉnh
          child: IconButton(
            color: color4,
            iconSize: 28,
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context); // Quay lại màn hình trước đó
            },
          ),
        ),
      ],
    );
  }
}
