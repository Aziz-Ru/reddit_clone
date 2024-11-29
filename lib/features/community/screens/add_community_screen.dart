import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/utils/show_snackbar.dart';
import 'package:reddit/features/community/controller/community_controller.dart';

class AddCommunityScreen extends ConsumerStatefulWidget {
  const AddCommunityScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddCommunityScreenState();
}

class _AddCommunityScreenState extends ConsumerState<AddCommunityScreen> {
  final TextEditingController _namecontroller = TextEditingController();
  final TextEditingController _descriptioncontroller = TextEditingController();

  void createCommunity() {
    if (_namecontroller.text.trim().isEmpty ||
        _descriptioncontroller.text.trim().isEmpty) {
      showSnackBar(context, 'Please fill all fields');
      return;
    }
    ref.read(communityProvider.notifier).isCommunityExist(
        _namecontroller.text.trim(),
        _descriptioncontroller.text.trim(),
        context);
  }

  @override
  void dispose() {
    super.dispose();
    _namecontroller.dispose();
    _descriptioncontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(communityProvider);
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text(
          'Create Community',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tell us about your community',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      "A name and description help people understand what your community all about",
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextField(
                      maxLength: 21,
                      controller: _namecontroller,
                      decoration: const InputDecoration(
                        hintText: 'c/community name',
                        labelText: 'Community Name *',
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextField(
                      maxLines: 6,
                      maxLength: 500,
                      controller: _descriptioncontroller,
                      decoration: const InputDecoration(
                          hintText: 'Description...',
                          labelText: 'Description *',
                          alignLabelWithHint: true),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    ElevatedButton(
                      onPressed: () => createCommunity(),
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
}
