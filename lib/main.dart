import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopping_list/pages/home.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const ProviderScope(child: ShoppingListApp()));
}

class ShoppingListApp extends StatelessWidget {
  const ShoppingListApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping List',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 147, 229, 250),
            brightness: Brightness.dark,
            surface: const Color.fromARGB(255, 42, 51, 59)),
        scaffoldBackgroundColor: const Color.fromARGB(255, 50, 28, 60),
      ),
      home: const HomePage(),
    );
  }
}
