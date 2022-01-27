import 'package:cloud_firestore/cloud_firestore.dart';

class Order {
  final String id;
  final String productId;
  final String userId;
  final String username;
  final String status;
  final int quantity;
  final Timestamp createdAt;

  Order(
      {required this.id,
      required this.productId,
      required this.userId,
      required this.username,
      required this.quantity,
      required this.status,
      required this.createdAt});

  factory Order.fromDocumentSnapshot(dynamic doc, dynamic extraData) {
    return Order(
      id: doc.data()['id'],
      productId: doc.data()['product_id'],
      userId: doc.data()['user_id'],
      username: extraData['username'],
      quantity: doc.data()['quantity'],
      status: doc.data()['status'],
      createdAt: doc.data()['created_at'],
    );
  }
}
