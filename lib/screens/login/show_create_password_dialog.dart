import 'package:d2d_finance/core/graphql/mutations/auth.dart';
import 'package:d2d_finance/widgets/notifier.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

Future<void> showCreatePasswordDialog(
    BuildContext context,
    String email,
    void Function(String newPassword) onPasswordResetSuccess,
    ) {
  final oldPwdController = TextEditingController();
  final newPwdController = TextEditingController();
  final confirmPwdController = TextEditingController();

  return showDialog(
    context: context,
    builder: (context) {
      bool isLoading = false;

      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Create New Password'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: oldPwdController,
                  decoration: const InputDecoration(labelText: 'Old Password'),
                  obscureText: true,
                ),
                TextField(
                  controller: newPwdController,
                  decoration: const InputDecoration(labelText: 'New Password'),
                  obscureText: true,
                ),
                TextField(
                  controller: confirmPwdController,
                  decoration: const InputDecoration(labelText: 'Confirm Password'),
                  obscureText: true,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: isLoading ? null : () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () async {
                  final oldPwd = oldPwdController.text;
                  final newPwd = newPwdController.text;
                  final confirmPwd = confirmPwdController.text;

                  if (newPwd != confirmPwd) {
                    Notifier.showError(context, 'Passwords do not match');
                    return;
                  }
                  setState(() => isLoading = true);

                  final client = GraphQLProvider.of(context).value;
                  final result = await client.mutate(MutationOptions(
                    document: gql(RESET_PASSWORD_MUTATION),
                    variables: {
                      'oldPassword': oldPwd,
                      'newPassword': newPwd,
                      'email': email,
                    },
                  ));

                  setState(() => isLoading = false);

                  if (result.hasException) {
                    Notifier.showError(
                      context,
                      result.exception!.graphqlErrors.isNotEmpty
                          ? result.exception!.graphqlErrors.first.message
                          : 'Password reset failed',
                    );
                    return;
                  }

                  final data = result.data?['resetPassword'];
                  if (data != null) {
                    Notifier.showSuccess(context, 'Password changed! Logging in...');
                    Navigator.of(context).pop();
                    onPasswordResetSuccess(newPwd);
                  } else {
                    Notifier.showError(context, 'Password reset failed');
                  }
                },
                child: isLoading
                    ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                    : const Text('Reset Password'),
              ),
            ],
          );
        },
      );
    },
  );
}