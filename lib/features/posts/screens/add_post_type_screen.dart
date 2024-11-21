import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/error/error_text.dart';
import 'package:reddit/core/themes/colors.dart';
import 'package:reddit/core/utils/pick_image.dart';
import 'package:reddit/core/utils/show_snackbar.dart';
import 'package:reddit/core/widgets/loader.dart';
import 'package:reddit/features/community/controller/community_controller.dart';
import 'package:reddit/features/posts/controller/post_controller.dart';
import 'package:reddit/model/community_model.dart';

class AddPostTypeScreen extends ConsumerStatefulWidget {
  final String type;
  const AddPostTypeScreen({super.key, required this.type});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddPostTypeScreenState();
}

class _AddPostTypeScreenState extends ConsumerState<AddPostTypeScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController linkController = TextEditingController();
  File? bannerImage;
  List<Community> communities = [];
  Community? selectedCommunity;
  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    linkController.dispose();
    super.dispose();
  }

  void selectBannerImage() async {
    final res = await pickImage();
    if (res != null) {
      setState(() {
        bannerImage = res;
      });
    }
  }

  void sharePost() {
    if (widget.type == 'image' &&
        (bannerImage != null) &&
        titleController.text.isNotEmpty) {
      ref.read(postControllerProvider.notifier).shareImagePost(
            context: context,
            title: titleController.text.trim(),
            selectedCommunity: selectedCommunity ?? communities[0],
            file: bannerImage,
          );
    } else if (widget.type == 'text' && titleController.text.isNotEmpty) {
      ref.read(postControllerProvider.notifier).shareTextPost(
            context: context,
            title: titleController.text.trim(),
            selectedCommunity: selectedCommunity ?? communities[0],
            description: descriptionController.text.trim(),
          );
    } else if (widget.type == 'link' &&
        titleController.text.isNotEmpty &&
        linkController.text.isNotEmpty) {
      ref.read(postControllerProvider.notifier).shareLinkPost(
            context: context,
            title: titleController.text.trim(),
            selectedCommunity: selectedCommunity ?? communities[0],
            link: linkController.text.trim(),
          );
    } else {
      showSnackBar(context, 'Please enter all the fields');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTypeImage = widget.type == 'image';
    final isTypeText = widget.type == 'text';
    final isTypeLink = widget.type == 'link';
    final isLoading = ref.watch(postControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Add ${widget.type} post'),
        actions: [
          TextButton(onPressed: () => sharePost(), child: const Text('Share'))
        ],
      ),
      body: isLoading
          ? const Loader()
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      hintText: 'Title',
                      labelText: "Title",
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (isTypeImage)
                    GestureDetector(
                      onTap: () => selectBannerImage(),
                      child: DottedBorder(
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(10),
                          color: AppColors.gradient3,
                          dashPattern: const [10, 4],
                          strokeCap: StrokeCap.round,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            height: 150,
                            width: double.infinity,
                            child: bannerImage != null
                                ? Image.file(
                                    bannerImage!,
                                    fit: BoxFit.cover,
                                  )
                                : const Center(
                                    child: Icon(
                                      Icons.camera_alt_outlined,
                                      size: 40,
                                    ),
                                  ),
                          )),
                    ),
                  if (isTypeText)
                    TextField(
                      controller: descriptionController,
                      maxLines: 6,
                      maxLength: 500,
                      decoration: const InputDecoration(
                        hintText: 'Description',
                        labelText: "Description",
                      ),
                    ),
                  if (isTypeLink)
                    TextField(
                      controller: linkController,
                      decoration: const InputDecoration(
                        hintText: 'Link',
                        labelText: "Link",
                      ),
                    ),
                  const SizedBox(height: 20),
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text('Select Community'),
                  ),
                  ref.watch(userCommunityProvider).when(
                      data: (data) {
                        communities = data;
                        if (data.isEmpty) {
                          return const SizedBox();
                        }
                        return DropdownButton(
                            value: selectedCommunity ?? data[0],
                            items: data
                                .map((e) => DropdownMenuItem(
                                    value: e, child: Text(e.name)))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedCommunity = value as Community;
                              });
                            });
                      },
                      error: (error, stackTrace) =>
                          ErrorText(text: error.toString()),
                      loading: () => const Loader())
                ],
              ),
            ),
    );
  }
}
