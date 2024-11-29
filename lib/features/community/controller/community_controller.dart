import 'dart:developer';
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
import 'package:reddit/model/post_model.dart';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';

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

final getCommunitPostProvider = StreamProvider.family((ref, String name) {
  return ref.read(communityProvider.notifier).getCommunityPosts(name);
});

final getAllCommunitiesProvider = StreamProvider((ref) {
  return ref.read(communityProvider.notifier).getAllCommunities();
});

final getCommunityByTopicProvider = StreamProvider.family((ref, String topic) {
  return ref.read(communityProvider.notifier).getCommunityByTopic(topic);
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

  Future<void> createCommunity({
    required String name,
    required String description,
    required List<String> topics,
    required File? bannerImage,
    required File? avatarImage,
    required BuildContext context,
  }) async {
    state = true;
    final uid = _ref.read(userProvider)?.uid ?? '';

    Community community = Community(
      avatar: Constants.avatarDefault,
      banner: Constants.bannerDefault,
      name: name,
      description: description,
      id: name,
      members: [uid],
      mods: [uid],
      topics: topics,
    );

    const uuid = Uuid();
    final bannerUid = 'banner/${community.id}_${uuid.v1()}';
    final avatarUid = 'avatar/${community.id}_${uuid.v1()}';

    if (bannerImage != null) {
      final imageUploadResponse = await _supabaseStorageRepository.uploadImage(
          image: bannerImage, id: bannerUid);
      imageUploadResponse.fold((l) => showSnackBar(context, l.message), (r) {
        community = community.copyWith(banner: r);
      });
    }
    if (avatarImage != null) {
      final imageUploadResponse = await _supabaseStorageRepository.uploadImage(
          image: avatarImage, id: avatarUid);

      imageUploadResponse.fold((l) => showSnackBar(context, l.message), (r) {
        community = community.copyWith(avatar: r);
      });
    }

    final response = await _communityRepository.createCommunity(community);
    state = false;
    response.fold((l) {
      log(l.message);
      showSnackBar(context, l.message);
    }, (r) {
      showSnackBar(context, 'Community created successfully');
      Routemaster.of(context).push('/');
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
    const uuid = Uuid();
    final bannerUid = '${community.id}${uuid.v1()}_banner';
    final avatarUid = '${community.id}${uuid.v1()}_avatar';
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

  Stream<List<Post>> getCommunityPosts(String name) {
    return _communityRepository.getCommunityPosts(name);
  }

  Stream<List<Community>> getAllCommunities() {
    return _communityRepository.getCommunities();
  }

  void isCommunityExist(
      String name, String description, BuildContext context) async {
    final res = await _communityRepository.isCommunityExist(name);

    res.fold((l) {
      showSnackBar(context, l.message);
    }, (r) {
      Routemaster.of(context)
          .push('/style-community?name=$name&description=$description');
    });
  }

  Stream<List<Community>> getCommunityByTopic(String topic) {
    return _communityRepository.getCommunitiesByTopic(topic);
  }
}
