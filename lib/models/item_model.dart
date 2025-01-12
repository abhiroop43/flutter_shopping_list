import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/category_model.dart';

class ItemModel {
  String id;
  String name;
  int quantity;
  CategoryModel category;

  ItemModel(
      {required this.id,
      required this.name,
      required this.quantity,
      required this.category});

  static List<ItemModel> getItems() {
    List<ItemModel> items = [];

    items.add(ItemModel(
        id: '1',
        name: 'Milk',
        quantity: 1,
        category: categories[Categories.dairy]!));
    items.add(ItemModel(
        id: '2',
        name: 'Bananas',
        quantity: 5,
        category: categories[Categories.fruit]!));
    items.add(ItemModel(
        id: '3',
        name: 'Beef Steak',
        quantity: 1,
        category: categories[Categories.meat]!));

    return items;
  }
}
