import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:intl/intl.dart';

import 'package:test_dart/widgets/foods_list/food_item.dart';
import 'package:test_dart/models/food.dart';

class FoodsList extends StatelessWidget {
  const FoodsList({
    super.key,
    required this.foods,
    required this.onRemoveFood,
  });

  final List<Food> foods;
  final void Function(Food food) onRemoveFood;

  @override
  Widget build(BuildContext context) {
    final foodsByDate = groupBy(
        foods, (Food food) => DateFormat('yyyy/MM/dd').format(food.date));
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;

    return ListView.builder(
      itemCount: foodsByDate.keys.length,
      itemBuilder: (ctx, index) {
        final date = foodsByDate.keys.elementAt(index);
        final foodsForDate = foodsByDate[date]!;

        return Column(
          children: [
            Text(date, style: Theme
                .of(context)
                .textTheme
                .headlineSmall),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio: screenWidth / 90,
              ),
              itemCount: foodsForDate.length,
              itemBuilder: (ctx, index) =>
                  Dismissible(
                    key: ValueKey(foodsForDate[index]),
                    background: Container(
                      color: Theme
                          .of(context)
                          .colorScheme
                          .error
                          .withOpacity(0.75),
                      margin: EdgeInsets.symmetric(
                        horizontal: Theme
                            .of(context)
                            .cardTheme
                            .margin!
                            .horizontal,
                      ),
                    ),
                    onDismissed: (direction) {
                      onRemoveFood(foodsForDate[index]);
                    },
                    child: FoodItem(
                      foodsForDate[index],
                    ),
                  ),
            ),
          ],
        );
      },
    );
  }
}
