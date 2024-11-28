import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/themes/colors.dart';
import 'package:reddit/features/auth/controller/auth_controller.dart';

class CustomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onSearchPressed;
  final VoidCallback onProfilePressed;
  final VoidCallback onDrawerPressed;

  const CustomAppBar({
    super.key,
    required this.title,
    required this.onSearchPressed,
    required this.onProfilePressed,
    required this.onDrawerPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    return AppBar(
      centerTitle: false,
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      leading: Builder(builder: (context) {
        return IconButton(
            onPressed: onDrawerPressed, icon: const Icon(Icons.menu));
      }),
      actions: [
        IconButton(onPressed: onSearchPressed, icon: const Icon(Icons.search)),
        Builder(builder: (context) {
          return Stack(
            children: [
              IconButton(
                onPressed: onProfilePressed,
                icon: CircleAvatar(
                  backgroundImage: NetworkImage(user.profilePic),
                ),
              ),
              Positioned(
                  right: 6,
                  bottom: 8,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                        color: AppColors.redColor, shape: BoxShape.circle),
                  ))
            ],
          );
        })
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
