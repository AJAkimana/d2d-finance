import 'package:flutter/material.dart';

Future<void> showCreatePasswordDialog(BuildContext context, Function(String, String, String) onSubmit) async {
  final formKey = GlobalKey<FormState>();
  String oldPassword = '';
  String newPassword = '';
  String confirmPassword = '';

  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Create New Password'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Old Password'),
                obscureText: true,
                onSaved: (v) => oldPassword = v ?? '',
                validator: (v) => (v == null || v.isEmpty) ? 'Enter old password' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'New Password'),
                obscureText: true,
                onSaved: (v) => newPassword = v ?? '',
                validator: (v) => (v == null || v.length < 6) ? 'Min 6 chars' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Confirm Password'),
                obscureText: true,
                onSaved: (v) => confirmPassword = v ?? '',
                validator: (v) => (v == null || v != newPassword) ? 'Passwords do not match' : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                formKey.currentState!.save();
                onSubmit(oldPassword, newPassword, confirmPassword);
                Navigator.of(context).pop();
              }
            },
            child: const Text('Submit'),
          ),
        ],
      );
    },
  );
}