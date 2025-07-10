import 'package:d2d_finance/core/graphql/mutations/auth.dart';
import 'package:d2d_finance/services/storage_service.dart';
import 'package:d2d_finance/widgets/notifier.dart';
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
  bool _isLoading = false;
  late RunMutation _loginMutation;

  @override
  Widget build(BuildContext context) {

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
                Text('Login',
                    style: TextStyle(
                        fontSize: 28,
                        color: Colors.blue[900],
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 32),
                TextFormField(
                  initialValue: _email,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email, color: Colors.blue[700]),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => value != null && value.contains('@')
                      ? null
                      : 'Enter a valid email',
                  onSaved: (value) => _email = value ?? '',
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: _password,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock, color: Colors.blue[700]),
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) => value != null && value.length >= 6
                      ? null
                      : 'Password too short',
                  onSaved: (value) => _password = value ?? '',
                ),
                const SizedBox(height: 32),
                Mutation(
                  options: MutationOptions(
                      document: gql(LOGIN_MUTATION),
                      onCompleted: (dynamic resultData) {
                        setState(() => _isLoading = false);
                        if (resultData != null &&
                            resultData['loginUser'] != null) {
                          final token = resultData['loginUser']['token'];
                          // final restToken =
                          //     resultData['loginUser']['restToken'];
                          Notifier.showSuccess(context, 'Login successful!');
                          // Save token securely here
                          StorageService.save('auth_token', token);
                        }
                      },
                      onError: (error) {
                        setState(() => _isLoading = false);
                        final errorMsg =
                            error?.graphqlErrors.first.message ?? '';
                        if (errorMsg.contains('Create a new password first')) {
                          showCreatePasswordDialog(
                            context,
                            _email,
                            (newPwd) {
                              setState(() {
                                _password = newPwd;
                                _isLoading = true;
                              });
                              _loginMutation({'email': _email, 'password': newPwd});
                            },
                          );
                        } else {
                          Notifier.showError(context,
                              errorMsg.isNotEmpty ? errorMsg : 'Login failed');
                        }
                      }),
                  builder: (RunMutation runMutation, QueryResult? result) {
                    _loginMutation = runMutation;

                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[700],
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 48),
                      ),
                      onPressed: _isLoading
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                setState(() => _isLoading = true);
                                _loginMutation(
                                    {'email': _email, 'password': _password});
                              }
                            },
                      child: _isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text('Log In'),
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
