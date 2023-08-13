import 'package:flutter/material.dart';

import '../../../../common/data/model/category_model.dart';
import '../../../../ui/theme/app_theme.dart';

class CategoryItem extends StatelessWidget {
  const CategoryItem({
    super.key,
    required this.colorList,
    required this.category,
    required this.index,
  });

  final List<Color> colorList;
  final CategoryModel category;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: colorList[index % colorList.length],
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Text(
              category.name ?? '',
              style: productNameStyle,
            ),
          ),
        ],
      ),
    );
  }
}
