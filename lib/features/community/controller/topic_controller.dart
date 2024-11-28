import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/features/community/repo/topic_repository.dart';
import 'package:reddit/model/topic_model.dart';

final topicControllerProvider = Provider<TopicController>((ref) {
  final topicRepository = ref.watch(topicRepositoryProvider);
  return TopicController(topicRepository: topicRepository);
});

final getTopicsProvider = StreamProvider<List<TopicModel>>((ref) {
  final controller = ref.watch(topicControllerProvider);
  return controller.getTopics();
});

class TopicController {
  final TopicRepository _topicRepository;

  TopicController({required TopicRepository topicRepository})
      : _topicRepository = topicRepository;

  Stream<List<TopicModel>> getTopics() {
    return _topicRepository.getTopics();
  }
}
