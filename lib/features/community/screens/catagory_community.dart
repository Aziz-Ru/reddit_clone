import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/error/error_text.dart';
import 'package:reddit/core/widgets/community_card.dart';
import 'package:reddit/core/widgets/loader.dart';
import 'package:reddit/features/auth/controller/auth_controller.dart';
import 'package:reddit/features/community/controller/community_controller.dart';
import 'package:reddit/features/community/controller/topic_controller.dart';

class CatagoryCommunityScreen extends ConsumerWidget {
  final String search;
  const CatagoryCommunityScreen({super.key, required this.search});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    final isLoading = ref.watch(communityProvider);

    return Scaffold(
        appBar: AppBar(
            title: ref.watch(getTopicByNameProvider(search)).when(
                data: (d) => Text(d.name),
                error: (e, s) => ErrorText(text: e.toString()),
                loading: () => const Loader())),
        body: isLoading
            ? const Loader()
            : ref.watch(getCommunityByTopicProvider(search)).when(
                data: (data) {
                  if (data.isEmpty) {
                    return const Center(
                        child: Text("No community found for this topic"));
                  }
                  return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final community = data[index];
                        return communityCard(
                            context: context,
                            community: community,
                            ref: ref,
                            user: user);
                      });
                },
                error: (e, s) => ErrorText(text: e.toString()),
                loading: () => const Loader()));
  }
}
