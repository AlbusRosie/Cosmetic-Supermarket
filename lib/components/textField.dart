import 'package:ct312h_project/ui/screens.dart';
import 'package:flutter/material.dart';

/// `TextFieldContainer` tạo khung cho ô nhập liệu với nền trắng và viền xám.
class TextFieldContainer extends StatelessWidget {
  final Widget child;
  const TextFieldContainer({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(
          horizontal: 20, vertical: 0), // Giảm padding dọc
      width: size.width * 0.8,
      decoration: BoxDecoration(
        color: Colors.white, // Màu nền trắng
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: color4, width: 1), // Viền xám
      ),
      child: child,
    );
  }
}

/// `RoundedInputField` tạo ô nhập liệu với icon và placeholder.
class RoundedInputField extends StatefulWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  final bool passwordInvisible;
  final bool confirmpasswordInvisible;
  final TextEditingController controller;

  const RoundedInputField({
    super.key,
    required this.hintText,
    required this.icon,
    required this.onChanged,
    this.passwordInvisible = false,
    this.confirmpasswordInvisible = false,
    required this.controller, 
  });

  @override
  RoundedInputFieldState createState() => RoundedInputFieldState();
}

class RoundedInputFieldState extends State<RoundedInputField> {
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _isPasswordVisible =
        !widget.passwordInvisible && !widget.confirmpasswordInvisible;
  }

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        controller: widget.controller,
        obscureText:
            (widget.passwordInvisible || widget.confirmpasswordInvisible) &&
                !_isPasswordVisible,
        onChanged: widget.onChanged,
        cursorColor: const Color(0xFF9a6e55), // Màu nâu
        style: const TextStyle(height: 1.2), // Giữ text ở vị trí trung tâm
        textAlignVertical:
            TextAlignVertical.center, // Căn giữa text theo chiều dọc
        decoration: InputDecoration(
          icon: Icon(
            widget.icon,
            color: color1, // Màu nâu
          ),
          suffixIcon:
              (widget.passwordInvisible || widget.confirmpasswordInvisible)
                  ? IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: color1,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    )
                  : null,
          hintText: widget.hintText,
          hintStyle: const TextStyle(color: color10),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15), // Căn giữa text
        ),
      ),
    );
  }
}
