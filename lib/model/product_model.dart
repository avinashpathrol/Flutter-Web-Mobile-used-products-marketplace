class Product {
  final String name;
  final String seller_name;
  final String price;
  final String description;
  final String signature;
  final String location;
  final String img;
  final String userId;
  final String date;
  final String productId;

  Product(
      {required this.name,
      required this.seller_name,
      required this.description,
      required this.price,
      required this.signature,
      required this.location,
      required this.userId,
      required this.img,
      required this.date,
      required this.productId});
}
