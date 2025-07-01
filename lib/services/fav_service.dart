import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addFav(String fav) async {
    _firestore.collection('users').doc(_auth.currentUser?.uid).update({
      'favs': FieldValue.arrayUnion([fav]),
    });
  }

  Future<void> removeFav(String fav) async {
    _firestore.collection('users').doc(_auth.currentUser?.uid).update({
      'favs': FieldValue.arrayRemove([fav]),
    });
  }

  Future<List<String>> getFavs() async {
    DocumentSnapshot snapshot = await _firestore.collection('users').doc(_auth.currentUser?.uid).get();
    try{
      return List<String>.from(snapshot['favs']);
    }catch(e){
      return [];
    }
  }

  Future<bool> isFav(String fav) async {
    List<String> favs = await getFavs();
    return favs.contains(fav);
  }
}
