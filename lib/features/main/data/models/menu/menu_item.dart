import 'package:equatable/equatable.dart';

class MenuItem extends Equatable {
  final int id;
  final int? categoryId;
  final String name;
  final String? description;
  final double price;
  final String? imageUrl;
  final bool isActive;

  const MenuItem({
    required this.id,
    this.categoryId,
    required this.name,
    this.description,
    required this.price,
    this.imageUrl,
    required this.isActive,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'],
      categoryId: json['category_id'],
      name: json['name'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      imageUrl: json['image_url'],
      isActive: json['is_active'],
    );
  }

  @override
  List<Object?> get props => [
    id,
    categoryId,
    name,
    description,
    price,
    imageUrl,
    isActive,
  ];
}