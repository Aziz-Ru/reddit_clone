import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit/core/constants/firebase_constants.dart';
import 'package:reddit/core/error/failure.dart';
import 'package:reddit/core/providers/firebase_providers.dart';
import 'package:reddit/core/type_def.dart';
import 'package:reddit/model/community_model.dart';
import 'package:reddit/model/post_model.dart';

final communityRepositoryProvider = Provider((ref) {
  return CommunityRepository(firestore: ref.read(firestoreProvider));
});

class CommunityRepository {
  final FirebaseFirestore _firestore;

  CommunityRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _communites =>
      _firestore.collection(FirebaseConstants.communitiesCollection);


  CollectionReference get _posts=>
      _firestore.collection(FirebaseConstants.postsCollection);


  FutureVoid createCommunity(Community community) async {
    try {
      final existingCommunity = await _communites.doc(community.name).get();
      if (existingCommunity.exists) {
        return left(Failure('Community already exists!'));
      }
      final res = await _communites.doc(community.id).set(community.toMap());
      return right(res);
    } on FirebaseException catch (e) {
      return left(Failure(e.message!));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Community>> getUserCommunity(String uid) {
    return _communites
        .where('members', arrayContains: uid)
        .snapshots()
        .map((events) {
      List<Community> communities = [];

      for (var doc in events.docs) {
        communities.add(Community.fromMap(doc.data() as Map<String, dynamic>));
      }
      return communities;
    });
  }

  Stream<Community> getCommunityByName(String name) {
    // final community = _communites.doc(name).get();
    // print(Community.fromMap(community as Map<String, dynamic>));

    return _communites.doc(name).snapshots().map(
        (event) => Community.fromMap(event.data() as Map<String, dynamic>));
  }

  FutureVoid editCommunity(Community community) async {
    try {
      final res =
          await _communites.doc(community.name).update(community.toMap());
      return right(res);
    } on FirebaseException catch (e) {
      return left(Failure(e.message!));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Community>> searchCommunites(String query) {
    return _communites
        .where('name',
            isGreaterThanOrEqualTo: query.isEmpty ? 0 : query,
            isLessThan: query.isEmpty
                ? null
                : query.substring(0, query.length - 1) +
                    String.fromCharCode(query.codeUnitAt(query.length - 1) + 1))
        .snapshots()
        .map((events) {
      List<Community> communities = [];

      for (var doc in events.docs) {
        communities.add(Community.fromMap(doc.data() as Map<String, dynamic>));
      }
      return communities;
    });
  }

  FutureVoid joinCommunity(String communityName, String userId) async {
    try {
      return right(_communites.doc(communityName).update({
        'members': FieldValue.arrayUnion([userId])
      }));
    } on FirebaseException catch (e) {
      return left(Failure(e.message!));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid leaveCommunity(String communityName, String userId) async {
    try {
      return right(_communites.doc(communityName).update({
        'members': FieldValue.arrayRemove([userId])
      }));
    } on FirebaseException catch (e) {
      return left(Failure(e.message!));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid addMods(List<String> uids, String communityName) async {
    try {
      return right(await _communites.doc(communityName).update({'mods': uids}));
    } on FirebaseException catch (e) {
      return left(Failure(e.message!));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Post>> getCommunityPosts(String communityName) {
    return _posts
        .where('communityName', isEqualTo: communityName)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((event) => event.docs
            .map((e) => Post.fromMap(e.data() as Map<String, dynamic>))
            .toList());
  }
}
