import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/error/error_text.dart';
import 'package:reddit/core/widgets/loader.dart';
import 'package:reddit/features/community/controller/community_controller.dart';
import 'package:routemaster/routemaster.dart';

class SearchCommunityDelegate extends SearchDelegate {
  final WidgetRef ref;
  SearchCommunityDelegate(this.ref);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.close),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    return const SizedBox();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ref.watch(searchCommunityProvider(query)).when(
        data: (communities) => ListView.builder(
              itemCount: communities.length,
              itemBuilder: (context, index) {
                final commnity = communities[index];
                return ListTile(
                  onTap: () => navigateToCommunity(context, commnity.name),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(commnity.avatar),
                  ),
                  title: Text('r/${commnity.name}'),
                );
              },
            ),
        error: (e, s) => ErrorText(text: e.toString()),
        loading: () => const Loader());
  }

  void navigateToCommunity(BuildContext context, String name) {
    Routemaster.of(context).push('/community/$name');
  }
}
