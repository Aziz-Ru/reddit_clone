import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/features/auth/controller/auth_controller.dart';

class ProfileDrawer extends ConsumerWidget {
  const ProfileDrawer({super.key});

  void logOut(WidgetRef ref) {
    ref.read(authControllProvider.notifier).logout();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(
                user.profilePic,
              ),
              radius: 50,
            ),
            const SizedBox(height: 10),
            Text(
              'u/${user.name}',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),
            ListTile(
                title: const Text("Profile"),
                leading: const Icon(Icons.person),
                onTap: () {}),
            ListTile(
                title: const Text("Settings"),
                leading: const Icon(Icons.settings),
                onTap: () {}),
            ListTile(
                title: const Text("Logout"),
                leading: const Icon(Icons.logout),
                onTap: () => logOut(ref)),
          ],
        ),
      ),
    );
  }
}
