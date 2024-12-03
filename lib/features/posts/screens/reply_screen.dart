import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/features/posts/controller/post_controller.dart';
import 'package:reddit/model/comment_model.dart';

class CommentReplyScreen extends ConsumerStatefulWidget {
  final Comment comment;
  const CommentReplyScreen({super.key, required this.comment});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CommentReplyScreenState();
}

class _CommentReplyScreenState extends ConsumerState<CommentReplyScreen> {
  final TextEditingController replyController = TextEditingController();

  void addReply(BuildContext context) {
    if (replyController.text.trim().isEmpty) return;
    ref.read(postControllerProvider.notifier).addReply(
          context: context,
          text: replyController.text.trim(),
          comment: widget.comment,
        );
    setState(() {
      replyController.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reply'), actions: [
        TextButton(
            onPressed: () => addReply(context),
            child: const Text('Post',
                style: TextStyle(
                  color: Colors.blue,
                )))
      ]),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.comment.text,
              style: const TextStyle(fontSize: 18),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: replyController,
              decoration: const InputDecoration(
                hintText: 'Reply to this comment',
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
