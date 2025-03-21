import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/order_item.dart';
import '../../../components/colors.dart';


class OrderItemCard extends StatelessWidget {
  final OrderItem order;
  final VoidCallback? onTap;

  const OrderItemCard(this.order, {super.key, this.onTap});

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return const Color.fromARGB(255, 94, 181, 97);
      case 'canceled':
        return const Color.fromARGB(255, 253, 72, 72);
      case 'confirmed':
        return Colors.blue;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color2,
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(order.user?.username ?? 'Unknown User',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 4),
                  Text(DateFormat('dd/MM/yyyy').format(order.dateTime),
                      style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                ],
              ),
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                        color: _getStatusColor(order.status).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12)),
                    child: Text(order.status.toUpperCase(),
                        style: TextStyle(
                            color: _getStatusColor(order.status),
                            fontSize: 12,
                            fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 8),
                  Text("\$${order.amount.toStringAsFixed(2)}",
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: color4)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
