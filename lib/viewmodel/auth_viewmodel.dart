import 'package:assignment/api_service.dart';
import 'package:assignment/request_viewmodel.dart';
import 'package:assignment/socket_service.dart';
import 'package:assignment/user_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// --- ViewModel Layer: Manages authentication state and logic ---

final authViewModelProvider = StateNotifierProvider<AuthViewModel, AuthState>((
  ref,
) {
  return AuthViewModel(ref);
});

@immutable
class AuthState {
  final User? user;
  final bool isLoading;

  const AuthState({this.user, this.isLoading = false});

  bool get isAuthenticated => user != null;
}

class AuthViewModel extends StateNotifier<AuthState> {
  final Ref _ref;
  AuthViewModel(this._ref) : super(const AuthState()) {
    _loadUserFromPrefs();
  }

  Future<void> login(String username) async {
    state = const AuthState(isLoading: true);
    try {
      final user = await _ref.read(apiServiceProvider).login(username);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('userId', user.id);
      await prefs.setString('username', user.username);
      await prefs.setString('role', user.role);

      state = AuthState(user: user);
      _connectToSocket();
    } catch (e) {
      state = const AuthState(); // Reset on failure
      rethrow;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _ref.read(socketServiceProvider).disconnect();
    state = const AuthState();
  }

  Future<void> _loadUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('userId')) {
      final user = User(
        id: prefs.getInt('userId')!,
        username: prefs.getString('username')!,
        role: prefs.getString('role')!,
      );
      state = AuthState(user: user);
      _connectToSocket();
    }
  }

  void _connectToSocket() {
    if (state.isAuthenticated) {
      _ref
          .read(socketServiceProvider)
          .connectAndListen(
            state.user!.id,
            onUpdate: () {
              // When a real-time update is received, invalidate the provider
              // to force a refetch of the request list.
              _ref.invalidate(userRequestsProvider);
            },
          );
    }
  }
}
