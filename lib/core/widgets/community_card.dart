import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/themes/colors.dart';
import 'package:reddit/features/community/controller/community_controller.dart';
import 'package:reddit/model/community_model.dart';
import 'package:reddit/model/user_model.dart';
import 'package:routemaster/routemaster.dart';

class CommunityCard extends StatelessWidget {
  final Community community;
  final WidgetRef ref;
  final UserModel user;
  const CommunityCard(
      {super.key,
      required this.community,
      required this.ref,
      required this.user});

  void navigateToModTools(BuildContext context, String communityname) {
    Routemaster.of(context).push('/mod-tools/$communityname');
  }

  void joinOrLeaveCommunity(
      WidgetRef ref, BuildContext context, Community community) {
    ref.read(communityProvider.notifier).joinCommunity(community, context);
  }

  void navigateToCommunity(BuildContext context, String name) {
    Routemaster.of(context).push('/community/$name');
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () => navigateToCommunity(context, community.name),
          child: Card(
            shape: RoundedRectangleBorder(
                side: const BorderSide(color: AppColors.borderColor, width: 1),
                borderRadius: BorderRadius.circular(8)),
            color: AppColors.backgroundColor,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(community.avatar),
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                community.name,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '${community.members.length} members',
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(softWrap: true, community.description),
                ],
              ),
            ),
          ),
        ),
        Positioned(
            right: 10,
            child: community.mods.contains(user.uid)
                ? OutlinedButton(
                    onPressed: () =>
                        navigateToModTools(context, community.name),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    child: const Text('Mod Tools'))
                : OutlinedButton(
                    onPressed: () =>
                        joinOrLeaveCommunity(ref, context, community),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    child: Text(community.members.contains(user.uid)
                        ? 'Leave'
                        : 'Join')))
      ],
    );
  }
}
