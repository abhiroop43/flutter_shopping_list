import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/category_model.dart';

class ItemModel {
  int id;
  String name;
  int count;
  CategoryModel category;

  ItemModel(
      {required this.id,
      required this.name,
      required this.count,
      required this.category});

  static List<ItemModel> getItems() {
    List<ItemModel> items = [];

    items.add(ItemModel(
        id: 1,
        name: 'Milk',
        count: 1,
        category: categories[Categories.dairy]!));
    items.add(ItemModel(
        id: 2,
        name: 'Bananas',
        count: 5,
        category: categories[Categories.fruit]!));
    items.add(ItemModel(
        id: 3,
        name: 'Beef Steak',
        count: 1,
        category: categories[Categories.meat]!));

    return items;
  }
}
