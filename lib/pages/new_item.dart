import 'package:flutter/material.dart';
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/category_model.dart';
import 'package:shopping_list/models/item_model.dart';

class NewItemPage extends StatefulWidget {
  const NewItemPage({super.key});

  @override
  State<NewItemPage> createState() => _NewItemPageState();
}

class _NewItemPageState extends State<NewItemPage> {
  final _formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var quantityController = TextEditingController(text: '1');
  var selectedCategory = categories[Categories.vegetables];

  void _saveItem() {
    if (_formKey.currentState!.validate()) {
      debugPrint('Save item:');
      debugPrint('Name: ${nameController.text}');
      debugPrint('Quantity: ${quantityController.text}');
      debugPrint('Category: ${selectedCategory!.name}');

      _formKey.currentState!.save();

      Navigator.of(context).pop(ItemModel(
          id: DateTime.now().millisecondsSinceEpoch,
          name: nameController.text,
          quantity: int.parse(quantityController.text),
          category: selectedCategory!));
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Grocery Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                    maxLength: 50,
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value.trim().length <= 1 ||
                          value.trim().length > 50) {
                        return 'Please enter a valid name between 2 and 50 characters';
                      }
                      return null;
                    }),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFormField(
                          maxLength: 3,
                          decoration:
                              const InputDecoration(labelText: 'Quantity'),
                          keyboardType: TextInputType.number,
                          controller: quantityController,
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                int.tryParse(value) == null ||
                                int.tryParse(value)! < 1) {
                              return 'Please enter a valid quantity greater than 0';
                            }
                            return null;
                          }),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: DropdownButtonFormField(
                          validator: (value) {
                            if (value == null) {
                              return 'Please select a category';
                            }
                            return null;
                          },
                          items: [
                            for (var category in categories.entries)
                              DropdownMenuItem(
                                value: category.value,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 16,
                                      height: 16,
                                      color: category.value.categoryColor,
                                    ),
                                    SizedBox(width: 8),
                                    Text(category.value.name),
                                  ],
                                ),
                              )
                          ],
                          onChanged: (value) {
                            setState(() {
                              selectedCategory = value as CategoryModel;
                            });
                          },
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        _formKey.currentState!.reset();
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.tertiary,
                        foregroundColor:
                            Theme.of(context).colorScheme.onTertiary,
                      ),
                      child: const Text('Reset'),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                      ),
                      onPressed: _saveItem,
                      child: const Text('Save'),
                    ),
                  ],
                )
              ],
            )),
      ),
    );
  }
}
