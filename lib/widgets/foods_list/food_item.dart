import 'package:flutter/material.dart';

import 'package:test_dart/models/food.dart';

class FoodItem extends StatelessWidget {
  const FoodItem(this.food, {super.key});

  final Food food;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              food.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Text(
                  '${food.amount.toStringAsFixed(1)} kcal',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                Row(
                  children: Category.values.map((category) {
                    final icons = categoryIcons[category];
                    if (icons != null) {
                      return Row(
                        children: <Widget>[
                          food.category.contains(category)
                              ? icons['selected']!
                              : icons['unselected']!,
                          const SizedBox(width: 3),  // Adjust the width to control the space between images
                        ],
                      );
                    } else {
                      return const SizedBox.shrink();  // Return an empty widget if the category is not in the map
                    }
                  }).toList(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
