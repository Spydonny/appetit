import 'package:appetite_app/features/shared/services/analytics_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:story_view/story_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../../core/core.dart';
import '../../data/models/menu/menu_item.dart';
import '../../logic/bloc/menu_bloc/menu_bloc.dart';
import '../widgets/widgets.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final analyticsService = getIt<AnalyticsService>();
  final ItemScrollController _scrollController = ItemScrollController();

  // 🔹 Заглушка для акций
  final List<Map<String, String>> promoStories = [
    {"title": "promo1", "image": "https://picsum.photos/200/300?random=1"},
    {"title": "promo2", "image": "https://picsum.photos/200/300?random=2"},
    {"title": "promo3", "image": "https://picsum.photos/200/300?random=3"},
  ];

  String lc = 'ru';

  @override
  void initState() {
    super.initState();
    context.read<MenuBloc>().add(LoadCategories(lc: lc));
    context.read<MenuBloc>().add(LoadItems(lc: lc));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    lc = context.locale.languageCode;
    context.read<MenuBloc>().add(LoadCategories(lc: lc));
    context.read<MenuBloc>().add(LoadItems(lc: lc));
  }
  void _openStories(int index) {
    final controller = StoryController();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          body: StoryView(
            controller: controller,
            storyItems: [
              StoryItem.pageImage(
                url: "https://picsum.photos/1080/1920?1",
                controller: controller,
                caption: Text(tr("promo_discount")),
              ),
              StoryItem.pageImage(
                url: "https://picsum.photos/1080/1920?2",
                controller: controller,
                caption: Text(tr("promo_today")),
              ),
              StoryItem.pageVideo(
                "https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4",
                controller: controller,
                caption: Text(tr("promo_video")),
              ),
            ],
            onComplete: () => Navigator.pop(context),
            repeat: false,
          ),
        ),
      ),
    );

    // analyticsService.logBannerView(bannerId: '', bannerName: 'promo');
  }

  void _scrollToCategory(int index) {
    _scrollController.scrollTo(
      index: index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<MenuBloc, MenuState>(
      builder: (context, state) {
        if (state.status == MenuStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.status == MenuStatus.failure) {
          return Center(child: Text(tr("error_loading_menu")));
        }

        final categories = state.categories;

        if (categories.isEmpty) {
          return Center(child: Text(tr("no_categories")));
        }

        return Column(
          children: [
            // 🔹 Промо истории
            SizedBox(
              height: 110,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                scrollDirection: Axis.horizontal,
                itemCount: promoStories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final promo = promoStories[index];
                  return GestureDetector(
                    onTap: () => _openStories(index),
                    child: Column(
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.redAccent, width: 2),
                            image: DecorationImage(
                              image: NetworkImage(promo["image"]!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          tr(promo["title"]!),
                          style: theme.textTheme.bodySmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // 🔹 Фиксированные кнопки категорий
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(categories.length, (index) {
                  final cat = categories[index];
                  return ElevatedButton(
                    onPressed: () => _scrollToCategory(index),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black12,
                      foregroundColor: Colors.black,
                      minimumSize: const Size(48, 48),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(cat.name, style: theme.textTheme.labelLarge),
                  );
                }),
              ),
            ),

            // 🔹 Контент
            Expanded(
              child: ScrollablePositionedList.builder(
                itemScrollController: _scrollController,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final cat = categories[index];
                  final items = state.items
                      .where((i) => i.categoryId == cat.id)
                      .toList();

                  return _buildSection(
                    title: cat.name,
                    items: items,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSection({
    required String title,
    required List<MenuItem> items,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Column(
            children: items.map((item) {
              return DishContainerShortcut(
                name: item.name,
                price: item.price,
                imageUrl: item.imageUrl ?? '',
                description: item.description ?? '',
                onTap: () {
                  analyticsService.logDishView(
                    dishId: item.id.toString(),
                    dishName: item.name,
                    category: title,
                    price: item.price,
                  );
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) {
                      return FractionallySizedBox(
                        heightFactor: 0.9,
                        child: SingleChildScrollView(
                          child: DishContainer(
                            id: item.id,
                            imageUrl: item.imageUrl ?? '',
                            name: item.name,
                            category: title,
                            price: item.price,
                            description: item.description ?? '',
                            additions: [
                              {'name': 'Сыр', 'price': 500.0, 'countable': false},
                              {'name': 'Бекон', 'price': 300.0, 'countable': true},
                            ],
                            reductions: [
                              {"name": "Без лука", "price": 0.0},
                              {"name": "Без мяса", "price": 0.0},
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

