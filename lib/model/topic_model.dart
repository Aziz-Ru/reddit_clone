class TopicModel {
  final String name;
  final String search;
  TopicModel({required this.name, required this.search});

  factory TopicModel.fromMap(Map<String, dynamic> map) {
    return TopicModel(
      name: map['name'],
      search: map['search'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'search': search,
    };
  }
}
