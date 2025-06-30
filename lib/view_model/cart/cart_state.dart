abstract class CartState{
  const CartState();

  List<Object> get props => [];

}

class CartInitial extends CartState{}
class CartLoading extends CartState{}
class CartSuccess extends CartState{
  final List<Map<String, dynamic>> items;
  CartSuccess(this.items);
}
class CartError extends CartState{
  final String error;
  CartError({required this.error});
}
class CartEmpty extends CartState{}
