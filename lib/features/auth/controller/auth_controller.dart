import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/utils/show_snackbar.dart';
import 'package:reddit/features/auth/repo/auth_repo.dart';
import 'package:reddit/model/user_model.dart';

final userProvider = StateProvider<UserModel?>((ref) => null);

final authControllProvider = StateNotifierProvider<AuthController, bool>(
  (ref) => AuthController(
      authRepository: ref.watch(
        authRepositoryProvider,
      ),
      ref: ref),
);

final authStateChangesProvider = StreamProvider<User?>((ref) {
  final authController = ref.watch(authControllProvider.notifier);
  return authController.authStateChanges;
});

final getUserDataProvider=StreamProvider.family((ref,String uid){
  final authController=ref.watch(authControllProvider.notifier);
  return authController.getUserData(uid);
});

class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;
  final Ref _ref;
  AuthController({required AuthRepository authRepository, required Ref ref})
      : _authRepository = authRepository,
        _ref = ref,
        super(false);

  Stream<User?> get authStateChanges => _authRepository.authStateChanges;

  void signInWithGoogle(BuildContext context) async {
    state = true;
    final data = await _authRepository.signInwithGoogle();
    state = false;
    data.fold((l) => showSnackBar(context, l.message),
        (r) => _ref.read(userProvider.notifier).update((state) => r));
  }
  Stream<UserModel> getUserData(String uid) {
    return _authRepository.getUserData(uid);
  }
}
