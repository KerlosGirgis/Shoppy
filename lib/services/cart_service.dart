import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Get the current user's cart items.
  Future<List<Map<String, dynamic>>> getCart() async {
    final user = _auth.currentUser;
    if (user == null) return [];

    final userDoc = _firestore.collection('users').doc(user.uid);
    final snapshot = await userDoc.get();
    final cart = snapshot.data()?['cart'];

    if (cart is List) {
      return cart.whereType<Map<String, dynamic>>().toList();
    } else {
      return [];
    }
  }

  /// Add product to cart or increase its quantity if it already exists.
  Future<void> addToCart(String productId, int quantity) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final userDoc = _firestore.collection('users').doc(user.uid);
    final snapshot = await userDoc.get();

    if (snapshot.exists) {
      List<Map<String, dynamic>> cart = List<Map<String, dynamic>>.from(
        snapshot.data()?['cart'] ?? [],
      );

      bool productFound = false;

      for (var item in cart) {
        if (item['id'] == productId) {
          item['quantity'] += quantity;
          productFound = true;
          break;
        }
      }

      if (!productFound) {
        cart.add({'id': productId, 'quantity': quantity});
      }

      await userDoc.update({'cart': cart});
    }
  }

  /// Remove a product entirely from the cart.
  Future<void> removeFromCart(String productId) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final userDoc = _firestore.collection('users').doc(user.uid);
    final snapshot = await userDoc.get();

    if (snapshot.exists) {
      List<Map<String, dynamic>> cart = List<Map<String, dynamic>>.from(
        snapshot.data()?['cart'] ?? [],
      );

      cart.removeWhere((item) => item['id'] == productId);

      await userDoc.update({'cart': cart});
    }
  }

  /// Decrease the quantity of a product. If quantity becomes 0, remove it.
  Future<void> removeOneFromCart(String productId) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final userDoc = _firestore.collection('users').doc(user.uid);
    final snapshot = await userDoc.get();

    if (snapshot.exists) {
      List<Map<String, dynamic>> cart = List<Map<String, dynamic>>.from(
        snapshot.data()?['cart'] ?? [],
      );

      bool updated = false;

      for (int i = 0; i < cart.length; i++) {
        if (cart[i]['id'] == productId) {
          cart[i]['quantity'] -= 1;
          updated = true;

          if (cart[i]['quantity'] <= 0) {
            cart.removeAt(i);
          }
          break;
        }
      }

      if (updated) {
        await userDoc.update({'cart': cart});
      }
    }
  }

  /// Clear the entire cart.
  Future<void> clearCart() async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore.collection('users').doc(user.uid).update({'cart': []});
  }

  Future<void> checkOut() async {
    final user = _auth.currentUser;
    if (user == null) return;
    await _firestore.collection('users').doc(user.uid).update({
      'orders': FieldValue.arrayUnion([
        {
          'items': await getCart(),
          'timestamp': DateTime.now(),
        }
      ]),
      'cart': [],
    });
    await _firestore.collection('users').doc(user.uid).update({'cart': []});
  }
}
