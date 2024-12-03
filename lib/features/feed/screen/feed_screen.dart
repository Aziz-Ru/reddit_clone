import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/error/error_text.dart';
import 'package:reddit/core/widgets/custom_appbar.dart';
import 'package:reddit/core/widgets/loader.dart';
import 'package:reddit/core/widgets/post_card.dart';
import 'package:reddit/features/community/controller/community_controller.dart';
import 'package:reddit/features/home/delegate/search_community_delegate.dart';
import 'package:reddit/features/posts/controller/post_controller.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          title: CustomAppBar(
            title: 'Home',
            onProfilePressed: () {
              Scaffold.of(context).openEndDrawer();
            },
            onSearchPressed: () {
              showSearch(
                  context: context, delegate: SearchCommunityDelegate(ref));
            },
            onDrawerPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        body: RefreshIndicator(
            onRefresh: () async {
              // ignore: unused_result
              ref.refresh(guestPostsProvider);
            },
            child: ref.watch(userCommunityProvider).when(
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
                )));
  }
}
