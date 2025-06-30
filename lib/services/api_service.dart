import 'package:dio/dio.dart';
import '../models/category.dart';
import '../models/product.dart';

class ApiService {
  Dio dio = Dio();
  Future<List<Category>> getCategories() async {
    try {
      Response res = await dio.get(
        'https://ecommerce.routemisr.com/api/v1/categories',
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      return res.data['data']
          .map<Category>((item) => Category.fromJson(item))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<Product>> getProducts() async {
    try {
      Response res = await dio.get(
        'https://ecommerce.routemisr.com/api/v1/products',
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      return res.data['data']
          .map<Product>((item) => Product.fromJson(item))
          .toList();
    } catch (e) {
      return [];
    }
  }
}
