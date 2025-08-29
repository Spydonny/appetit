class ModificationType {
  final int id;
  final String name;
  final Map<String, String>? nameTranslations;
  final String category; // "sauce" или "removal"
  final bool isDefault;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  ModificationType({
    required this.id,
    required this.name,
    this.nameTranslations,
    required this.category,
    required this.isDefault,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ModificationType.fromJson(Map<String, dynamic> json) {
    return ModificationType(
      id: json['id'] as int,
      name: json['name'] as String,
      nameTranslations: (json['name_translations'] as Map<String, dynamic>?)
          ?.map((key, value) => MapEntry(key, value as String)),
      category: json['category'] as String,
      isDefault: json['is_default'] as bool,
      isActive: json['is_active'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}
