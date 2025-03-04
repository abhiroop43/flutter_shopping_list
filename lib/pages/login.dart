import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shopping_list/common/utils.dart';
import 'package:shopping_list/models/login_state_model.dart';
import 'package:shopping_list/pages/home.dart';
import 'package:shopping_list/pages/register.dart';
import 'package:shopping_list/providers/login_provider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool formBeingSubmitted = false;
  late LoginStateModel loginStateModel;
  final storage = const FlutterSecureStorage();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    final errorSnackBar =
        showErrorSnackBar('Error: Incorrect email and/or password');

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      formBeingSubmitted = true;
    });

    debugPrint(
        'Submitting form with email: ${emailController.text} and password: ${passwordController.text}');

    bool loginSuccess = await ref
        .read(loginProvider.notifier)
        .loginUser(emailController.text, passwordController.text);

    if (!mounted) {
      return;
    }

    setState(() {
      formBeingSubmitted = false;
    });

    if (!loginSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(errorSnackBar);
      return;
    }

    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => HomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Login',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(16),
          child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(labelText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an email address';
                        }
                        return null;
                      }),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: formBeingSubmitted ? null : _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    ),
                    child: formBeingSubmitted
                        ? SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(),
                          )
                        : const Text('Login'),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => RegisterPage()));
                    },
                    child: Text('New user? Please register here.',
                        style: Theme.of(context).textTheme.bodyMedium),
                  )
                ],
              )),
        ));
  }
}
