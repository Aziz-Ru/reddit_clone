import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/utils/show_snackbar.dart';
import 'package:reddit/features/auth/repo/auth_repo.dart';

final authControllProvider = Provider(
    (ref) => AuthController(authRepository: ref.read(authRepositoryProvider)));

class AuthController {
  final AuthRepository _authRepository;

  AuthController({required AuthRepository authRepository})
      : _authRepository = authRepository;

  void signInWithGoogle(BuildContext context) async {
    final data = await _authRepository.signInwithGoogle();
    data.fold(
      (l) => showSnackBar(context, l.message),
     (r) => null);
  }
}
