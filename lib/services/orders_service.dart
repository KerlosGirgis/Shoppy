import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrdersService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<List<Map<String, dynamic>>> getOrders() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      throw Exception("User not logged in");
    }

    final doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists) {
      return [];
    }

    final data = doc.data();
    final List<dynamic> orders = data?['orders'] ?? [];

    return orders.cast<Map<String, dynamic>>();
  }
}
