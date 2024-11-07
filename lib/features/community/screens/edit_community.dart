import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/constants/constants.dart';
import 'package:reddit/core/error/error_text.dart';
import 'package:reddit/core/utils/pick_image.dart';
import 'package:reddit/core/widgets/loader.dart';
import 'package:reddit/features/community/controller/community_controller.dart';
import 'package:reddit/model/community_model.dart';

class EditCommunityScreen extends ConsumerStatefulWidget {
  final String name;
  const EditCommunityScreen({super.key, required this.name});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditCommunityScreenState();
}

class _EditCommunityScreenState extends ConsumerState<EditCommunityScreen> {
  File? bannerImage;
  File? avatarImage;
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

  void editCommunity(Community community, BuildContext context) async {
    ref.read(communityProvider.notifier).editCommunity(
        avatarImage: avatarImage,
        bannerImage: bannerImage,
        community: community,
        context: context);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(communityProvider);

    return ref.watch(getCommunityByNameProvider(widget.name)).when(
        data: (community) => Scaffold(
              appBar: AppBar(
                centerTitle: false,
                title: const Text('Edit Community'),
                actions: [
                  TextButton(
                      onPressed: () => editCommunity(community, context),
                      child: const Text('Save'))
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
                                                        NetworkImage(
                                                            community.avatar),
                                                    radius: 32,
                                                  ),
                                          ))
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
            ),
        error: (error, stackrace) => ErrorText(
              text: error.toString(),
            ),
        loading: () => const Loader());
  }
}
