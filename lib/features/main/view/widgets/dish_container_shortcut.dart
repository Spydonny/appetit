import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../widgets/widgets.dart';

class DishContainerShortcut extends StatefulWidget {
  const DishContainerShortcut({
    super.key,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.onTap,
  });

  final String imageUrl;
  final String name;
  final String description;
  final double price;
  final VoidCallback? onTap;

  @override
  State<DishContainerShortcut> createState() => _DishContainerShortcutState();
}

class _DishContainerShortcutState extends State<DishContainerShortcut> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.sizeOf(context).width;

    return GestureDetector(
      onTap: widget.onTap,
      child: DefaultContainer(
        width: screenWidth * 0.9,
        child: Row(
          children: [
            /// Кэшированная загрузка превью
            CachedNetworkImage(
              imageUrl: widget.imageUrl,
              height: 35,
              width: 35,
              fit: BoxFit.cover,
              placeholder: (context, url) => const SizedBox(
                height: 35,
                width: 35,
                child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
              ),
              errorWidget: (context, url, error) =>
              const Icon(Icons.broken_image, size: 35),
            ),
            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[500],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'От ${widget.price} ₸',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
