import 'package:flutter/material.dart';

Future<bool?> showConfirmDialog(BuildContext context, String message) {
  return showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor:
          const Color.fromARGB(255, 255, 245, 245), // Màu nền hồng nhạt
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16), // Bo tròn viền
      ),
      icon: const Icon(
        Icons.warning,
        color: Color.fromARGB(255, 255, 71, 105), // Màu hồng đậm
        size: 32,
      ),
      title: const Text(
        'Are you sure?',
        style: TextStyle(
          color: Color.fromARGB(255, 255, 105, 133), // Màu hồng đậm
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        message,
        style: const TextStyle(
          fontSize: 19,
          color: Colors.black87,
        ),
      ),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: ActionButton(
                actionText: 'No',
                buttonColor: Colors.grey.shade200,
                textColor: Colors.grey.shade700,
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
              ),
            ),
            const SizedBox(width: 8), // Khoảng cách giữa hai nút
            Expanded(
              child: ActionButton(
                actionText: 'Yes',
                buttonColor:const Color.fromARGB(255, 250, 118, 142), // Màu hồng đậm
                textColor: Colors.white,
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    this.actionText,
    this.onPressed,
    this.buttonColor,
    this.textColor,
  });

  final String? actionText;
  final void Function()? onPressed;
  final Color? buttonColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor:
            buttonColor ?? const Color.fromARGB(255, 255, 40, 79),
        foregroundColor: textColor ?? Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25), // Bo tròn nút
        ),
        padding: const EdgeInsets.symmetric(vertical: 10),
        elevation: 2, // Đổ bóng nhẹ
      ),
      child: Text(
        actionText ?? 'Okay',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: textColor ?? Colors.white,
        ),
      ),
    );
  }
}

Future<void> showErrorDialog(BuildContext context, String message) {
  return showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor:
          const Color.fromARGB(255, 255, 245, 245), // Màu nền hồng nhạt
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16), // Bo tròn viền
      ),
      icon: const Icon(
        Icons.error,
        color: Colors.red,
        size: 32,
      ),
      title: const Text(
        'An Error Occurred!',
        style: TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        message,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black87,
        ),
      ),
      actions: <Widget>[
        Container(
          width: double.infinity, // Nút chiếm toàn bộ chiều rộng
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ActionButton(
            actionText: 'Close',
            buttonColor: Colors.red.shade400,
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ),
      ],
    ),
  );
}
