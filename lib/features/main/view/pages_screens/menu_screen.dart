import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:story_view/story_view.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/theme/app_icons.dart';
import '../widgets/widgets.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final List<String> categories = ['dishes', 'snacks', 'sauces', 'drinks'];
  final ScrollController _scrollController = ScrollController();

  final Map<String, GlobalKey> _sectionKeys = {
    'dishes': GlobalKey(),
    'snacks': GlobalKey(),
    'sauces': GlobalKey(),
    'drinks': GlobalKey(),
  };

  void _scrollToCategory(String category) {
    final key = _sectionKeys[category];
    if (key == null) return;
    if (!_scrollController.hasClients) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final ctx = key.currentContext;
      if (ctx == null) return;

      final targetObject = ctx.findRenderObject();
      if (targetObject == null) return;

      final viewport = RenderAbstractViewport.of(targetObject);

      double target = viewport.getOffsetToReveal(targetObject, 0.0).offset;
      final pos = _scrollController.position;
      target = target.clamp(pos.minScrollExtent, pos.maxScrollExtent);

      _scrollController.animateTo(
        target,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
      );
    });
  }

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
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
                      tr(promo["title"]!), // ✅ локализация
                      style: theme.textTheme.bodySmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),
        ),

        // 🔹 Фиксированная строка категорий
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: categories.map((cat) {
              return ElevatedButton(
                onPressed: () => _scrollToCategory(cat),
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
                child: Text(tr(cat), style: const TextStyle(fontSize: 14)),
              );
            }).toList(),
          ),
        ),

        // 🔹 Контент
        Expanded(
          child: ListView(
            controller: _scrollController,
            children: [
              _buildSection(
                keyAnchor: _sectionKeys['dishes']!,
                title: tr('dishes'),
                items: List.generate(5, (i) => 'Burger $i'),
              ),
              _buildSection(
                keyAnchor: _sectionKeys['snacks']!,
                title: tr('snacks'),
                items: List.generate(3, (i) => 'Fries $i'),
              ),
              _buildSection(
                keyAnchor: _sectionKeys['sauces']!,
                title: tr('sauces'),
                items: List.generate(2, (i) => 'Sauce $i'),
              ),
              _buildSection(
                keyAnchor: _sectionKeys['drinks']!,
                title: tr('drinks'),
                items: List.generate(4, (i) => 'Cola $i'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSection({
    required GlobalKey keyAnchor,
    required String title,
    required List<String> items,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(key: keyAnchor, height: 0),
          Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Column(
            children: items.map((name) {
              return DishContainerShortcut(
                name: name,
                price: 1200,
                assetImage: AppIcons.logoAppetite,
                description: '${tr("description")} $name',
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
                            description: '${tr("full_description")} $name',
                            additions: [
                              {tr("cheese"): 200},
                              {tr("bacon"): 300},
                            ],
                            reductions: [
                              {tr("no_onion"): 0},
                              {tr("no_sauce"): 0},
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

