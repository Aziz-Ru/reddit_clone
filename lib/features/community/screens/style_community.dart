import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/constants/constants.dart';
import 'package:reddit/core/utils/pick_image.dart';
import 'package:reddit/core/utils/show_snackbar.dart';
import 'package:reddit/core/widgets/loader.dart';
import 'package:reddit/features/community/controller/community_controller.dart';
import 'package:reddit/features/community/controller/topic_controller.dart';

class StyleCommunityScreen extends ConsumerStatefulWidget {
  final String name;
  final String description;
  const StyleCommunityScreen(
      {super.key, required this.name, required this.description});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _StyleCommunityScreenState();
}

class _StyleCommunityScreenState extends ConsumerState<StyleCommunityScreen> {
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

  final List<String> topics = [];

  void createCommunity(BuildContext context) {
    ref.read(communityProvider.notifier).createCommunity(
        name: widget.name,
        description: widget.description,
        topics: topics,
        bannerImage: bannerImage,
        avatarImage: avatarImage,
        context: context);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(communityProvider);
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Style Community'),
      ),
      body: isLoading
          ? const Loader()
          : SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Style You Community',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      "Choose A Banner & Avatar attract members and establish your community's identity",
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      'Preview',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
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
                                              : const Center(
                                                  child: Icon(
                                                    Icons.camera_alt_outlined,
                                                    size: 40,
                                                  ),
                                                ))),
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
                                                backgroundImage: Image.asset(
                                                        Constants
                                                            .loginEmotePath)
                                                    .image,
                                                radius: 32,
                                              )))
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      'Choose Community Topics',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      "Select topics that will help people find your community",
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Wrap(
                      spacing: 8,
                      children: topics
                          .map((e) => ChoiceChip(
                              side: const BorderSide(
                                  color: Colors.blue,
                                  width: .5,
                                  style: BorderStyle.solid),
                              label: Text(e),
                              selected: false,
                              onSelected: (value) {}))
                          .toList(),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    ref.watch(getTopicsProvider).when(
                        data: (data) => Wrap(
                              spacing: 8,
                              children: data
                                  .map((e) => ChoiceChip(
                                      side: const BorderSide(
                                          color: Colors.blue,
                                          width: .5,
                                          style: BorderStyle.solid),
                                      label: Text(e.name),
                                      selected: false,
                                      onSelected: (value) {
                                        onTopicSelected(e.search);
                                      }))
                                  .toList(),
                            ),
                        loading: () => const Loader(),
                        error: (error, stackRace) => Text(error.toString())),
                    const SizedBox(
                      height: 15,
                    ),
                    ElevatedButton(
                      onPressed: () => createCommunity(context),
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          minimumSize: const Size(double.infinity, 50),
                          backgroundColor: Colors.blueAccent),
                      child: const Text(
                        'Next',
                        style: TextStyle(fontSize: 17, color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }

  void onTopicSelected(String search) {
    final exist = topics.contains(search);
    if (exist) {
      topics.remove(search);
    } else {
      if (topics.length > 2) {
        showSnackBar(context, 'You can only select 3 topics');
        return;
      }
      topics.add(search);
    }
  }
}
