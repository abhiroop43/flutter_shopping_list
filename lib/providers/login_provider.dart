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
        return state;
      }
    }
    return state = LoginStateModel(
        localId: '',
        email: '',
        displayName: '',
        idToken: '',
        registered: false,
        refreshToken: '',
        expiresIn: '',
        isLoggedIn: true);
  }

  Future<bool> loginUser(String email, String password) async {
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
        debugPrint(
            'Failed to log in. ${response.statusCode}: ${response.body}.');
        // throw Exception('Failed to log in.');
        return false;
      }

      var decodedResponse = json.decode(response.body) as Map<String, dynamic>?;

      if (decodedResponse == null) {
        debugPrint(
            'Failed to log in. ${response.statusCode}: ${response.body}.');
        // throw Exception('Failed to log in.');
        return false;
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
      await storage.write(key: 'refreshToken', value: state.refreshToken);
      await storage.write(key: 'localId', value: state.localId);

      return true;
    } catch (e) {
      debugPrint('Error logging in: $e');
      return false;
    }
  }

  Future<bool> registerUser(String email, String password) async {
    var registerUrl = Uri.parse(
        'https://${dotenv.env['REGISTERURL']!}${dotenv.env['APIKEY']!}');

    try {
      var response = await http.post(registerUrl,
          body: jsonEncode({
            'email': email,
            'password': password,
            'returnSecureToken': 'true',
          }),
          headers: {'Content-Type': 'application/json'});

      debugPrint(response.statusCode.toString());
      debugPrint(response.body);

      if (response.statusCode != 200) {
        debugPrint(
            'Failed to register user. ${response.statusCode}: ${response.body}.');
        // throw Exception('Failed to log in.');
        return false;
      }

      var decodedResponse = json.decode(response.body) as Map<String, dynamic>?;

      if (decodedResponse == null) {
        debugPrint(
            'Failed to register user. ${response.statusCode}: ${response.body}.');
        // throw Exception('Failed to log in.');
        return false;
      }

      state = LoginStateModel(
          localId: decodedResponse['localId'],
          email: decodedResponse['email'],
          displayName: decodedResponse['displayName'] ?? "",
          idToken: decodedResponse['idToken'],
          registered: true,
          refreshToken: decodedResponse['refreshToken'],
          expiresIn: decodedResponse['expiresIn'],
          isLoggedIn: true);

      final expiryTime =
          DateTime.now().add(Duration(seconds: int.parse(state.expiresIn)));

      await storage.write(key: 'token', value: state.idToken);
      await storage.write(
          key: 'expiryTime', value: expiryTime.toIso8601String());
      await storage.write(key: 'refreshToken', value: state.refreshToken);
      await storage.write(key: 'localId', value: state.localId);

      return true;
    } catch (e) {
      debugPrint('Error registering user: $e');
      return false;
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
