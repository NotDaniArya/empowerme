import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_empowerme/user_features/komunitas/data/datasources/komunitas_remote_datasource.dart';
import 'package:new_empowerme/user_features/komunitas/data/repositories/komunitas_repository_impl.dart';
import 'package:new_empowerme/user_features/komunitas/domain/entities/comment.dart';
import 'package:new_empowerme/user_features/komunitas/domain/entities/komunitas.dart';
import 'package:new_empowerme/user_features/komunitas/domain/repositories/komunitas_repository.dart';
import 'package:new_empowerme/utils/shared_providers/provider.dart';

// ===================================
// State Postingan Komunitas
// ===================================

class KomunitasState {
  final List<Komunitas>? communityPosts;
  final bool isLoading;
  final String? error;

  KomunitasState({
    this.communityPosts = const [],
    this.isLoading = false,
    this.error,
  });

  KomunitasState copyWith({
    List<Komunitas>? communityPosts,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return KomunitasState(
      communityPosts: communityPosts ?? this.communityPosts,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

final komunitasRemoteDataSourceProvider = Provider<KomunitasRemoteDataSource>(
  (ref) => KomunitasRemoteDataSourceImpl(ref.watch(dioProvider)),
);

final komunitasRepositoryProvider = Provider<KomunitasRepository>(
  (ref) =>
      KomunitasRepositoryImpl(ref.watch(komunitasRemoteDataSourceProvider)),
);

class KomunitasViewModel extends Notifier<KomunitasState> {
  @override
  KomunitasState build() {
    _fetchPostinganKomunitas();
    return KomunitasState(isLoading: true);
  }

  KomunitasRepository get _repository => ref.read(komunitasRepositoryProvider);

  Future<void> _fetchPostinganKomunitas() async {
    final (postinganKomunitas, failure) = await _repository.getCommunityPosts();

    if (failure != null) {
      state = state.copyWith(isLoading: false, error: failure.message);
    } else {
      final posts = postinganKomunitas ?? [];

      posts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      state = state.copyWith(communityPosts: posts, isLoading: false);
    }
  }

  Future<void> refresh() async {
    state = state.copyWith(isLoading: true);
    await _fetchPostinganKomunitas();
  }

  Future<void> likeCommunityPost({required String id}) async {
    final originalState = state;
    final posts = state.communityPosts ?? [];

    final updatedPosts = [
      for (final post in posts)
        if (post.id == id)
          post.copyWith(statusLike: true, like: post.like + 1)
        else
          post,
    ];
    state = state.copyWith(communityPosts: updatedPosts);

    try {
      final (_, failure) = await _repository.likeCommunityPost(id: id);
      if (failure != null) {
        throw failure;
      }
    } catch (e) {
      state = originalState;
      print("Gagal menyukai postingan: $e");
    }
  }

  Future<void> unLikeCommunityPost({required String id}) async {
    final originalState = state;
    final posts = state.communityPosts ?? [];

    final updatedPosts = [
      for (final post in posts)
        if (post.id == id)
          post.copyWith(statusLike: false, like: post.like - 1)
        else
          post,
    ];
    state = state.copyWith(communityPosts: updatedPosts);

    try {
      final (_, failure) = await _repository.unLikeCommunityPost(id: id);
      if (failure != null) {
        throw failure;
      }
    } catch (e) {
      state = originalState;
      print("Gagal tidak menyukai postingan: $e");
    }
  }
}

final komunitasViewModel = NotifierProvider<KomunitasViewModel, KomunitasState>(
  () => KomunitasViewModel(),
);

// ===================================
// State Postingan Komunitas
// ===================================

class CommentState {
  final List<Comment>? commentCommunity;
  final bool isLoading;
  final String? error;

  CommentState({
    this.commentCommunity = const [],
    this.isLoading = false,
    this.error,
  });

  CommentState copyWith({
    List<Comment>? commentCommunity,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return CommentState(
      commentCommunity: commentCommunity ?? this.commentCommunity,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class CommentViewModel extends FamilyNotifier<CommentState, String> {
  @override
  CommentState build(String id) {
    _fetchCommentKomunitas();
    return CommentState(isLoading: true);
  }

  Future<void> _fetchCommentKomunitas() async {
    final (commentKomunitas, failure) = await ref
        .read(komunitasRepositoryProvider)
        .getCommunityComment(id: arg);

    if (failure != null) {
      state = state.copyWith(isLoading: false, error: failure.message);
    } else {
      state = state.copyWith(
        commentCommunity: commentKomunitas,
        isLoading: false,
      );
    }
  }
}

final commentViewModel =
    NotifierProvider.family<CommentViewModel, CommentState, String>(
      () => CommentViewModel(),
    );

// ==========================================
// provider menangani create, read, updater
// ==========================================

class KomunitasUpdater extends Notifier<void> {
  @override
  void build() {}

  KomunitasRepository get _repository => ref.read(komunitasRepositoryProvider);

  Future<void> postCommunity({
    required String content,
    required VoidCallback onSuccess,
    required Function(String) onError,
  }) async {
    final (_, failure) = await _repository.postCommunityPosts(content: content);

    if (failure != null) {
      onError(failure.message);
    } else {
      ref.invalidate(komunitasViewModel);
      ref.invalidate(commentViewModel);

      onSuccess();
    }
  }

  Future<void> addComment({
    required String id,
    required String comment,
    required VoidCallback onSuccess,
    required Function(String) onError,
  }) async {
    final (_, failure) = await _repository.addComment(id: id, comment: comment);

    if (failure != null) {
      onError(failure.message);
    } else {
      ref.invalidate(komunitasViewModel);
      ref.invalidate(commentViewModel);

      onSuccess();
    }
  }

  Future<void> addReplyComment({
    required String id,
    required String comment,
    required VoidCallback onSuccess,
    required Function(String) onError,
  }) async {
    final (_, failure) = await _repository.addReplyComment(
      id: id,
      comment: comment,
    );

    if (failure != null) {
      onError(failure.message);
    } else {
      ref.invalidate(komunitasViewModel);
      ref.invalidate(commentViewModel);

      onSuccess();
    }
  }
}

final komunitasUpdaterProvider = NotifierProvider<KomunitasUpdater, void>(
  () => KomunitasUpdater(),
);
