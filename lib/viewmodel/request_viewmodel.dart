import 'dart:async';
import 'package:assignment/api_service.dart';
import 'package:assignment/auth_viewmodel.dart';
import 'package:assignment/request_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// VIEWMODEL: This will manage the state and logic for fetching and creating requests.

/// Provider for fetching requests for the currently logged-in user.
/// This uses a StreamProvider to implement polling for real-time updates.
final userRequestsProvider = StreamProvider.autoDispose<List<Request>>((ref) {
  final authState = ref.watch(authViewModelProvider);
  final apiService = ref.watch(apiServiceProvider);
  final controller = StreamController<List<Request>>();

  // Timer to fetch data periodically (every 5 seconds).
  final timer = Timer.periodic(const Duration(seconds: 5), (_) async {
    if (authState.isAuthenticated) {
      try {
        final requests = await apiService.getRequests(
          authState.user!.role,
          authState.user!.id,
        );
        if (!controller.isClosed) {
          controller.add(requests);
        }
      } catch (e) {
        if (!controller.isClosed) {
          controller.addError(e);
        }
      }
    }
  });

  // When the provider is disposed (e.g., user logs out), cancel the timer and close the stream.
  ref.onDispose(() {
    timer.cancel();
    controller.close();
  });

  // Initial fetch
  Future<void> initialFetch() async {
    if (authState.isAuthenticated) {
      try {
        final requests = await apiService.getRequests(
          authState.user!.role,
          authState.user!.id,
        );
        if (!controller.isClosed) {
          controller.add(requests);
        }
      } catch (e) {
        if (!controller.isClosed) {
          controller.addError(e);
        }
      }
    }
  }

  initialFetch();

  return controller.stream;
});

/// Provider for fetching the catalog of available items.
final itemsProvider = FutureProvider.autoDispose<List<Map<String, dynamic>>>((
  ref,
) {
  final apiService = ref.watch(apiServiceProvider);
  return apiService.getItems();
});
