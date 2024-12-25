import 'package:flutter/material.dart';
import 'package:shopping_list/models/item_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<ItemModel> items = [];

  @override
  void initState() {
    super.initState();
    items = ItemModel.getItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // backgroundColor: Colors.grey[900],
          title: const Text(
            'Your Groceries',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return _ListItem(
              items: items,
              index: index,
            );
          },
        ));
  }
}

class _ListItem extends StatelessWidget {
  const _ListItem({
    required this.items,
    required this.index,
  });

  final List<ItemModel> items;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
          child: Container(
            color: items[index].category.categoryColor,
            width: 30,
            height: 30,
          ),
        ),
        SizedBox(width: 20),
        Expanded(
          child: Text(items[index].name,
              textAlign: TextAlign.left,
              style: const TextStyle(color: Colors.white)),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: Text(
            items[index].count.toString(),
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
