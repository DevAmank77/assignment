// MODEL: This file defines the data structures for a Request and its Items.

// Represents a single item within a request.
class RequestItem {
  final int itemId;
  final String name;
  final bool? confirmed; // Can be true, false, or null (not reviewed)

  RequestItem({required this.itemId, required this.name, this.confirmed});

  // Factory constructor to create a RequestItem from a JSON map.
  factory RequestItem.fromJson(Map<String, dynamic> json) {
    return RequestItem(
      itemId: json['itemId'],
      name: json['name'],
      confirmed: json['confirmed'],
    );
  }
}

// Represents an entire request made by a user.
class Request {
  final int id;
  final String status; // e.g., "Pending", "Confirmed", "Partially Fulfilled"
  final List<RequestItem> items;
  final int userId;
  final int assignedTo;

  Request({
    required this.id,
    required this.status,
    required this.items,
    required this.userId,
    required this.assignedTo,
  });

  // Factory constructor to create a Request from a JSON map.
  factory Request.fromJson(Map<String, dynamic> json) {
    // Parse the list of items from the JSON array.
    var itemsList = json['items'] as List;
    List<RequestItem> parsedItems = itemsList
        .map((itemJson) => RequestItem.fromJson(itemJson))
        .toList();

    return Request(
      id: json['id'],
      status: json['status'],
      items: parsedItems,
      userId: json['userId'],
      assignedTo: json['assignedTo'],
    );
  }
}
