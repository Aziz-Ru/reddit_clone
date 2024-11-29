import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/error/error_text.dart';
import 'package:reddit/core/utils/community_members.dart';
import 'package:reddit/core/widgets/loader.dart';
import 'package:reddit/core/widgets/post_card.dart';
import 'package:reddit/features/auth/controller/auth_controller.dart';
import 'package:reddit/features/community/controller/community_controller.dart';
import 'package:reddit/model/community_model.dart';
import 'package:routemaster/routemaster.dart';

class CommunityDetailsScreen extends ConsumerWidget {
  final String communityname;
  const CommunityDetailsScreen({super.key, required this.communityname});
  void navigateToModTools(BuildContext context) {
    Routemaster.of(context).push('/mod-tools/$communityname');
  }

  void joinOrLeaveCommunity(
      WidgetRef ref, BuildContext context, Community community) {
    ref.read(communityProvider.notifier).joinCommunity(community, context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;

    return Scaffold(
      body: ref.watch(getCommunityByNameProvider(communityname)).when(
          data: (community) {
            return NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
                      expandedHeight: 100,
                      floating: true,
                      snap: true,
                      flexibleSpace: Stack(
                        children: [
                          Positioned.fill(
                              child: Image.network(
                            community.banner,
                            fit: BoxFit.cover,
                          )),
                        ],
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.all(16),
                      sliver: SliverList(
                          delegate: SliverChildListDelegate([
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(community.avatar),
                            ),
                            Column(
                              children: [
                                Text(
                                  'c/${community.name}',
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  '${isMemberGreaterThanK(community.members.length) ? community.members.length / 1000 : community.members.length}${isMemberGreaterThanK(community.members.length) ? 'K' : ""} members',
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.grey),
                                )
                              ],
                            ),
                            if (!isGuest)
                              community.mods.contains(user.uid)
                                  ? OutlinedButton(
                                      onPressed: () =>
                                          navigateToModTools(context),
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                      ),
                                      child: const Text('Mod Tools'))
                                  : OutlinedButton(
                                      onPressed: () => joinOrLeaveCommunity(
                                          ref, context, community),
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                      ),
                                      child: Text(
                                          community.members.contains(user.uid)
                                              ? 'Leave'
                                              : 'Join'))
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          community.description,
                          style:
                              const TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ])),
                    )
                  ];
                },
                body: ref.watch(getCommunitPostProvider(communityname)).when(
                    data: (posts) {
                      if (posts.isEmpty) {
                        return const Center(
                          child: Text('No posts yet'),
                        );
                      }
                      return ListView.builder(
                          itemCount: posts.length,
                          itemBuilder: (context, index) {
                            return PostCard(
                              post: posts[index],
                            );
                          });
                    },
                    error: (error, stackTrace) => ErrorText(
                          text: error.toString(),
                        ),
                    loading: () => const Loader()));
          },
          error: (error, stackTrace) => ErrorText(text: error.toString()),
          loading: () => const Loader()),
    );
  }
}
