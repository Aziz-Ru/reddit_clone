import 'package:any_link_preview/any_link_preview.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/constants/constants.dart';
import 'package:reddit/core/error/error_text.dart';
import 'package:reddit/core/themes/colors.dart';
import 'package:reddit/core/widgets/loader.dart';
import 'package:reddit/features/auth/controller/auth_controller.dart';
import 'package:reddit/features/community/controller/community_controller.dart';
import 'package:reddit/features/posts/controller/post_controller.dart';
import 'package:reddit/model/post_model.dart';
import 'package:routemaster/routemaster.dart';

class PostCard extends ConsumerWidget {
  final Post post;
  const PostCard({
    super.key,
    required this.post,
  });

  void deletePost(WidgetRef ref, BuildContext context) async {
    ref.read(postControllerProvider.notifier).deletePost(post, context);
  }

  void upvotePost(WidgetRef ref) async {
    ref.read(postControllerProvider.notifier).upvote(post);
  }

  void downvotePost(WidgetRef ref) async {
    ref.read(postControllerProvider.notifier).downvote(post);
  }

  void awardPost(WidgetRef ref, String award, BuildContext context) async {
    ref
        .read(postControllerProvider.notifier)
        .awardPost(post: post, award: award, context: context);
  }

  void navigateToUser(BuildContext context) {
    Routemaster.of(context).push('/u/${post.uid}');
  }

  void navigateToCommunity(BuildContext context) {
    Routemaster.of(context).push('/community/${post.communityName}');
  }

  void navigateToComments(BuildContext context) {
    Routemaster.of(context).push('/post/${post.id}/comments');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTypeImage = post.type == 'image';
    final isTypeText = post.type == 'text';
    final isTypeLink = post.type == 'link';
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;

    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: AppColors.backgroundColor,
            border: Border(
              bottom: BorderSide(
                color: AppColors.borderColor,
              ),
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 16,
                      ).copyWith(right: 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () => navigateToCommunity(context),
                                    child: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                        post.communityProfilePic,
                                      ),
                                      radius: 16,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'c/${post.communityName}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () => navigateToUser(context),
                                          child: Text(
                                            'u/${post.username}',
                                            style:
                                                const TextStyle(fontSize: 12),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              if (post.uid == user.uid)
                                IconButton(
                                  onPressed: () => deletePost(ref, context),
                                  icon: const Icon(
                                    Icons.delete,
                                    color: AppColors.redColor,
                                  ),
                                ),
                            ],
                          ),
                          //post title
                          if (post.awards.isNotEmpty) ...[
                            const SizedBox(height: 5),
                            SizedBox(
                              height: 25,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: post.awards.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final award = post.awards[index];
                                  return Image.asset(
                                    Constants.awards[award]!,
                                    height: 23,
                                  );
                                },
                              ),
                            ),
                          ],
                          Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: Text(
                              post.title,
                              style: const TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          if (isTypeImage)
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.borderColor,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              height: MediaQuery.of(context).size.height * 0.35,
                              width: double.infinity,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: CachedNetworkImage(
                                  imageUrl: post.link!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          if (isTypeLink)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 18),
                              child: AnyLinkPreview(
                                displayDirection:
                                    UIDirection.uiDirectionHorizontal,
                                link: post.link!,
                              ),
                            ),
                          if (isTypeText)
                            Container(
                              alignment: Alignment.bottomLeft,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Text(
                                post.description!,
                                style: const TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  //vote
                                  Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          color: AppColors.borderColor,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    child: Row(
                                      children: [
                                        IconButton(
                                          onPressed: isGuest
                                              ? () {}
                                              : () => upvotePost(ref),
                                          icon: Icon(
                                            Constants.up,
                                            size: 18,
                                            color:
                                                post.upvotes.contains(user.uid)
                                                    ? AppColors.redColor
                                                    : null,
                                          ),
                                        ),
                                        Text(
                                          '${post.upvotes.length - post.downvotes.length == 0 ? 'Vote' : post.upvotes.length - post.downvotes.length}',
                                          style: const TextStyle(fontSize: 17),
                                        ),
                                        IconButton(
                                          onPressed: isGuest
                                              ? () {}
                                              : () => downvotePost(ref),
                                          icon: Icon(
                                            Constants.down,
                                            size: 18,
                                            color: post.downvotes
                                                    .contains(user.uid)
                                                ? AppColors.redColor
                                                : null,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  //comments
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  GestureDetector(
                                    onTap: () => navigateToComments(context),
                                    child: Container(
                                      height: 40,
                                      width: 80,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            color: AppColors.borderColor,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Row(
                                        mainAxisAlignment:
                                            post.commentCount > 100
                                                ? MainAxisAlignment.spaceBetween
                                                : MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.comment,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            '${post.commentCount == 0 ? '' : post.commentCount}',
                                            style:
                                                const TextStyle(fontSize: 17),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              // moderatortools
                              ref
                                  .watch(getCommunityByNameProvider(
                                      post.communityName))
                                  .when(
                                    data: (data) {
                                      if (data.mods.contains(user.uid)) {
                                        return IconButton(
                                          onPressed: () {},
                                          icon: const Icon(
                                            Icons.admin_panel_settings,
                                          ),
                                        );
                                      }
                                      return const SizedBox();
                                    },
                                    error: (error, stackTrace) => ErrorText(
                                      text: error.toString(),
                                    ),
                                    loading: () => const Loader(),
                                  ),
                              //awards
                              IconButton(
                                onPressed: isGuest
                                    ? () {}
                                    : () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => Dialog(
                                            child: Padding(
                                              padding: const EdgeInsets.all(20),
                                              child: GridView.builder(
                                                shrinkWrap: true,
                                                gridDelegate:
                                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 4,
                                                ),
                                                itemCount: user.awards.length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  final award =
                                                      user.awards[index];

                                                  return GestureDetector(
                                                    onTap: () => awardPost(
                                                      ref,
                                                      award,
                                                      context,
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Image.asset(
                                                          Constants
                                                              .awards[award]!),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                icon: const Icon(Icons.card_giftcard_outlined),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
