import 'dart:convert';
import 'package:assignment/request_model.dart';
import 'package:assignment/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

// This is a simple way to implement the Singleton pattern with Riverpod.
final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

class ApiService {
  // Use a different base URL for Android emulator vs. iOS simulator/physical device.
  final String _baseUrl = "http://10.81.90.246:3000/api";

  /// Attempts to log in a user with the given username.
  Future<User> login(String username) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'username': username}),
    );

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON and return a User object.
      return User.fromJson(json.decode(response.body));
    } else {
      // If the server returns an error, throw an exception.
      throw Exception('Failed to login. User not found.');
    }
  }

  /// Fetches the list of all available items for creating a request.
  Future<List<Map<String, dynamic>>> getItems() async {
    final response = await http.get(Uri.parse('$_baseUrl/items'));
    if (response.statusCode == 200) {
      // The backend returns a List<dynamic>, so we cast it.
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load items.');
    }
  }

  /// Fetches requests based on the user's role and ID.
  Future<List<Request>> getRequests(String role, int userId) async {
    final uri = Uri.parse('$_baseUrl/requests?role=$role&userId=$userId');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      // Map the JSON list to a list of Request objects.
      return data.map((json) => Request.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load requests.');
    }
  }

  /// Submits a new request to the backend.
  Future<void> createRequest({
    required int userId,
    required List<int> itemIds,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/requests'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'userId': userId, 'itemIds': itemIds}),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create request.');
    }
  }

  /// Submits confirmation for items in a request.
  Future<void> submitConfirmation({
    required int requestId,
    required List<Map<String, dynamic>> confirmations,
  }) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/requests/$requestId/confirm'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'confirmations': confirmations}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to submit confirmation.');
    }
  }
}
