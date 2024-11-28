class TopicModel {
  final String name;
  TopicModel({required this.name});

  factory TopicModel.fromMap(Map<String, dynamic> map) {
    return TopicModel(name: map['name']);
  }
}
