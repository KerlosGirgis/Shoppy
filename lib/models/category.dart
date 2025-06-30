class Category {
  String id;
  String name;
  String slug;
  String image;
  String createdAt;
  String updatedAt;

  Category(this.id,
      this.name,
      this.slug,
      this.image,
      this.createdAt,
      this.updatedAt,);

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      json["_id"]??"",
      json["name"]??"",
      json["slug"]??"",
      json["image"]??"",
      json["created_at"]??"",
      json["updated_at"]??"",
    );
  }


}
