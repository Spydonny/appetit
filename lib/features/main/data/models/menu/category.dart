import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final int id;
  final String name;
  final int sort;

  const Category({
    required this.id,
    required this.name,
    required this.sort,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      sort: json['sort'],
    );
  }

  @override
  List<Object?> get props => [id, name, sort];
}

