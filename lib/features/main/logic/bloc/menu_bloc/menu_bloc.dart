import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/core.dart';
import '../../../data/models/models.dart';
import '../../service/menu_services.dart';

part 'menu_event.dart';
part 'menu_state.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  final MenuService service = getIt<MenuService>();

  MenuBloc() : super(const MenuState()) {
    on<LoadCategories>(_onLoadCategories);
    on<LoadItems>(_onLoadItems);
    on<LoadItem>(_onLoadItem);
  }

  Future<void> _onLoadCategories(
      LoadCategories event,
      Emitter<MenuState> emit,
      ) async {
    emit(state.copyWith(status: MenuStatus.loading));
    try {
      final cats = await service.fetchCategories(lc: event.lc);
      emit(state.copyWith(status: MenuStatus.success, categories: cats));
    } catch (e) {
      emit(state.copyWith(status: MenuStatus.failure, error: e.toString()));
    }
  }

  Future<void> _onLoadItems(
      LoadItems event,
      Emitter<MenuState> emit,
      ) async {
    emit(state.copyWith(status: MenuStatus.loading));
    try {
      final items = await service.fetchItems(
        categoryId: event.categoryId,
        search: event.search,
        active: event.active,
        lc: event.lc,
      );
      emit(state.copyWith(status: MenuStatus.success, items: items));
    } catch (e) {
      emit(state.copyWith(status: MenuStatus.failure, error: e.toString()));
    }
  }

  Future<void> _onLoadItem(
      LoadItem event,
      Emitter<MenuState> emit,
      ) async {
    emit(state.copyWith(status: MenuStatus.loading));
    try {
      final item = await service.fetchItem(event.id, lc: event.lc);
      emit(state.copyWith(status: MenuStatus.success, selectedItem: item));
    } catch (e) {
      emit(state.copyWith(status: MenuStatus.failure, error: e.toString()));
    }
  }
}

