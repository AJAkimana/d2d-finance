import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'show_create_password_dialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    // GraphQL login mutation
    const String loginMutation = """
      mutation Login(\$email: String!, \$password: String!) {
        loginUser(email: \$email, password: \$password) {
          message
          token
          restToken
          user {
            id
            email
            firstName
            lastName
          }
        }
      }
    """;

    return Scaffold(
      backgroundColor: Colors.blue[50],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Login', style: TextStyle(fontSize: 28, color: Colors.blue[900], fontWeight: FontWeight.bold)),
                const SizedBox(height: 32),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email, color: Colors.blue[700]),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => value != null && value.contains('@') ? null : 'Enter a valid email',
                  onSaved: (value) => _email = value ?? '',
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock, color: Colors.blue[700]),
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) => value != null && value.length >= 6 ? null : 'Password too short',
                  onSaved: (value) => _password = value ?? '',
                ),
                const SizedBox(height: 32),
                Mutation(
                  options: MutationOptions(
                    document: gql(loginMutation),
                    onCompleted: (dynamic resultData) {
                      print('================>');
                      print(resultData);
                      if (resultData != null && resultData['loginUser'] != null) {
                        final token = resultData['loginUser']['token'];
                        final restToken = resultData['loginUser']['restToken'];
                        // TODO: Save token securely (e.g., using flutter_secure_storage)
                        print('Login successful! Token: $token, Rest Token: $restToken');
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Login successful!')),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Invalid credentials')),
                        );
                      }
                    },
                    // Inside your login mutation's onError callback:
                    onError: (error) {
                      print('=======>error');
                      print(error);
                      final errorMsg = error?.graphqlErrors.first.message ?? '';
                      if (errorMsg.contains('create a new password first')) {
                        showCreatePasswordDialog(context, (oldPwd, newPwd, confirmPwd) {
                          // Call your change password mutation here
                          // Example:
                          // runChangePasswordMutation({'oldPassword': oldPwd, 'newPassword1': newPwd, 'newPassword2': confirmPwd});
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: $errorMsg')),
                        );
                      }
                    }
                  ),
                  builder: (RunMutation runMutation, QueryResult? result) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[700],
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 48),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          print('Email: $_email, Password: $_password'); // For debugging
                          runMutation({'email': _email, 'password': _password});
                        }
                      },
                      child: const Text('Log In'),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}