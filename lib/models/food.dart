import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();

const uuid = Uuid();

enum Category { fruit, vegetable, rice, meat, milk}

final categoryIcons = {
  Category.fruit: {
    'selected': Image.asset('img/fruit_pic1.png'),
    'unselected': Image.asset('img/fruit_pic0.png'),
  },
  Category.vegetable: {
    'selected': Image.asset('img/vegetable_pic1.png'),
    'unselected': Image.asset('img/vegetable_pic0.png'),
  },
  Category.rice: {
    'selected': Image.asset('img/rice_pic1.png'),
    'unselected': Image.asset('img/rice_pic0.png'),
  },
  Category.meat: {
    'selected': Image.asset('img/meat_pic1.png'),
    'unselected': Image.asset('img/meat_pic0.png'),
  },
  Category.milk: {
    'selected': Image.asset('img/milk_pic1.png'),
    'unselected': Image.asset('img/milk_pic0.png'),
  },
};


class Food {
  Food({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  }) : id = uuid.v4();

  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final List<Category> category;

  String get formattedDate {
    return formatter.format(date);
  }
}
