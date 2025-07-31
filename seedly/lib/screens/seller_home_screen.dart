import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/post.dart';
import '../providers/post_provider.dart';
import '../utils/constants.dart';
import '../widgets/post_card.dart';
import '../widgets/custom_button.dart';
import 'post_detail_screen.dart';

class SellerHomeScreen extends StatefulWidget {
  const SellerHomeScreen({super.key});

  @override
  State<SellerHomeScreen> createState() => _SellerHomeScreenState();
}

class _SellerHomeScreenState extends State<SellerHomeScreen> {
  final _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadActivePosts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadActivePosts() {
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    postProvider.loadActivePosts();
  }

  void _searchPosts(String query) {
    if (query.trim().isEmpty) {
      _loadActivePosts();
      setState(() {
        _isSearching = false;
      });
    } else {
      final postProvider = Provider.of<PostProvider>(context, listen: false);
      postProvider.searchPosts(query.trim());
      setState(() {
        _isSearching = true;
      });
    }
  }

  void _clearSearch() {
    _searchController.clear();
    _loadActivePosts();
    setState(() {
      _isSearching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(_isSearching ? 'Search Results' : AppStrings.search),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.surface,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadActivePosts,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(AppDimensions.paddingMedium),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search posts...',
                      prefixIcon: const Icon(
                        Icons.search,
                        color: AppColors.primary,
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: _clearSearch,
                            )
                          : null,
                      filled: true,
                      fillColor: AppColors.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusMedium,
                        ),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.paddingMedium,
                        vertical: AppDimensions.paddingMedium,
                      ),
                    ),
                    onChanged: _searchPosts,
                    onSubmitted: _searchPosts,
                  ),
                ),
              ],
            ),
          ),

          // Posts List
          Expanded(
            child: Consumer<PostProvider>(
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
                          style: AppTextStyles.body1.copyWith(
                            color: AppColors.error,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppDimensions.paddingMedium),
                        CustomButton(
                          text: 'Retry',
                          onPressed: _loadActivePosts,
                          isOutlined: true,
                        ),
                      ],
                    ),
                  );
                }

                if (postProvider.activePosts.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _isSearching ? Icons.search_off : Icons.post_add,
                          size: 80,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(height: AppDimensions.paddingMedium),
                        Text(
                          _isSearching
                              ? 'No posts found for your search'
                              : AppStrings.noPostsFound,
                          style: AppTextStyles.heading3.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.paddingSmall),
                        Text(
                          _isSearching
                              ? 'Try different keywords'
                              : 'No active posts at the moment',
                          style: AppTextStyles.body2,
                          textAlign: TextAlign.center,
                        ),
                        if (!_isSearching) ...[
                          const SizedBox(height: AppDimensions.paddingLarge),
                          CustomButton(
                            text: 'Refresh',
                            onPressed: _loadActivePosts,
                            icon: Icons.refresh,
                          ),
                        ],
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async => _loadActivePosts(),
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppDimensions.paddingSmall,
                    ),
                    itemCount: postProvider.activePosts.length,
                    itemBuilder: (context, index) {
                      final post = postProvider.activePosts[index];
                      return PostCard(
                        post: post,
                        onTap: () => _navigateToPostDetail(post),
                        showActions: false, // Sellers can't edit/delete posts
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToPostDetail(Post post) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => PostDetailScreen(post: post)),
    );
  }
}
