import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoppy/services/orders_service.dart';
import 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  OrdersCubit() : super(OrdersInitial());

  static OrdersCubit get(context) => BlocProvider.of(context);

  final OrdersService _ordersService = OrdersService();

  Future<void> getOrders() async {
    emit(OrdersLoading());
    try {
      final orders = await _ordersService.getOrders();
      if (orders.isEmpty) {
        emit(OrdersEmpty());
      } else {
        emit(OrdersLoaded(orders));
      }
    } catch (e) {
      emit(OrdersError(error: e.toString()));
    }
  }
}
