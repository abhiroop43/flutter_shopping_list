import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_list/models/login_state_model.dart';

class LoginNotifier extends StateNotifier<LoginStateModel> {
  final storage = const FlutterSecureStorage();

  LoginNotifier()
      : super(LoginStateModel(
            localId: '',
            email: '',
            displayName: '',
            idToken: '',
            registered: false,
            refreshToken: '',
            expiresIn: '',
            isLoggedIn: false));

  Future<LoginStateModel> checkUserLoginStatus() async {
    var token = await storage.read(key: 'token');
    var expiryTimeString = await storage.read(key: 'expiryTime');

    if (expiryTimeString != null && expiryTimeString.isNotEmpty) {
      var expiryTime = DateTime.parse(expiryTimeString);

      if (expiryTime.isAfter(DateTime.now()) &&
          token != null &&
          token.isNotEmpty) {
        state = LoginStateModel(
            localId: '',
            email: '',
            displayName: '',
            idToken: token,
            registered: false,
            refreshToken: '',
            expiresIn: '',
            isLoggedIn: true);
      }
    }
    return state;
  }

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

      debugPrint(response.statusCode.toString());
      debugPrint(response.body);

      if (response.statusCode != 200) {
        throw Exception('Failed to log in');
      }

      var decodedResponse = json.decode(response.body) as Map<String, dynamic>?;

      if (decodedResponse == null) {
        throw Exception('Failed to log in');
      }

      state = LoginStateModel(
          localId: decodedResponse['localId'],
          email: decodedResponse['email'],
          displayName: decodedResponse['displayName'],
          idToken: decodedResponse['idToken'],
          registered: decodedResponse['registered'],
          refreshToken: decodedResponse['refreshToken'],
          expiresIn: decodedResponse['expiresIn'],
          isLoggedIn: true);

      final expiryTime =
          DateTime.now().add(Duration(seconds: int.parse(state.expiresIn)));

      await storage.write(key: 'token', value: state.idToken);
      await storage.write(
          key: 'expiryTime', value: expiryTime.toIso8601String());
    } catch (error) {
      debugPrint(error.toString());
      state = LoginStateModel(
          localId: '',
          email: '',
          displayName: '',
          idToken: '',
          registered: false,
          refreshToken: '',
          expiresIn: '',
          isLoggedIn: false);
    }
  }

  void logoutUser() {
    // Logout logic here
    state = LoginStateModel(
        localId: '',
        email: '',
        displayName: '',
        idToken: '',
        registered: false,
        refreshToken: '',
        expiresIn: '',
        isLoggedIn: false);
  }
}

final loginProvider = StateNotifierProvider<LoginNotifier, LoginStateModel>(
    (ref) => LoginNotifier());
