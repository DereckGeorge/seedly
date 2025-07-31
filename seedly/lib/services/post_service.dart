import '../models/post.dart';
import '../models/offer.dart';
import 'auth_service.dart';

class PostService {
  static final Map<String, Post> _posts = {};
  static final Map<String, List<Offer>> _offers = {};

  // Create new post
  static Future<bool> createPost({
    required String title,
    required String description,
  }) async {
    try {
      final currentUser = AuthService.currentUser;
      if (currentUser == null) throw Exception('User not logged in');

      final post = Post(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        customerId: currentUser.id,
        customerName: currentUser.username,
        title: title,
        description: description,
        status: PostStatus.active,
        createdAt: DateTime.now(),
      );

      _posts[post.id] = post;
      _offers[post.id] = [];

      return true;
    } catch (e) {
      print('Create post error: $e');
      return false;
    }
  }

  // Get all active posts (for sellers to browse)
  static List<Post> getActivePosts() {
    return _posts.values
        .where((post) => post.status == PostStatus.active)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  // Get posts by customer ID
  static List<Post> getPostsByCustomerId(String customerId) {
    return _posts.values.where((post) => post.customerId == customerId).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  // Get post by ID
  static Post? getPostById(String postId) {
    return _posts[postId];
  }

  // Search posts by title or description
  static List<Post> searchPosts(String query) {
    final lowercaseQuery = query.toLowerCase();
    return _posts.values
        .where(
          (post) =>
              post.status == PostStatus.active &&
              (post.title.toLowerCase().contains(lowercaseQuery) ||
                  post.description.toLowerCase().contains(lowercaseQuery)),
        )
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  // Complete post (mark as completed)
  static Future<bool> completePost({
    required String postId,
    required String selectedOfferId,
  }) async {
    try {
      final post = _posts[postId];
      if (post == null) throw Exception('Post not found');

      final updatedPost = post.copyWith(
        status: PostStatus.completed,
        completedAt: DateTime.now(),
        selectedOfferId: selectedOfferId,
      );

      _posts[postId] = updatedPost;

      return true;
    } catch (e) {
      print('Complete post error: $e');
      return false;
    }
  }

  // Update post
  static Future<bool> updatePost({
    required String postId,
    String? title,
    String? description,
  }) async {
    try {
      final post = _posts[postId];
      if (post == null) throw Exception('Post not found');

      final updatedPost = post.copyWith(
        title: title ?? post.title,
        description: description ?? post.description,
      );

      _posts[postId] = updatedPost;

      return true;
    } catch (e) {
      print('Update post error: $e');
      return false;
    }
  }

  // Delete post
  static Future<bool> deletePost(String postId) async {
    try {
      _posts.remove(postId);
      _offers.remove(postId);
      return true;
    } catch (e) {
      print('Delete post error: $e');
      return false;
    }
  }

  // Get offers for a post
  static List<Offer> getOffersForPost(String postId) {
    return _offers[postId] ?? [];
  }

  // Add offer to post
  static Future<bool> addOffer({
    required String postId,
    required double price,
    required String description,
    required List<String> images,
  }) async {
    try {
      final currentUser = AuthService.currentUser;
      if (currentUser == null) throw Exception('User not logged in');

      final offer = Offer(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        postId: postId,
        sellerId: currentUser.id,
        sellerName: currentUser.username,
        sellerPhone: currentUser.phone,
        price: price,
        description: description,
        images: images,
        createdAt: DateTime.now(),
      );

      if (_offers[postId] == null) {
        _offers[postId] = [];
      }
      _offers[postId]!.add(offer);

      return true;
    } catch (e) {
      print('Add offer error: $e');
      return false;
    }
  }
}
