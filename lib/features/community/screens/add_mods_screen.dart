import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/error/error_text.dart';
import 'package:reddit/core/widgets/loader.dart';
import 'package:reddit/features/auth/controller/auth_controller.dart';
import 'package:reddit/features/community/controller/community_controller.dart';

class AddModsScreen extends ConsumerStatefulWidget {
  final String name;
  const AddModsScreen({super.key, required this.name});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddModsScreenState();
}

class _AddModsScreenState extends ConsumerState<AddModsScreen> {
  Set<String> uids = {};
  int cnt = 0;

  void addUid(String uid) {
    print(uids);
    setState(() {
      uids.add(uid);
    });
  }

  void removeUid(String uid) {
    setState(() {
      uids.remove(uid);
    });
  }

  void saveMods() {
    ref
        .read(communityProvider.notifier)
        .addMods(widget.name, uids.toList(), context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => saveMods(),
            icon: const Icon(Icons.done),
          )
        ],
      ),
      body: ref.watch(getCommunityByNameProvider(widget.name)).when(
          data: (community) => ListView.builder(
              itemCount: community.members.length,
              itemBuilder: (context, index) {
                final member = community.members[index];

                return ref.watch(getUserDataProvider(member)).when(
                    data: (user) {
                      if (community.mods.contains(member)) {
                        uids.add(member);
                      }

                      return CheckboxListTile(
                          value: uids.contains(member),
                          title: Text(user.name),
                          onChanged: (val) {
                            if (index == 0) {
                              return;
                            }
                            if (val == true) {
                              addUid(member);
                            } else {
                              removeUid(member);
                            }
                          });
                    },
                    error: (error, stack) => ErrorText(text: error.toString()),
                    loading: () => const Loader());
              }),
          error: (error, stack) => ErrorText(text: error.toString()),
          loading: () => const Loader()),
    );
  }
}
