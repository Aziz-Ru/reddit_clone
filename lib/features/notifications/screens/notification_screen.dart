import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/widgets/custom_appbar.dart';
import 'package:reddit/features/home/delegate/search_community_delegate.dart';

class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Notifications",
        onProfilePressed: () {
          Scaffold.of(context).openEndDrawer();
        },
        onSearchPressed: () {
          showSearch(context: context, delegate: SearchCommunityDelegate(ref));
        },
        onDrawerPressed: () {
          Scaffold.of(context).openDrawer();
        },
      ),
      body: const Center(
        child: Text("Notifications"),
      ),
    );
  }
}
