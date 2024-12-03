import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/error/error_text.dart';
import 'package:reddit/core/themes/colors.dart';
import 'package:reddit/core/widgets/comment_card.dart';
import 'package:reddit/core/widgets/loader.dart';
import 'package:reddit/core/widgets/post_card.dart';
import 'package:reddit/features/posts/controller/post_controller.dart';
import 'package:reddit/features/posts/screens/reply_screen.dart';
import 'package:reddit/model/comment_model.dart';
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
  String? commentId;
  @override
  void dispose() {
    super.dispose();
    commentController.dispose();
  }

  void addComment(Post post) {
    if (commentController.text.trim().isEmpty) return;
    ref.read(postControllerProvider.notifier).addComment(
          context: context,
          text: commentController.text.trim(),
          post: post,
        );
    setState(() {
      commentController.text = '';
    });
  }

  void navigateToCommentReply(Post post, Comment comment) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CommentReplyScreen(comment: comment)));
  }

  @override
  Widget build(BuildContext context) {
    // final user = ref.watch(userProvider)!;
    // final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Post'),
      ),
      body: ref.watch(getPostByIdProvider(widget.postId)).when(
            data: (post) {
              return SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          PostCard(post: post),
                          ref
                              .watch(getPostCommentsProvider(widget.postId))
                              .when(
                                data: (comments) {
                                  return Column(
                                    children: comments
                                        .map(
                                          (comment) => CommentCard(
                                            comment: comment,
                                            isParent: true,
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
                          const SizedBox(
                            height: 80,
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        decoration: const BoxDecoration(
                            color: AppColors.backgroundColor),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                onSubmitted: (val) {},
                                controller: commentController,
                                decoration: const InputDecoration(
                                  hintText: 'What are your thoughts?',
                                  filled: true,
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                addComment(post);
                              },
                              icon: const Icon(Icons.send),
                            ),
                          ],
                        ),
                      ),
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
