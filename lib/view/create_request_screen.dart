import 'package:assignment/api_service.dart';
import 'package:assignment/auth_viewmodel.dart';
import 'package:assignment/request_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// State provider to manage the list of selected item IDs.
final selectedItemsProvider = StateProvider<List<int>>((ref) => []);

// VIEW: Screen for creating a new request.
class CreateRequestView extends ConsumerWidget {
  const CreateRequestView({super.key});

  Future<void> _submitRequest(BuildContext context, WidgetRef ref) async {
    final selectedItems = ref.read(selectedItemsProvider);
    final userId = ref.read(authViewModelProvider).user!.id;

    if (selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one item.')),
      );
      return;
    }

    try {
      await ref
          .read(apiServiceProvider)
          .createRequest(userId: userId, itemIds: selectedItems);
      // Invalidate the provider to force a refresh on the dashboard
      ref.invalidate(userRequestsProvider);
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Request submitted successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to submit request: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsyncValue = ref.watch(itemsProvider);
    final selectedItems = ref.watch(selectedItemsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Create New Request')),
      body: itemsAsyncValue.when(
        data: (items) => ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            final itemId = item['id'];
            final isSelected = selectedItems.contains(itemId);
            return CheckboxListTile(
              title: Text(item['name']),
              value: isSelected,
              onChanged: (bool? value) {
                if (value == true) {
                  ref.read(selectedItemsProvider.notifier).state = [
                    ...selectedItems,
                    itemId,
                  ];
                } else {
                  ref.read(selectedItemsProvider.notifier).state = selectedItems
                      .where((id) => id != itemId)
                      .toList();
                }
              },
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
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
          onPressed: () => _submitRequest(context, ref),
          child: const Text('SUBMIT REQUEST'),
        ),
      ),
    );
  }
}
