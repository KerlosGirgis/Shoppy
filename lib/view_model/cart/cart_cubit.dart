import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoppy/services/cart_service.dart';
import 'package:shoppy/view_model/cart/cart_state.dart';

class CartCubit extends Cubit<CartState>{
  CartCubit() : super(CartInitial());
  static CartCubit get(context) => BlocProvider.of(context);
  final CartService _cartService = CartService();



  Future<List<Map<String, dynamic>>> getCart() async {
    emit(CartLoading());
    try {
      final cart = await _cartService.getCart();
      if (cart.isEmpty) {
        emit(CartEmpty());
        return cart;
      }
      else{
        emit(CartSuccess(cart));
        return cart;
      }
    } catch (e) {
      emit(CartError(error: e.toString()));
      return [];
    }
  }
  Future<void> addToCart(String productId, int quantity) async {
    try {
      await _cartService.addToCart(productId, quantity);
      emit(CartSuccess(await _cartService.getCart()));
    } catch (e) {
      emit(CartError(error: e.toString()));
    }
  }
  Future<void> removeFromCart(String productId) async {

    try {
      await _cartService.removeFromCart(productId);
      emit(CartSuccess(await _cartService.getCart()));
    } catch (e) {
      emit(CartError(error: e.toString()));
    }
  }

  Future<void> clearCart() async {
    emit(CartLoading());
    try {
      await _cartService.clearCart();
      getCart();
    } catch (e) {
      emit(CartError(error: e.toString()));
    }
  }

  Future<void> removeOneFromCart(String productId) async {
    try {
      await _cartService.removeOneFromCart(productId);
      final cart = await _cartService.getCart();
      if(cart.isEmpty){
        emit(CartEmpty());
      }
      else{
        emit(CartSuccess(cart));
      }
    } catch (e) {
      emit(CartError(error: e.toString()));
    }
  }

  Future<void> checkOut() async {
    try {
      await _cartService.checkOut();
      emit(CartSuccess(await _cartService.getCart()));
    } catch (e) {
      emit(CartError(error: e.toString()));
    }

  }

}