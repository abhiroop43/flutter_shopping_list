import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/item_model.dart';
import 'package:shopping_list/pages/new_item.dart';

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
    // items = ItemModel.getItems();
    _getAllItems();
  }

  void _getAllItems() async {
    List<ItemModel> fetchedItems = [];
    var url = Uri.https(dotenv.env['BASEURL']!, 'shoppingList.json');
    var response = await http.get(url, headers: {
      'Accept': 'application/json',
    });

    debugPrint('Response: ${response.statusCode} : ${response.body}');

    if (response.statusCode != 200) {
      debugPrint('Error occured: ${response.body}');
    }

    var responseData = json.decode(response.body) as Map<String, dynamic>?;

    if (responseData == null || responseData.isEmpty) {
      return;
    }

    for (var item in responseData.entries) {
      var itemCategory = categories.entries
          .firstWhere((x) => x.value.name == item.value['category'])
          .value;
      fetchedItems.add(ItemModel(
          id: item.key,
          name: item.value['name'],
          quantity: item.value['quantity'],
          category: itemCategory));
    }

    setState(() {
      items = fetchedItems;
    });
  }

  void _addItem() async {
    final newItem = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const NewItemPage()));

    if (newItem != null) {
      setState(() {
        items.add(newItem as ItemModel);
      });
    }

    _getAllItems();
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
          actions: [
            IconButton(onPressed: _addItem, icon: const Icon(Icons.add))
          ],
        ),
        body: items.isNotEmpty
            ? ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: Key(items[index].id.toString()),
                    onDismissed: (direction) {
                      setState(() {
                        var deletedItem = items.removeAt(index);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                              '${deletedItem.name} removed from list',
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onErrorContainer),
                            ),
                            backgroundColor:
                                Theme.of(context).colorScheme.errorContainer));
                      });
                    },
                    background: Container(
                        color: Theme.of(context).colorScheme.errorContainer),
                    child: _ListItem(
                      items: items,
                      index: index,
                    ),
                  );
                },
              )
            : const Center(
                child: Text('No items added yet'),
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
    return ListTile(
      title: Text(items[index].name),
      leading: Container(
        color: items[index].category.categoryColor,
        width: 24,
        height: 24,
      ),
      trailing: Text(items[index].quantity.toString()),
    );
  }
}
