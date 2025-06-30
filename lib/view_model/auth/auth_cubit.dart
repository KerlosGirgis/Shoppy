import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shoppy/view_model/theme_cubit.dart';
import '../../services/auth_service.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService _authService;
  StreamSubscription<User?>? _authSubscription;

  AuthCubit({required AuthService authService})
      : _authService = authService,
        super(const AuthInitial()) {
    _initializeAuthState();

    _authSubscription = _authService.authStateChanges.listen((user) async {
      if (user != null) {
        emit(AuthAuthenticated(user));
        await ThemeCubit().loadTheme();
      } else {
        emit(const AuthInitial());
        await ThemeCubit().clearUserTheme();
      }
    });
  }

  void _initializeAuthState() {
    final currentUser = _authService.getCurrentUser();
    if (currentUser != null) {
      emit(AuthAuthenticated(currentUser));
    }
  }

  Future<void> signUp(
      String fName,
      String lName,
      String email,
      String password,
      ) async {
    emit(const AuthLoading());
    final error = await _authService.signUp(fName, lName, email, password);

    if (error != null) {
      emit(AuthError(error));
    } else {
      emit(const AuthSuccess());
    }
  }

  Future<void> signIn(String email, String password) async {
    emit(const AuthLoading());
    final error = await _authService.signIn(email, password);

    if (error != null) {
      emit(AuthError(error));
    } else {
      emit(const AuthSuccess());
    }
  }

  Future<void> signInWithGoogle() async {
    emit(const AuthLoading());
    final error = await _authService.signInWithGoogle();
    if (error != null) {
      emit(AuthError(error));
    } else {
      emit(const AuthSuccess());
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    emit(const AuthInitial());
  }

  void clearErrors() {
    emit(const AuthInitial());
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}
