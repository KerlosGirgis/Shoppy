// lib/view_model/quantity/quantity_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoppy/view_model/quantity/quantity_state.dart';

class QuantityCubit extends Cubit<QuantityState> {
  final int unitPrice;

  QuantityCubit(this.unitPrice)
      : super(QuantityState(quantity: 1, totalPrice: unitPrice));

  void increment() {
    final newQuantity = state.quantity + 1;
    emit(QuantityState(
      quantity: newQuantity,
      totalPrice: unitPrice * newQuantity,
    ));
  }

  void decrement() {
    if (state.quantity > 1) {
      final newQuantity = state.quantity - 1;
      emit(QuantityState(
        quantity: newQuantity,
        totalPrice: unitPrice * newQuantity,
      ));
    }
  }

  void reset() {
    emit(QuantityState(quantity: 1, totalPrice: unitPrice));
  }
}
