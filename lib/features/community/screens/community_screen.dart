import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/utils/show_snackbar.dart';
import 'package:reddit/core/widgets/loader.dart';
import 'package:reddit/features/community/controller/community_controller.dart';

class CommunityScreen extends ConsumerStatefulWidget {
  const CommunityScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CommunityScreenState();
}

class _CommunityScreenState extends ConsumerState<CommunityScreen> {
  
  final TextEditingController _namecontroller = TextEditingController();
  final TextEditingController _descriptioncontroller = TextEditingController();

  void createCommunity() {
    if (_namecontroller.text.trim().isEmpty ||
        _descriptioncontroller.text.trim().isEmpty) {
      showSnackBar(context, 'Please fill all fields');
      return;
    }

    ref.read(communityProvider.notifier).createCommunity(
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
        title: const Text('Create Community'),
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
                      controller: _namecontroller,
                      decoration: const InputDecoration(
                        hintText: 'r/community name',
                        labelText: 'Community Name *',
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextField(
                      maxLines: 6,
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
                        'Create Community',
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
