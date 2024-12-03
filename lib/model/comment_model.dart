class Comment {
  final String id;
  final String text;
  final DateTime createdAt;
  final String postId;
  final String username;
  final String profilePic;
  final List<Comment> replies;
  final int replyCount;
  final String? parentCommentId;

  Comment(
      {required this.id,
      required this.text,
      required this.createdAt,
      required this.postId,
      required this.username,
      required this.profilePic,
      this.replies = const [],
      this.replyCount = 0,
      this.parentCommentId});

  Comment copyWith(
      {String? id,
      String? text,
      DateTime? createdAt,
      String? postId,
      String? username,
      String? profilePic,
      List<Comment>? replies,
      int? replyCount,
      String? parentCommentId}) {
    return Comment(
        id: id ?? this.id,
        text: text ?? this.text,
        createdAt: createdAt ?? this.createdAt,
        postId: postId ?? this.postId,
        username: username ?? this.username,
        profilePic: profilePic ?? this.profilePic,
        replies: replies ?? this.replies,
        replyCount: replyCount ?? this.replyCount,
        parentCommentId: parentCommentId ?? this.parentCommentId);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'postId': postId,
      'username': username,
      'profilePic': profilePic,
      'replies': replies.map((x) => x.toMap()).toList(),
      'replyCount': replyCount,
      'parentCommentId': parentCommentId ?? ''
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      id: map['id'] ?? '',
      text: map['text'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      postId: map['postId'] ?? '',
      username: map['username'] ?? '',
      profilePic: map['profilePic'] ?? '',
      replies: List<Comment>.from(
          map['replies']?.map((x) => Comment.fromMap(x)) ?? []),
      replyCount: map['replyCount'] ?? 0,
      parentCommentId: map['parentCommentId'] ?? '',
    );
  }

  Comment addReply(Comment reply) {
    return copyWith(
        replies: [...replies, reply],
        replyCount: replyCount + 1,
        parentCommentId: id);
  }

  @override
  String toString() {
    return 'Comment(id: $id, text: $text, createdAt: $createdAt, postId: $postId, username: $username, profilePic: $profilePic)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Comment &&
        other.id == id &&
        other.text == text &&
        other.createdAt == createdAt &&
        other.postId == postId &&
        other.username == username &&
        other.profilePic == profilePic;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        text.hashCode ^
        createdAt.hashCode ^
        postId.hashCode ^
        username.hashCode ^
        profilePic.hashCode;
  }
}
