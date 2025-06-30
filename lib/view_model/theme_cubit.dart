import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shoppy/theme/theme.dart';

class ThemeCubit extends Cubit<AppTheme> {
  ThemeCubit() : super(AppTheme(isDark: false));

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('isDark')) {
      final isDark = prefs.getBool('isDark')!;
      emit(AppTheme(isDark: isDark));
      return;
    }
    final user = _auth.currentUser;
    if (user != null) {
      final userDoc =
      await _firestore.collection('users').doc(user.uid).get();

      if (userDoc.exists && userDoc.data()?['isDark'] != null) {
        final isDark = userDoc.data()!['isDark'] as bool;
        await prefs.setBool('isDark', isDark); // cache for next time
        emit(AppTheme(isDark: isDark));
        return;
      }
    }
    emit(AppTheme(isDark: false));
  }

  Future<void> _saveTheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDark', isDark);

    final user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).set({
        'isDark': isDark,
      }, SetOptions(merge: true));
    }
  }

  Future<void> toggleTheme() async {
    final newTheme = !state.isDark;
    emit(AppTheme(isDark: newTheme));
    await _saveTheme(newTheme);
  }

  Future<void> setDark() async {
    emit(AppTheme(isDark: true));
    await _saveTheme(true);
  }

  Future<void> setLight() async {
    emit(AppTheme(isDark: false));
    await _saveTheme(false);
  }

  Future<void> clearUserTheme({bool clearLocal = false}) async {
    if (clearLocal) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('isDark');
    }

    final user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).set({
        'isDark': FieldValue.delete(),
      }, SetOptions(merge: true));
    }

    // Optional: reset UI
    emit(AppTheme(isDark: false));
  }
}
