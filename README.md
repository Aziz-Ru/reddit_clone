Positioned(
bottom: 0,
left: 0,
right: 0,
child: Container(
padding: const EdgeInsets.symmetric(
vertical: 10,
horizontal: 4,
),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Row(
children: [
CircleAvatar(
backgroundImage: NetworkImage(
user.profilePic,
),
radius: 18,
),
Expanded(
child: Padding(
padding: const EdgeInsets.only(left: 16.0),
child: Column(
crossAxisAlignment:
CrossAxisAlignment.start,
children: [
TextField(
controller: commentController,
decoration: const InputDecoration(
hintText: 'Add a comment',
),
),
Row(
children: [
IconButton(
onPressed: () {
addComment(data);
},
icon: const Icon(Icons.send),
),
],
),
],
),
),
),
],
),
],
),
),
),
