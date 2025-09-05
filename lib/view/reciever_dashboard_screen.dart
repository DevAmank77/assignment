import 'package:assignment/auth_viewmodel.dart';
import 'package:assignment/request_card_widget.dart';
import 'package:assignment/request_details_screen.dart';
import 'package:assignment/request_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// VIEW: Dashboard for the Receiver to see pending requests.
class ReceiverDashboardView extends ConsumerWidget {
  const ReceiverDashboardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requestsAsyncValue = ref.watch(userRequestsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Assigned Requests'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authViewModelProvider.notifier).logout(),
          ),
        ],
      ),
      body: requestsAsyncValue.when(
        data: (requests) {
          if (requests.isEmpty) {
            return const Center(
              child: Text('No pending requests assigned to you.'),
            );
          }
          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final request = requests[index];
              return InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          RequestDetailsView(request: request),
                    ),
                  );
                },
                child: RequestCard(request: request),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
