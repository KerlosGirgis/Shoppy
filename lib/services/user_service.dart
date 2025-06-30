import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, String>> getUserData() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("No user signed in");
    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (!doc.exists) throw Exception("User document not found");
    final data = doc.data()!;
    return {
      'fName': data['fName'] ?? '',
      'lName': data['lName'] ?? '',
    };
  }
}
