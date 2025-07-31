import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/post.dart';
import '../providers/auth_provider.dart';
import '../providers/post_provider.dart';
import '../utils/constants.dart';
import '../widgets/custom_button.dart';
import '../widgets/post_card.dart';
import 'create_post_screen.dart';
import 'post_detail_screen.dart';

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  @override
  void initState() {
    super.initState();
    _loadMyPosts();
  }

  void _loadMyPosts() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final postProvider = Provider.of<PostProvider>(context, listen: false);

    if (authProvider.currentUser != null) {
      postProvider.loadMyPosts(authProvider.currentUser!.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(AppStrings.myPosts),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.surface,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadMyPosts),
        ],
      ),
      body: Consumer<PostProvider>(
        builder: (context, postProvider, child) {
          if (postProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (postProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    postProvider.error!,
                    style: AppTextStyles.body1.copyWith(color: AppColors.error),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppDimensions.paddingMedium),
                  CustomButton(
                    text: 'Retry',
                    onPressed: _loadMyPosts,
                    isOutlined: true,
                  ),
                ],
              ),
            );
          }

          if (postProvider.myPosts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.post_add,
                    size: 80,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(height: AppDimensions.paddingMedium),
                  Text(
                    AppStrings.noPostsFound,
                    style: AppTextStyles.heading3.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.paddingSmall),
                  Text(
                    'Create your first post to get started!',
                    style: AppTextStyles.body2,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppDimensions.paddingLarge),
                  CustomButton(
                    text: AppStrings.createPost,
                    onPressed: () => _navigateToCreatePost(),
                    icon: Icons.add,
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => _loadMyPosts(),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(
                vertical: AppDimensions.paddingSmall,
              ),
              itemCount: postProvider.myPosts.length,
              itemBuilder: (context, index) {
                final post = postProvider.myPosts[index];
                return PostCard(
                  post: post,
                  onTap: () => _navigateToPostDetail(post),
                  onEdit: () => _navigateToEditPost(post),
                  onDelete: () => _deletePost(post),
                  onComplete: () => _completePost(post),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToCreatePost,
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.surface,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _navigateToCreatePost() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const CreatePostScreen()));
  }

  void _navigateToPostDetail(Post post) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => PostDetailScreen(post: post)),
    );
  }

  void _navigateToEditPost(Post post) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => CreatePostScreen(post: post)),
    );
  }

  void _deletePost(Post post) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Post'),
        content: const Text('Are you sure you want to delete this post?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              final postProvider = Provider.of<PostProvider>(
                context,
                listen: false,
              );
              await postProvider.deletePost(post.id);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Post deleted successfully'),
                    backgroundColor: AppColors.success,
                  ),
                );
              }
            },
            child: const Text(
              AppStrings.delete,
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  void _completePost(Post post) {
    // This will be handled in the post detail screen where offers are shown
    _navigateToPostDetail(post);
  }
}
