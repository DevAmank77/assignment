import 'package:assignment/request_model.dart';
import 'package:flutter/material.dart';

// A reusable widget to display summary information about a request.
class RequestCard extends StatelessWidget {
  final Request request;
  const RequestCard({super.key, required this.request});

  // Helper to determine the color and icon for each status.
  Widget _getStatusWidget() {
    Color color;
    IconData icon;
    switch (request.status) {
      case 'Confirmed':
        color = Colors.green;
        icon = Icons.check_circle;
        break;
      case 'Partially Fulfilled':
        color = Colors.orange;
        icon = Icons.pie_chart;
        break;
      case 'Pending':
      default:
        color = Colors.blue;
        icon = Icons.hourglass_top;
        break;
    }
    return Row(
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 4),
        Text(
          request.status,
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Request #${request.id}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _getStatusWidget(),
              ],
            ),
            const SizedBox(height: 12),
            Text('Items: ${request.items.length}'),
            const SizedBox(height: 8),
            // Display a preview of item names
            Text(
              request.items.map((item) => item.name).join(', '),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}
