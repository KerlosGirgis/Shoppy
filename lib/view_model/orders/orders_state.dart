abstract class OrdersState {}

class OrdersInitial extends OrdersState {}

class OrdersLoading extends OrdersState {}

class OrdersLoaded extends OrdersState {
  final List<Map<String, dynamic>> orders;
  OrdersLoaded(this.orders);
}

class OrdersEmpty extends OrdersState {}

class OrdersError extends OrdersState {
  final String error;
  OrdersError({required this.error});
}
