import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/error/error_text.dart';
import 'package:reddit/core/widgets/loader.dart';
import 'package:reddit/features/community/controller/community_controller.dart';
import 'package:routemaster/routemaster.dart';

class CommunityListDrawer extends ConsumerWidget {
  const CommunityListDrawer({super.key});

  void navigateToCreateCommunity(BuildContext context) {
    Routemaster.of(context).push('/add-community');
  }

  void navigateToCommunity(BuildContext context, String name) {
    Routemaster.of(context).push('/community/$name');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: SafeArea(
          child: Column(
        children: [
          ListTile(
            title: const Text("Create Community"),
            leading: const Icon(Icons.add),
            onTap: () => navigateToCreateCommunity(context),
          ),
          ref.watch(userCommunityProvider).when(
              data: (communities) => Expanded(
                    child: ListView.builder(
                      itemCount: communities.length,
                      itemBuilder: (context, index) {
                        final community = communities[index];

                        return ListTile(
                          title: Text("c/${community.name}"),
                          leading: CircleAvatar(
                            backgroundImage:
                                CachedNetworkImageProvider(community.avatar),
                          ),
                          onTap: () =>
                              navigateToCommunity(context, community.name),
                        );
                      },
                    ),
                  ),
              error: (error, stackRace) => ErrorText(text: error.toString()),
              loading: () => const Loader())
        ],
      )),
    );
  }
}
