import 'package:flutter/material.dart';

const _categoryMeta = {
  'top_stories': ('Top Stories', Color(0xFFef4444)),
  'international': ('International', Color(0xFF3b82f6)),
  'ipl': ('IPL', Color(0xFFa855f7)),
  'npl': ('NPL', Color(0xFF22c55e)),
  'domestic': ('Domestic', Color(0xFFf97316)),
};

class CategoryBadge extends StatelessWidget {
  final String category;
  final bool large;

  const CategoryBadge({super.key, required this.category, this.large = false});

  @override
  Widget build(BuildContext context) {
    final meta = _categoryMeta[category];
    final label = meta?.$1 ?? category;
    final color = meta?.$2 ?? Colors.grey;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: large ? 8 : 6,
        vertical: large ? 3 : 2,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontSize: large ? 11 : 9,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

Color categoryColor(String category) {
  return _categoryMeta[category]?.$2 ?? Colors.grey;
}
