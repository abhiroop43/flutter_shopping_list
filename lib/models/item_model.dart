import 'package:flutter/material.dart';

class ItemModel {
  String name;
  int count;
  Color labelColor;

  ItemModel(
      {required this.name, required this.count, required this.labelColor});

  static List<ItemModel> getItems() {
    List<ItemModel> items = [];

    items.add(ItemModel(name: 'Milk', count: 1, labelColor: Colors.lightBlue));
    items.add(
        ItemModel(name: 'Bananas', count: 5, labelColor: Colors.lightGreen));
    items.add(
        ItemModel(name: 'Beef Steak', count: 1, labelColor: Colors.orange));

    return items;
  }
}
