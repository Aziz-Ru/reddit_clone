import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/constants/constants.dart';
import 'package:reddit/features/auth/controller/auth_controller.dart';

class SignInButton extends ConsumerWidget {
  const SignInButton({super.key});
  // that gives us access to the AuthController

  void signInWithGoogle(WidgetRef ref, BuildContext context) {
    // _authRepository.signInwithGoogle();

    ref.watch(authControllProvider.notifier).signInWithGoogle(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton.icon(
        onPressed: () => signInWithGoogle(ref, context),
        icon: Image.asset(
          Constants.googlePath,
          height: 40,
        ),
        label: const Text(
          'Continue with Google',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
            side: const BorderSide(color: Colors.grey, width: 1.1),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            minimumSize: const Size(double.infinity, 55),
            backgroundColor: Colors.transparent),
      ),
    );
  }
}
