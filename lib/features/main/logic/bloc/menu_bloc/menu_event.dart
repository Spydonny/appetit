// lib/features/menu/bloc/menu_event.dart
part of 'menu_bloc.dart';

abstract class MenuEvent {}

class LoadCategories extends MenuEvent {
  final String lc;
  LoadCategories({this.lc = "ru"});
}

class LoadItems extends MenuEvent {
  final int? categoryId;
  final String? search;
  final bool? active;
  final String lc;

  LoadItems({
    this.categoryId,
    this.search,
    this.active = true,
    this.lc = "en",
  });
}

class LoadItem extends MenuEvent {
  final int id;
  final String lc;

  LoadItem(this.id, {this.lc = "ru"});
}

