import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopping_list/models/login_state_model.dart';
import 'package:shopping_list/pages/home.dart';
import 'package:shopping_list/pages/login.dart';
import 'package:shopping_list/providers/login_provider.dart';

class RootPage extends ConsumerStatefulWidget {
  const RootPage({super.key});

  @override
  ConsumerState<RootPage> createState() => _RootPageState();
}

class _RootPageState extends ConsumerState<RootPage> {
  @override
  Widget build(BuildContext context) {
    LoginStateModel loginStateModel = ref.watch(loginProvider);

    if (loginStateModel.isLoggedIn) {
      return HomePage();
    }
    return LoginPage();
  }
}
