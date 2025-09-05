import 'package:assignment/api_service.dart';
import 'package:assignment/request_model.dart';
import 'package:assignment/request_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Manages the state of confirmations for the detail view.
final confirmationStateProvider =
    StateProvider.family<Map<int, bool>, List<RequestItem>>((ref, items) {
      // Initialize all items as not yet confirmed.
      return {for (var item in items) item.itemId: false};
    });

// VIEW: Screen for the Receiver to confirm/deny items in a request.
class RequestDetailsView extends ConsumerWidget {
  final Request request;
  const RequestDetailsView({super.key, required this.request});

  Future<void> _submitConfirmation(BuildContext context, WidgetRef ref) async {
    final confirmationsMap = ref.read(confirmationStateProvider(request.items));

    // Convert the map to the format expected by the API.
    final confirmationsList = confirmationsMap.entries
        .map((entry) => {'itemId': entry.key, 'confirmed': entry.value})
        .toList();

    try {
      await ref
          .read(apiServiceProvider)
          .submitConfirmation(
            requestId: request.id,
            confirmations: confirmationsList,
          );

      ref.invalidate(userRequestsProvider); // Refresh the dashboard list
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Confirmation submitted!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Submission failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final confirmations = ref.watch(confirmationStateProvider(request.items));

    return Scaffold(
      appBar: AppBar(title: Text('Request #${request.id}')),
      body: ListView.builder(
        itemCount: request.items.length,
        itemBuilder: (context, index) {
          final item = request.items[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(item.name, style: const TextStyle(fontSize: 16)),
                  ToggleButtons(
                    isSelected: [
                      confirmations[item.itemId] == true,
                      confirmations[item.itemId] == false,
                    ],
                    onPressed: (int index) {
                      final isAvailable = index == 0;
                      ref
                          .read(
                            confirmationStateProvider(request.items).notifier,
                          )
                          .state = {
                        ...confirmations,
                        item.itemId: isAvailable,
                      };
                    },
                    borderRadius: BorderRadius.circular(8),
                    selectedColor: Colors.white,
                    fillColor: confirmations[item.itemId] == true
                        ? Colors.green
                        : Colors.red,
                    children: const [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text('Available'),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text('Unavailable'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () => _submitConfirmation(context, ref),
          child: const Text('SUBMIT CONFIRMATION'),
        ),
      ),
    );
  }
}
