import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/constants/firebase_constants.dart';
import 'package:reddit/core/providers/firebase_providers.dart';
import 'package:reddit/model/topic_model.dart';

final topicRepositoryProvider = Provider<TopicRepository>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return TopicRepository(firestore: firestore);
});

class TopicRepository {
  final FirebaseFirestore _firestore;

  TopicRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;
  CollectionReference get _communites =>
      _firestore.collection(FirebaseConstants.topicsCollection);

  Stream<List<TopicModel>> getTopics() {
    return _communites.snapshots().map((events) {
      List<TopicModel> topics = [];

      for (var doc in events.docs) {
        topics.add(TopicModel.fromMap(doc.data() as Map<String, dynamic>));
      }
      return topics;
    });
  }
}
