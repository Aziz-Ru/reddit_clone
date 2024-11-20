import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/constants/constants.dart';
import 'package:reddit/core/error/error_text.dart';
import 'package:reddit/core/utils/pick_image.dart';
import 'package:reddit/core/widgets/loader.dart';
import 'package:reddit/features/auth/controller/auth_controller.dart';
import 'package:reddit/features/profile/controller/user_profile_controller.dart';

class EditProfile extends ConsumerStatefulWidget {
  final String uid;
  const EditProfile({super.key, required this.uid});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditProfileState();
}

class _EditProfileState extends ConsumerState<EditProfile> {
  File? bannerImage;
  File? avatarImage;
  late TextEditingController nameController;
  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: ref.read(userProvider)!.name);
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  void selectBannerImage() async {
    final res = await pickImage();
    if (res != null) {
      setState(() {
        bannerImage = res;
      });
    }
  }

  void selectAvatarImage() async {
    final res = await pickImage();
    if (res != null) {
      setState(() {
        avatarImage = res;
      });
    }
  }

  void editProfile() {
    ref.read(userProfileControllerProvider.notifier).editProfile(
        avatarImage: avatarImage,
        bannerImage: bannerImage,
        name: nameController.text.trim(),
        context: context);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(userProfileControllerProvider);

    return ref.watch(getUserDataProvider(widget.uid)).when(
        data: (community) => Scaffold(
              appBar: AppBar(
                centerTitle: false,
                title: const Text('Edit Profile'),
                actions: [
                  TextButton(
                      onPressed: () => editProfile(), child: const Text('Save'))
                ],
              ),
              body: isLoading
                  ? const Loader()
                  : Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 200,
                            child: Stack(
                              children: [
                                SizedBox(
                                  height: 200,
                                  child: Stack(
                                    children: [
                                      GestureDetector(
                                        onTap: selectBannerImage,
                                        child: DottedBorder(
                                            borderType: BorderType.RRect,
                                            radius: const Radius.circular(10),
                                            color: Colors.grey,
                                            dashPattern: const [10, 4],
                                            strokeCap: StrokeCap.round,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              height: 150,
                                              width: double.infinity,
                                              child: bannerImage != null
                                                  ? Image.file(bannerImage!,
                                                      fit: BoxFit.cover)
                                                  : community.banner.isEmpty ||
                                                          community.banner ==
                                                              Constants
                                                                  .bannerDefault
                                                      ? const Center(
                                                          child: Icon(
                                                            Icons
                                                                .camera_alt_outlined,
                                                            size: 40,
                                                          ),
                                                        )
                                                      : Image.network(
                                                          community.banner,
                                                          fit: BoxFit.cover,
                                                        ),
                                            )),
                                      ),
                                      Positioned(
                                          bottom: 20,
                                          left: 20,
                                          child: GestureDetector(
                                            onTap: selectAvatarImage,
                                            child: avatarImage != null
                                                ? CircleAvatar(
                                                    backgroundImage:
                                                        FileImage(avatarImage!),
                                                    radius: 32,
                                                  )
                                                : CircleAvatar(
                                                    backgroundImage:
                                                        NetworkImage(community
                                                            .profilePic),
                                                    radius: 32,
                                                  ),
                                          ))
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TextField(
                            decoration: const InputDecoration(
                              filled: true,
                              hintText: 'Name',
                            ),
                            controller: nameController,
                          )
                        ],
                      )),
            ),
        error: (error, stackrace) => ErrorText(
              text: error.toString(),
            ),
        loading: () => const Loader());
  }
}
