import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit/core/error/failure.dart';
import 'package:reddit/core/type_def.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabaseStorageRepositoryProvider = Provider((ref) {
  final client = Supabase.instance.client;
  return SupabaseStorageRepository(client: client);
});

class SupabaseStorageRepository {
  final SupabaseClient _client;
  SupabaseStorageRepository({required SupabaseClient client})
      : _client = client;

  FutureEither<String> uploadImage({
    required File image,
    required String id,
  }) async {
    try {
      await _client.storage.from('blog_images').upload(id, image);

      final bannerUrl = await _client.storage
          .from('blog_images')
          .createSignedUrl(id, 60 * 60 * 24 * 365);

      return right(bannerUrl);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
