import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit/core/constants/firebase_constants.dart';
import 'package:reddit/core/error/failure.dart';
import 'package:reddit/core/providers/firebase_providers.dart';
import 'package:reddit/core/type_def.dart';
import 'package:reddit/model/user_model.dart';

final userProfileProvider =
    Provider((ref) => UserProfileRepository(ref.watch(firestoreProvider)));

class UserProfileRepository {
  final FirebaseFirestore _firestore;

  UserProfileRepository(this._firestore);

  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);

  FutureVoid editProfile(UserModel user) async {
    try {
      final res = await _users.doc(user.uid).update(user.toMap());
      return right(res);
    } on FirebaseException catch (e) {
      return left(Failure(e.message!));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
