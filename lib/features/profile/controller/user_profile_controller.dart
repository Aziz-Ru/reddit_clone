import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/enums/enums.dart';
import 'package:reddit/core/providers/supabase_storage_provider.dart';
import 'package:reddit/core/utils/show_snackbar.dart';
import 'package:reddit/features/auth/controller/auth_controller.dart';
import 'package:reddit/features/profile/repo/user_profile_repository.dart';
import 'package:reddit/model/post_model.dart';
import 'package:reddit/model/user_model.dart';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';

final userProfileControllerProvider =
    StateNotifierProvider<UserProfileController, bool>((ref) {
  return UserProfileController(
      userProfileRepository: ref.watch(userProfileProvider),
      ref: ref,
      supabaseStorageRepository: ref.watch(supabaseStorageRepositoryProvider));
});

final getUserPostsProvider = StreamProvider.family((ref, String uid) {
  return ref.read(userProfileControllerProvider.notifier).getUserPosts(uid);
});

class UserProfileController extends StateNotifier<bool> {
  final UserProfileRepository _userProfileRepository;
  final SupabaseStorageRepository _supabaseStorageRepository;
  final Ref _ref;
  final uuid = const Uuid();

  UserProfileController(
      {required UserProfileRepository userProfileRepository,
      required Ref ref,
      required SupabaseStorageRepository supabaseStorageRepository})
      : _userProfileRepository = userProfileRepository,
        _ref = ref,
        _supabaseStorageRepository = supabaseStorageRepository,
        super(false);

  void editProfile(
      {required File? avatarImage,
      required File? bannerImage,
      required String name,
      required BuildContext context}) async {
    state = true;
    UserModel user = _ref.read(userProvider)!;

    final bannerUid = 'users/${uuid.v1()}_banner';
    final avatarUid = 'users/${uuid.v1()}_avatar';

    if (bannerImage != null) {
      final imageUploadResponse = await _supabaseStorageRepository.uploadImage(
          image: bannerImage, id: bannerUid);

      imageUploadResponse.fold((l) => showSnackBar(context, l.message),
          (r) => user = user.copyWith(banner: r));
    }

    if (avatarImage != null) {
      final imageUploadResponse = await _supabaseStorageRepository.uploadImage(
          image: avatarImage, id: avatarUid);

      imageUploadResponse.fold((l) => showSnackBar(context, l.message),
          (r) => user = user.copyWith(profilePic: r));
    }

    user = user.copyWith(name: name);

    final response = await _userProfileRepository.editProfile(user);
    state = false;

    response.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'Profile update successfully');
      _ref.read(userProvider.notifier).update((state) => user);
      Routemaster.of(context).pop();
    });
  }

  Stream<List<Post>> getUserPosts(String uid) {
    return _userProfileRepository.getUserPosts(uid);
  }

  void updateUserKarma(UserKarma karma) async {
    UserModel user = _ref.read(userProvider)!;
    user = user.copyWith(karma: user.karma + karma.karma);
    final response = await _userProfileRepository.updateUserKarma(user);
    response.fold((l) => null, (r) {
      _ref.read(userProvider.notifier).update((state) => user);
    });
  }
}
