import 'package:flutter/material.dart';
import 'package:shopping_list/models/category_model.dart';

var categories = {
  Categories.vegetables: CategoryModel(
    name: 'Vegetables',
    categoryColor: Color.fromARGB(255, 0, 255, 128),
  ),
  Categories.fruit: CategoryModel(
    name: 'Fruit',
    categoryColor: Color.fromARGB(255, 145, 255, 0),
  ),
  Categories.meat: CategoryModel(
    name: 'Meat',
    categoryColor: Color.fromARGB(255, 255, 102, 0),
  ),
  Categories.dairy: CategoryModel(
    name: 'Dairy',
    categoryColor: Color.fromARGB(255, 0, 208, 255),
  ),
  Categories.carbs: CategoryModel(
    name: 'Carbs',
    categoryColor: Color.fromARGB(255, 0, 60, 255),
  ),
  Categories.sweets: CategoryModel(
    name: 'Sweets',
    categoryColor: Color.fromARGB(255, 255, 149, 0),
  ),
  Categories.spices: CategoryModel(
    name: 'Spices',
    categoryColor: Color.fromARGB(255, 255, 187, 0),
  ),
  Categories.convenience: CategoryModel(
    name: 'Convenience',
    categoryColor: Color.fromARGB(255, 191, 0, 255),
  ),
  Categories.hygiene: CategoryModel(
    name: 'Hygiene',
    categoryColor: Color.fromARGB(255, 149, 0, 255),
  ),
  Categories.other: CategoryModel(
    name: 'Other',
    categoryColor: Color.fromARGB(255, 0, 225, 255),
  ),
};
