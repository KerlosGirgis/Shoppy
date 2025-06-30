import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoppy/view_model/product/product_state.dart';

import '../../models/product.dart';
import '../../services/api_service.dart';

class ProductCubit extends Cubit<ProductState> {
  ProductCubit() : super(ProductInitial());

  final ApiService apiService = ApiService();

  List<Product> _allProducts = [];

  Future<void> getProducts() async {
    emit(ProductLoading());
    try {
      final products = await apiService.getProducts();
      _allProducts = products;
      emit(ProductLoaded(products: _allProducts, allProducts: _allProducts));
    } catch (e) {
      emit(ProductError(message: e.toString()));
    }
  }

  Future<void> getProductByCategory(String categoryId) async {
    emit(ProductLoading());
    try {
      final products = await apiService.getProducts();
      final filtered = products.where((p) => p.category.id == categoryId).toList();
      _allProducts = filtered;
      emit(ProductLoaded(products: filtered, allProducts: filtered));
    } catch (e) {
      emit(ProductError(message: e.toString()));
    }
  }

  Future<void> getList(List<String> list) async {
    emit(ProductLoading());
    try {
      final products = await apiService.getProducts();
      final filtered = products.where((product) => list.contains(product.id)).toList();
      _allProducts = filtered;
      if (filtered.isEmpty) {
        emit(ProductEmpty());
      } else {
        emit(ProductLoaded(products: filtered, allProducts: filtered));
      }
    } catch (e) {
      emit(ProductError(message: e.toString()));
    }
  }

  void filterProducts(String query) {
    if (_allProducts.isEmpty) return;
    final filtered = _allProducts
        .where((product) =>
        product.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
    emit(ProductLoaded(products: filtered, allProducts: _allProducts));
  }
}
