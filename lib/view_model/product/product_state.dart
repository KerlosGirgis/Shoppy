import '../../models/product.dart';

abstract class ProductState {}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductError extends ProductState {
  final String message;
  ProductError({required this.message});
}

class ProductLoaded extends ProductState {
  final List<Product> products;      // Filtered list
  final List<Product> allProducts;   // Full list

  ProductLoaded({
    required this.products,
    required this.allProducts,
  });
}

class ProductEmpty extends ProductState {}
