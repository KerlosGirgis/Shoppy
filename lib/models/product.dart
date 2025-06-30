import 'package:shoppy/models/category.dart';

class Product {
  String id;
  String title;
  String description;
  int price;
  String imageCover;
  List<String> images;
  Category category;
  int ratingsAverage;

  Product(
    this.id,
    this.title,
    this.description,
    this.price,
    this.imageCover,
    this.images,
    this.category,
    this.ratingsAverage,
  );

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      json['id']??"",
      json['title']??"",
      json['description']??"",
      json['price']??0,
      json['imageCover']??"",
      (json['images'] as List).map((e) => e as String).toList(),
      Category.fromJson(json['category']),
      json['ratings_average']??0,
    );
  }
}
