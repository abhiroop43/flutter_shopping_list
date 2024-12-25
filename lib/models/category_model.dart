import 'package:flutter/material.dart';

class CategoryModel {
  String name;
  Color categoryColor;

  CategoryModel({required this.name, required this.categoryColor});
}

enum Categories {
  vegetables,
  fruit,
  meat,
  dairy,
  carbs,
  sweets,
  spices,
  convenience,
  hygiene,
  other
}