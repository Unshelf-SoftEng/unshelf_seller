import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unshelf_seller/models/item_model.dart';

class ProductModel implements ItemModel {
  @override
  String get id => productId;
  final String productId;
  String name;
  String description;
  double price;
  int stock;
  DateTime expiryDate;
  int discount;
  String mainImageUrl;
  List<String>? additionalImageUrls;

  ProductModel({
    required this.productId,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.expiryDate,
    required this.discount,
    required this.mainImageUrl,
    this.additionalImageUrls,
  });

  // Factory method to create StoreModel from Firebase document snapshot
  factory ProductModel.fromSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ProductModel(
      productId: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] ?? 0.0).toDouble(),
      stock: data['stock'] ?? 0,
      expiryDate: (data['expiryDate'] as Timestamp).toDate(),
      discount: data['discount'] ?? 0,
      mainImageUrl: data['mainImageUrl'] ?? '',
      additionalImageUrls: (data['additionalImageUrls'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );
  }
}
