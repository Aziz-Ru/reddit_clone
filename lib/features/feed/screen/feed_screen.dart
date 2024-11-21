import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/error/error_text.dart';
import 'package:reddit/core/widgets/loader.dart';
import 'package:reddit/core/widgets/post_card.dart';
import 'package:reddit/features/community/controller/community_controller.dart';
import 'package:reddit/features/posts/controller/post_controller.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final user = ref.watch(userProvider)!;
    // final isGuest = !user.isAuthenticated;

    // if (!isGuest) {
    //   return ref.watch(userCommunityProvider).when(
    //         data: (communities) =>
    //             ref.watch(userPostsProvider(communities)).when(
    //                   data: (data) {
    //                     return ListView.builder(
    //                       itemCount: data.length,
    //                       itemBuilder: (BuildContext context, int index) {
    //                         final post = data[index];
    //                         return PostCard(post: post);
    //                       },
    //                     );
    //                   },
    //                   error: (error, stackTrace) {
    //                     return ErrorText(
    //                       text: error.toString(),
    //                     );
    //                   },
    //                   loading: () => const Loader(),
    //                 ),
    //         error: (error, stackTrace) => ErrorText(
    //           text: error.toString(),
    //         ),
    //         loading: () => const Loader(),
    //       );
    // }

    return ref.watch(userCommunityProvider).when(
          data: (communities) => ref.watch(guestPostsProvider).when(
                data: (data) {
                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      final post = data[index];
                      return PostCard(post: post);
                    },
                  );
                },
                error: (error, stackTrace) {
                  return ErrorText(
                    text: error.toString(),
                  );
                },
                loading: () => const Loader(),
              ),
          error: (error, stackTrace) => ErrorText(
            text: error.toString(),
          ),
          loading: () => const Loader(),
        );
  }
}
