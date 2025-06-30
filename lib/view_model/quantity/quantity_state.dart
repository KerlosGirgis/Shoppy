class QuantityState {
  final int quantity;
  final int totalPrice;

  QuantityState({required this.quantity, required this.totalPrice});

  QuantityState copyWith({int? quantity, int? totalPrice}) {
    return QuantityState(
      quantity: quantity ?? this.quantity,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }
}