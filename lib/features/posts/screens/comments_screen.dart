import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/error/error_text.dart';
import 'package:reddit/core/widgets/comment_card.dart';
import 'package:reddit/core/widgets/loader.dart';
import 'package:reddit/core/widgets/post_card.dart';
import 'package:reddit/features/auth/controller/auth_controller.dart';
import 'package:reddit/features/posts/controller/post_controller.dart';
import 'package:reddit/model/post_model.dart';

class CommentsScreen extends ConsumerStatefulWidget {
  final String postId;
  const CommentsScreen({
    super.key,
    required this.postId,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends ConsumerState<CommentsScreen> {
  final commentController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    commentController.dispose();
  }

  void addComment(Post post) {
    ref.read(postControllerProvider.notifier).addComment(
          context: context,
          text: commentController.text.trim(),
          post: post,
        );
    setState(() {
      commentController.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;

    return Scaffold(
      appBar: AppBar(),
      body: ref.watch(getPostByIdProvider(widget.postId)).when(
            data: (data) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    PostCard(post: data),
                    if (!isGuest)
                      TextField(
                        onSubmitted: (val) => addComment(data),
                        controller: commentController,
                        decoration: const InputDecoration(
                          hintText: 'What are your thoughts?',
                          filled: true,
                          border: InputBorder.none,
                        ),
                      ),
                    ref.watch(getPostCommentsProvider(widget.postId)).when(
                          data: (data) {
                            return Column(
                              children: data
                                  .map(
                                    (comment) => CommentCard(
                                      comment: comment,
                                    ),
                                  )
                                  .toList(),
                            );
                          },
                          error: (error, stackTrace) {
                            return ErrorText(
                              text: error.toString(),
                            );
                          },
                          loading: () => const Loader(),
                        ),
                  ],
                ),
              );
            },
            error: (error, stackTrace) => ErrorText(
              text: error.toString(),
            ),
            loading: () => const Loader(),
          ),
    );
  }
}
