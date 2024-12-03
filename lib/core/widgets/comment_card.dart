import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/themes/colors.dart';
import 'package:reddit/features/posts/screens/reply_screen.dart';
import 'package:reddit/model/comment_model.dart';

class CommentCard extends ConsumerStatefulWidget {
  final Comment comment;
  final isParent;
  const CommentCard({
    super.key,
    required this.comment,
    required this.isParent,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CommentCardState();
}

class _CommentCardState extends ConsumerState<CommentCard> {
  void navigateToCommentReply(Comment comment) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CommentReplyScreen(comment: comment)));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 6,
        horizontal: widget.isParent ? 16 : 32,
      ),
      decoration: BoxDecoration(
          border: Border(
        bottom: BorderSide(
          color: widget.isParent
              ? AppColors.borderColor
              : AppColors.backgroundColor.withOpacity(0.5),
        ),
      )),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                  widget.comment.profilePic,
                ),
                radius: 18,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'u/${widget.comment.username}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(widget.comment.text)
                    ],
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Icon(Icons.favorite),
              ElevatedButton(
                onPressed: () => navigateToCommentReply(widget.comment),
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.backgroundColor),
                child: const Row(
                  children: [
                    Icon(Icons.reply),
                    Text('Reply'),
                  ],
                ),
              )
            ],
          ),

          // if (comment.replies.isNotEmpty)
          if (widget.comment.replies.isNotEmpty)
            Column(
              children: widget.comment.replies
                  .map(
                    (reply) => CommentCard(
                      comment: reply,
                      isParent: false,
                    ),
                  )
                  .toList(),
            ),
        ],
      ),
    );
  }
}
