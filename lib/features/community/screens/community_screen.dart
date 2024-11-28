import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/error/error_text.dart';
import 'package:reddit/core/themes/colors.dart';
import 'package:reddit/core/utils/show_snackbar.dart';
import 'package:reddit/core/widgets/community_card.dart';
import 'package:reddit/core/widgets/custom_appbar.dart';
import 'package:reddit/core/widgets/loader.dart';
import 'package:reddit/features/auth/controller/auth_controller.dart';
import 'package:reddit/features/community/controller/community_controller.dart';
import 'package:reddit/features/community/controller/topic_controller.dart';
import 'package:reddit/features/home/delegate/search_community_delegate.dart';
import 'package:reddit/model/community_model.dart';
import 'package:routemaster/routemaster.dart';

class CommunityScreen extends ConsumerStatefulWidget {
  const CommunityScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CommunityScreenState();
}

class _CommunityScreenState extends ConsumerState<CommunityScreen> {
  
  


 

 

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(communityProvider);
    final user = ref.watch(userProvider)!;

    return Scaffold(
        appBar: CustomAppBar(
          title: "Communities",
          onProfilePressed: () => Scaffold.of(context).openDrawer(),
          onSearchPressed: () {
            showSearch(
                context: context, delegate: SearchCommunityDelegate(ref));
          },
          onDrawerPressed: () => Scaffold.of(context).openDrawer(),
        ),
        body: isLoading
            ? const Loader()
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Explore by topics',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      ref.watch(getTopicsProvider).when(
                          data: (topics) {
                            return Wrap(
                              spacing: 8,
                              children: topics.map((topic) {
                                return Chip(
                                    color: const WidgetStatePropertyAll(
                                        Colors.blue),
                                    label: Text(topic.name));
                              }).toList(),
                            );
                          },
                          error: (e, s) => ErrorText(text: e.toString()),
                          loading: () => const Loader()),
                      const SizedBox(height: 16),
                      const Text(
                        'Community',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      ref.watch(getAllCommunitiesProvider).when(
                            data: (communities) {
                              return Column(
                                children: communities.map((community) {
                                  return CommunityCard(community: community, ref: ref, user: user);
                                }).toList(),
                              );
                            },
                            error: (error, stack) =>
                                ErrorText(text: error.toString()),
                            loading: () => const Loader(),
                          )
                    ],
                  ),
                ),
              ));
  }
}
