// lib/features/menu/bloc/menu_state.dart
part of 'menu_bloc.dart';

enum MenuStatus { initial, loading, success, failure }

class MenuState extends Equatable {
  final MenuStatus status;
  final List<Category> categories;
  final List<MenuItem> items;
  final MenuItem? selectedItem;
  final String? error;

  const MenuState({
    this.status = MenuStatus.initial,
    this.categories = const [],
    this.items = const [],
    this.selectedItem,
    this.error,
  });

  MenuState copyWith({
    MenuStatus? status,
    List<Category>? categories,
    List<MenuItem>? items,
    MenuItem? selectedItem,
    String? error,
  }) {
    return MenuState(
      status: status ?? this.status,
      categories: categories ?? this.categories,
      items: items ?? this.items,
      selectedItem: selectedItem ?? this.selectedItem,
      error: error ?? this.error,
    );
  }

  factory MenuState.fromJson(Map<String, dynamic> json) => MenuState(
    status: MenuStatus.success,
    categories: (json['categories'] as List<dynamic>?)
        ?.map((e) => Category.fromJson(e))
        .toList() ??
        [],
    items: (json['items'] as List<dynamic>?)
        ?.map((e) => MenuItem.fromJson(e))
        .toList() ??
        [],
    selectedItem: json['selectedItem'] != null
        ? MenuItem.fromJson(json['selectedItem'])
        : null,
  );

  @override
  List<Object?> get props => [status, categories, items, selectedItem, error];
}
