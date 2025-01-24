import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class LoginNotifier extends StateNotifier<bool> {
  LoginNotifier() : super(false);

  void loginUser(String email, String password) async {
    var authUrl =
        Uri.parse('https://${dotenv.env['AUTHURL']!}${dotenv.env['APIKEY']!}');

    try {
      var response = await http.post(authUrl,
          body: jsonEncode({
            'email': email,
            'password': password,
            'returnSecureToken': 'true',
          }),
          headers: {'Content-Type': 'application/json'});

      //debugPrint(response.statusCode.toString());
      //debugPrint(response.body);

      if (response.statusCode != 200) {
        debugPrint('Failed to login');
        state = false;
        return;
      }

      state = true;
    } catch (error) {
      state = false;
      debugPrint(error.toString());
    }
  }

  void logoutUser() {
    // Logout logic here
    state = false;
  }
}

final loginProvider =
    StateNotifierProvider<LoginNotifier, bool>((ref) => LoginNotifier());
