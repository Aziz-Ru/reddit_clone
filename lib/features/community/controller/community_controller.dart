import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/constants/constants.dart';
import 'package:reddit/core/utils/show_snackbar.dart';
import 'package:reddit/features/auth/controller/auth_controller.dart';
import 'package:reddit/features/community/repo/community_repository.dart';
import 'package:reddit/model/community_model.dart';
import 'package:routemaster/routemaster.dart';

final communityProvider =
    StateNotifierProvider<CommunityController, bool>((ref) {
  return CommunityController(
      communityRepository: ref.watch(communityRepositoryProvider), ref: ref);
});

final userCommunityProvider = StreamProvider((ref) {
  final controller = ref.watch(communityProvider.notifier);

  return controller.getUserCommunity();
});

final getCommunityByNameProvider = StreamProvider.family((ref, String name) {
  final controller = ref.watch(communityProvider.notifier);

  return controller.getCommunityByName(name);
});


class CommunityController extends StateNotifier<bool> {
  final CommunityRepository _communityRepository;
  final Ref _ref;
  CommunityController(
      {required CommunityRepository communityRepository, required Ref ref})
      : _communityRepository = communityRepository,
        _ref = ref,
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
}
