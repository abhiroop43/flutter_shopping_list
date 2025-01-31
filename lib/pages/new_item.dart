import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_list/common/utils.dart';
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/category_model.dart';
import 'package:shopping_list/models/item_model.dart';
import 'package:shopping_list/providers/login_provider.dart';

class NewItemPage extends ConsumerStatefulWidget {
  const NewItemPage({super.key});

  @override
  ConsumerState<NewItemPage> createState() => _NewItemPageState();
}

class _NewItemPageState extends ConsumerState<NewItemPage> {
  final _formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var quantityController = TextEditingController(text: '1');
  var selectedCategory = categories[Categories.vegetables];
  bool isBeingAdded = false;
  final storage = const FlutterSecureStorage();

  void _saveItem() async {
    final errorMessageSnackBar = showErrorSnackBar('Error saving item.');

    if (_formKey.currentState!.validate()) {
      // debugPrint('Save item:');
      // debugPrint('Name: ${nameController.text}');
      // debugPrint('Quantity: ${quantityController.text}');
      // debugPrint('Category: ${selectedCategory!.name}');

      final loginStateModel =
          await ref.read(loginProvider.notifier).checkUserLoginStatus();

      final idToken = loginStateModel.idToken;
      final localId = loginStateModel.localId;

      if (idToken.isEmpty) {
        return;
      }

      final tokenExpiry = await storage.read(key: 'expiryTime');

      if (tokenExpiry == null || tokenExpiry.isEmpty) {
        return;
      }

      var expiryTime = DateTime.parse(tokenExpiry);
      if (expiryTime.isBefore(DateTime.now())) {
        return;
      }
      _formKey.currentState!.save();

      setState(() {
        isBeingAdded = true;
      });

      var url = Uri.parse(
          'https://${dotenv.env['BASEURL']!}/shoppingList/$localId.json?auth=$idToken');

      try {
        var response = await http.post(url,
            headers: {
              'Content-Type': 'application/json',
            },
            body: json.encode({
              'name': nameController.text,
              'quantity': int.parse(quantityController.text),
              'category': selectedCategory?.name,
            }));

        // debugPrint('Response: ${response.statusCode} : ${response.body}');

        if (response.statusCode >= 400) {
          debugPrint('Error saving item');
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(errorMessageSnackBar);
          }
          setState(() {
            isBeingAdded = false;
          });
          return;
        } else {
          debugPrint('Item saved');
        }

        if (!mounted) return;

        setState(() {
          isBeingAdded = false;
        });

        final Map<String, dynamic> itemId = json.decode(response.body);
        Navigator.of(context).pop(ItemModel(
            id: itemId['name'],
            name: nameController.text,
            quantity: int.parse(quantityController.text),
            category: selectedCategory!));
      } catch (error) {
        debugPrint('Error saving item: ${error.toString()}');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(errorMessageSnackBar);
        }

        setState(() {
          isBeingAdded = false;
        });
      }
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
                      onPressed: isBeingAdded
                          ? null
                          : () {
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
                      onPressed: isBeingAdded ? null : _saveItem,
                      child: isBeingAdded
                          ? SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(),
                            )
                          : const Text('Save'),
                    ),
                  ],
                )
              ],
            )),
      ),
    );
  }
}
