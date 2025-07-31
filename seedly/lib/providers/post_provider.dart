import 'package:flutter/foundation.dart';
import '../models/post.dart';
import '../models/offer.dart';
import '../services/post_service.dart';

class PostProvider with ChangeNotifier {
  List<Post> _activePosts = [];
  List<Post> _myPosts = [];
  List<Offer> _currentPostOffers = [];
  Post? _selectedPost;
  bool _isLoading = false;
  String? _error;

  List<Post> get activePosts => _activePosts;
  List<Post> get myPosts => _myPosts;
  List<Offer> get currentPostOffers => _currentPostOffers;
  Post? get selectedPost => _selectedPost;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Load active posts (for sellers)
  Future<void> loadActivePosts() async {
    _setLoading(true);
    _clearError();

    try {
      _activePosts = PostService.getActivePosts();
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Load my posts (for customers)
  Future<void> loadMyPosts(String customerId) async {
    _setLoading(true);
    _clearError();

    try {
      _myPosts = PostService.getPostsByCustomerId(customerId);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Create new post
  Future<bool> createPost({
    required String title,
    required String description,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final success = await PostService.createPost(
        title: title,
        description: description,
      );

      if (success) {
        // Refresh posts
        await loadActivePosts();
        return true;
      } else {
        _setError('Failed to create post');
        return false;
      }
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Select post and load its offers
  Future<void> selectPost(String postId) async {
    _setLoading(true);
    _clearError();

    try {
      _selectedPost = PostService.getPostById(postId);
      if (_selectedPost != null) {
        _currentPostOffers = PostService.getOffersForPost(postId);
      }
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Add offer to post
  Future<bool> addOffer({
    required String postId,
    required double price,
    required String description,
    required List<String> images,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final success = await PostService.addOffer(
        postId: postId,
        price: price,
        description: description,
        images: images,
      );

      if (success) {
        // Refresh offers for the current post
        if (_selectedPost?.id == postId) {
          _currentPostOffers = PostService.getOffersForPost(postId);
        }
        notifyListeners();
        return true;
      } else {
        _setError('Failed to add offer');
        return false;
      }
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Complete post
  Future<bool> completePost({
    required String postId,
    required String selectedOfferId,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final success = await PostService.completePost(
        postId: postId,
        selectedOfferId: selectedOfferId,
      );

      if (success) {
        // Refresh posts
        await loadActivePosts();
        await loadMyPosts(_selectedPost?.customerId ?? '');
        return true;
      } else {
        _setError('Failed to complete post');
        return false;
      }
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Search posts
  Future<void> searchPosts(String query) async {
    _setLoading(true);
    _clearError();

    try {
      _activePosts = PostService.searchPosts(query);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Update post
  Future<bool> updatePost({
    required String postId,
    String? title,
    String? description,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final success = await PostService.updatePost(
        postId: postId,
        title: title,
        description: description,
      );

      if (success) {
        // Refresh posts
        await loadActivePosts();
        await loadMyPosts(_selectedPost?.customerId ?? '');
        return true;
      } else {
        _setError('Failed to update post');
        return false;
      }
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Delete post
  Future<bool> deletePost(String postId) async {
    _setLoading(true);
    _clearError();

    try {
      final success = await PostService.deletePost(postId);

      if (success) {
        // Refresh posts
        await loadActivePosts();
        await loadMyPosts(_selectedPost?.customerId ?? '');
        return true;
      } else {
        _setError('Failed to delete post');
        return false;
      }
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Clear selected post
  void clearSelectedPost() {
    _selectedPost = null;
    _currentPostOffers = [];
    notifyListeners();
  }

  // Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }
}
