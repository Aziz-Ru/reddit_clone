import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit/core/constants/constants.dart';
import 'package:reddit/core/error/failure.dart';
import 'package:reddit/core/providers/supabase_storage_provider.dart';
import 'package:reddit/core/utils/show_snackbar.dart';
import 'package:reddit/features/auth/controller/auth_controller.dart';
import 'package:reddit/features/community/repo/community_repository.dart';
import 'package:reddit/model/community_model.dart';
import 'package:routemaster/routemaster.dart';

final communityProvider =
    StateNotifierProvider<CommunityController, bool>((ref) {
  return CommunityController(
      communityRepository: ref.watch(communityRepositoryProvider),
      ref: ref,
      supabaseStorageRepository: ref.watch(supabaseStorageRepositoryProvider));
});

final userCommunityProvider = StreamProvider((ref) {
  final controller = ref.watch(communityProvider.notifier);

  return controller.getUserCommunity();
});

final getCommunityByNameProvider = StreamProvider.family((ref, String name) {
  final controller = ref.watch(communityProvider.notifier);

  return controller.getCommunityByName(name);
});

final searchCommunityProvider = StreamProvider.family((ref, String q) {
  final controller = ref.watch(communityProvider.notifier);
  return controller.searchCommunity(q);
});

class CommunityController extends StateNotifier<bool> {
  final CommunityRepository _communityRepository;
  final SupabaseStorageRepository _supabaseStorageRepository;
  final Ref _ref;
  CommunityController(
      {required CommunityRepository communityRepository,
      required Ref ref,
      required SupabaseStorageRepository supabaseStorageRepository})
      : _communityRepository = communityRepository,
        _ref = ref,
        _supabaseStorageRepository = supabaseStorageRepository,
        super(false);

  Future<void> createCommunity(
      String name, String description, BuildContext context) async {
    state = true;
    final uid = _ref.read(userProvider)?.uid ?? '';

    final community = Community(
      avatar: Constants.avatarDefault,
      banner: Constants.bannerDefault,
      name: name,
      description: description,
      id: name,
      members: [uid],
      mods: [uid],
    );

    final response = await _communityRepository.createCommunity(community);
    state = false;
    response.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'Community created successfully');
      Routemaster.of(context).pop();
    });
  }

  Stream<List<Community>> getUserCommunity() {
    final uid = _ref.read(userProvider)!.uid;
    return _communityRepository.getUserCommunity(uid);
  }

  Stream<Community> getCommunityByName(String name) {
    return _communityRepository.getCommunityByName(name);
  }

  void editCommunity(
      {required File? avatarImage,
      required File? bannerImage,
      required Community community,
      required BuildContext context}) async {
    state = true;
    final bannerUid = '${community.id}_banner';
    final avatarUid = '${community.id}_avatar';
    if (bannerImage != null) {
      final imageUploadResponse = await _supabaseStorageRepository.uploadImage(
          image: bannerImage, id: bannerUid);
      imageUploadResponse.fold((l) => showSnackBar(context, l.message),
          (r) => community = community.copyWith(banner: r));
    }
    if (avatarImage != null) {
      final imageUploadResponse = await _supabaseStorageRepository.uploadImage(
          image: avatarImage, id: avatarUid);
      imageUploadResponse.fold((l) => showSnackBar(context, l.message),
          (r) => community = community.copyWith(avatar: r));
    }

    final response = await _communityRepository.editCommunity(community);
    state = false;

    response.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'Community update successfully');
      Routemaster.of(context).pop();
    });
  }

  Stream<List<Community>> searchCommunity(String query) {
    return _communityRepository.searchCommunites(query);
  }

  void joinCommunity(Community community, BuildContext context) async {
    final user = _ref.read(userProvider)!;
    Either<Failure, void> response;
    if (community.members.contains(user.uid)) {
      response =
          await _communityRepository.leaveCommunity(community.name, user.uid);
    } else {
      response =
          await _communityRepository.joinCommunity(community.name, user.uid);
    }
    response.fold((l) => showSnackBar(context, l.message), (r) {
      if (community.members.contains(user.uid)) {
        showSnackBar(context, 'Community left successfully');
        return;
      } else {
        showSnackBar(context, 'Community joined successfully');
      }
    });
  }

  void addMods(
      String communityName, List<String> uids, BuildContext context) async {
    final response = await _communityRepository.addMods(uids, communityName);
    response.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'Mods added successfully');
      Routemaster.of(context).pop();
    });
  }
}
