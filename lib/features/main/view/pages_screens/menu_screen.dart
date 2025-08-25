import 'package:flutter/material.dart';
import 'package:story_view/story_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../../core/theme/app_icons.dart';
import '../widgets/widgets.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final List<String> categories = ['dishes', 'snacks', 'sauces', 'drinks'];

  final ItemScrollController _scrollController = ItemScrollController();

  // 🔹 Заглушка для акций
  final List<Map<String, String>> promoStories = [
    {"title": "promo1", "image": "https://picsum.photos/200/300?random=1"},
    {"title": "promo2", "image": "https://picsum.photos/200/300?random=2"},
    {"title": "promo3", "image": "https://picsum.photos/200/300?random=3"},
  ];

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
                child: Text(tr(cat), style: theme.textTheme.labelLarge),
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

              // разное кол-во элементов для примера
              final items = switch (cat) {
                'dishes' => List.generate(5, (i) => 'Шаурма $i'),
                'snacks' => List.generate(3, (i) => 'Фри $i'),
                'sauces' => List.generate(2, (i) => 'Соусы $i'),
                'drinks' => List.generate(4, (i) => 'Напитки $i'),
                _ => <String>[],
              };

              return _buildSection(
                title: tr(cat),
                items: items,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required List<String> items,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Column(
            children: items.map((name) {
              return DishContainerShortcut(
                name: name,
                price: 1200,
                assetImage: AppIcons.logoAppetite,
                description: 'Описание $name',
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) {
                      return FractionallySizedBox(
                        heightFactor: 0.9,
                        child: SingleChildScrollView(
                          child: DishContainer(
                            image: AppIcons.logoAppetite,
                            name: name,
                            price: 1200,
                            description: 'Описание - $name',
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

