import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../orders/orders_manager.dart';
import '../../models/order_item.dart';
import 'package:provider/provider.dart';

// Định nghĩa màu sắc chính cho ứng dụng
const Color primaryColor = Color.fromARGB(255, 231, 110, 110);
const Color secondaryColor = Color(0xFFFFF8DC);
const Color cardBackgroundColor = Colors.white;

class OrderItemCard extends StatefulWidget {
  final OrderItem order;

  const OrderItemCard(this.order, {super.key});

  @override
  State<OrderItemCard> createState() => _OrderItemCardState();
}

class _OrderItemCardState extends State<OrderItemCard> {
  var _expanded = false;
  var _showDeleteConfirmation = false;
  var _isEditing = false;

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return const Color.fromARGB(255, 94, 181, 97);
      case 'canceled':
        return const Color.fromARGB(255, 253, 72, 72);
      case 'pending':
        return Colors.orange;
      default:
        return const Color.fromARGB(255, 71, 172, 255);
    }
  }

  // Màu nhạt hơn cho chip status
  Color _getSoftStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return const Color.fromARGB(255, 130, 200, 132); // Xanh lá nhạt hơn
      case 'canceled':
        return const Color.fromARGB(255, 239, 83, 80); // Đỏ nhạt hơn
      case 'pending':
        return const Color.fromARGB(255, 255, 183, 77); // Cam nhạt hơn
      default:
        return const Color.fromARGB(255, 100, 181, 246); // Xanh dương nhạt hơn
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: <Widget>[
            _buildOrderHeader(),
            if (_expanded) _buildOrderDetails(),
            if (_isEditing &&
                widget.order.status != 'completed' &&
                widget.order.status != 'canceled')
              _buildEditOptions(context),
            if (widget.order.status == 'completed' ||
                widget.order.status == 'canceled')
              _buildOrderStatusInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderHeader() {
    return Container(
      decoration: BoxDecoration(
        color: secondaryColor.withOpacity(0.3),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Row(
          children: [
            Text(
              '\$${widget.order.amount.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(width: 10),
            Chip(
              label: Text(
                widget.order.status.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: _getSoftStatusColor(widget.order.status),
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                // Bỏ viền của chip
                side: BorderSide.none,
              ),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            children: [
              const Icon(
                Icons.calendar_today,
                size: 16,
                color: Colors.grey,
              ),
              const SizedBox(width: 4),
              Text(
                DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime),
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
        trailing: _showDeleteConfirmation
            ? _buildDeleteConfirmation()
            : _buildActionButtons(),
      ),
    );
  }

  Widget _buildDeleteConfirmation() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(
            Icons.check_circle_outline,
            color: Colors.green,
            size: 28,
          ),
          onPressed: () async {
            final ordersManager =
                Provider.of<OrdersManager>(context, listen: false);
            await ordersManager.deleteOrder(widget.order.id!);
            setState(() {
              _showDeleteConfirmation = false;
            });
          },
        ),
        IconButton(
          icon: const Icon(
            Icons.cancel_outlined,
            color: Colors.red,
            size: 28,
          ),
          onPressed: () {
            setState(() {
              _showDeleteConfirmation = false;
            });
          },
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(
            _expanded ? Icons.expand_less : Icons.expand_more,
            color: primaryColor,
            size: 28,
          ),
          onPressed: () {
            setState(() {
              _expanded = !_expanded;
            });
          },
        ),
        if (widget.order.status != 'completed' &&
            widget.order.status != 'canceled')
          IconButton(
            icon: const Icon(
              Icons.edit_outlined,
              color: Colors.blue,
              size: 24,
            ),
            onPressed: () {
              setState(() {
                _isEditing = !_isEditing;
              });
            },
          ),
        IconButton(
          icon: const Icon(
            Icons.delete_outline,
            color: Colors.red,
            size: 24,
          ),
          onPressed: () {
            setState(() {
              _showDeleteConfirmation = true;
            });
          },
        ),
      ],
    );
  }

  Widget _buildOrderDetails() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(),
          const Text(
            'Items in Order:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            constraints: BoxConstraints(
              maxHeight: min(widget.order.productCount * 35.0 + 10, 180),
            ),
            child: ListView(
              children: widget.order.products.map((prod) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            '${prod.quantity}x',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 3,
                        child: Text(
                          prod.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          '\$${prod.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[800],
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Total:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '\$${widget.order.amount.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEditOptions(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Update Order Status:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildOutlinedStatusButton(
                context,
                'Completed',
                _getStatusColor('completed'),
                'completed',
              ),
              _buildOutlinedStatusButton(
                context,
                'Canceled',
                _getStatusColor('canceled'),
                'canceled',
              ),
              _buildCancelButton(),
            ],
          ),
        ],
      ),
    );
  }

  // Thay đổi kiểu hiển thị nút - màu nền trắng, viền và chữ theo màu tương ứng
  Widget _buildOutlinedStatusButton(
      BuildContext context, String label, Color color, String status) {
    return OutlinedButton(
      onPressed: () => _updateOrderStatus(context, status),
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: color,
        side: BorderSide(color: color, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Nút Cancel với màu nhạt hơn
  Widget _buildCancelButton() {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _isEditing = false;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[300], // Màu nền nhạt hơn
        foregroundColor: Colors.grey[700], // Màu chữ đậm hơn
        elevation: 0, // Bỏ shadow
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      ),
      child: const Text('Cancel'),
    );
  }

  Widget _buildOrderStatusInfo() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: _getStatusColor(widget.order.status).withOpacity(0.1),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
      ),
      child: Row(
        children: [
          Icon(
            widget.order.status == 'completed'
                ? Icons.check_circle_outline
                : Icons.cancel_outlined,
            color: _getStatusColor(widget.order.status),
          ),
          const SizedBox(width: 8),
          Text(
            widget.order.status == 'completed'
                ? 'This order has been completed'
                : 'This order has been canceled',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: _getStatusColor(widget.order.status),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _updateOrderStatus(BuildContext context, String status) async {
    final ordersManager = Provider.of<OrdersManager>(context, listen: false);
    final updatedOrder = widget.order.copyWith(status: status);
    print('Updating order status to: $status');

    await ordersManager.updateOrderStatus(updatedOrder.id!, status);
    setState(() {
      _isEditing = false;
    });
  }
}
