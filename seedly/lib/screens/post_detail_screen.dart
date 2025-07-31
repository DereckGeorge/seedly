import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/post.dart';
import '../models/offer.dart';
import '../providers/post_provider.dart';
import '../utils/constants.dart';
import '../widgets/offer_card.dart';
import '../widgets/custom_button.dart';
import 'add_offer_screen.dart';

class PostDetailScreen extends StatefulWidget {
  final Post post;

  const PostDetailScreen({super.key, required this.post});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  String? _selectedOfferId;

  @override
  void initState() {
    super.initState();
    _loadPostOffers();
  }

  void _loadPostOffers() {
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    postProvider.selectPost(widget.post.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Post Details'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.surface,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadPostOffers,
          ),
        ],
      ),
      body: Consumer<PostProvider>(
        builder: (context, postProvider, child) {
          if (postProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final selectedPost = postProvider.selectedPost;
          if (selectedPost == null) {
            return const Center(child: Text('Post not found'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimensions.paddingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Post Details Card
                Card(
                  elevation: AppDimensions.elevationSmall,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusMedium,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: AppColors.primary,
                              child: Text(
                                selectedPost.customerName[0].toUpperCase(),
                                style: const TextStyle(
                                  color: AppColors.surface,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: AppDimensions.paddingMedium),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    selectedPost.customerName,
                                    style: AppTextStyles.body1.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    _formatDate(selectedPost.createdAt),
                                    style: AppTextStyles.caption,
                                  ),
                                ],
                              ),
                            ),
                            if (selectedPost.status == PostStatus.completed)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppDimensions.paddingSmall,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.success,
                                  borderRadius: BorderRadius.circular(
                                    AppDimensions.radiusSmall,
                                  ),
                                ),
                                child: const Text(
                                  'Completed',
                                  style: TextStyle(
                                    color: AppColors.surface,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: AppDimensions.paddingMedium),
                        Text(selectedPost.title, style: AppTextStyles.heading3),
                        const SizedBox(height: AppDimensions.paddingSmall),
                        Text(
                          selectedPost.description,
                          style: AppTextStyles.body2,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingLarge),

                // Offers Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Offers (${postProvider.currentPostOffers.length})',
                      style: AppTextStyles.heading3,
                    ),
                    if (selectedPost.status == PostStatus.active)
                      CustomButton(
                        text: AppStrings.addOffer,
                        onPressed: () => _navigateToAddOffer(),
                        isOutlined: false,
                        icon: Icons.add,
                        backgroundColor: AppColors.primary,
                        textColor: AppColors.surface,
                      ),
                  ],
                ),
                const SizedBox(height: AppDimensions.paddingMedium),

                // Offers List
                if (postProvider.currentPostOffers.isEmpty)
                  Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.offline_bolt,
                          size: 60,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(height: AppDimensions.paddingMedium),
                        Text(
                          AppStrings.noOffersFound,
                          style: AppTextStyles.heading3.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.paddingSmall),
                        Text(
                          'No offers yet. Check back later!',
                          style: AppTextStyles.body2,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: postProvider.currentPostOffers.length,
                    itemBuilder: (context, index) {
                      final offer = postProvider.currentPostOffers[index];
                      final isSelected = _selectedOfferId == offer.id;

                      return OfferCard(
                        offer: offer,
                        isSelected: isSelected,
                        showSelectButton:
                            selectedPost.status == PostStatus.active,
                        onSelect: () {
                          setState(() {
                            _selectedOfferId = isSelected ? null : offer.id;
                          });
                        },
                      );
                    },
                  ),

                // Complete Post Button (only for active posts with offers)
                if (selectedPost.status == PostStatus.active &&
                    postProvider.currentPostOffers.isNotEmpty &&
                    _selectedOfferId != null)
                  Padding(
                    padding: const EdgeInsets.only(
                      top: AppDimensions.paddingLarge,
                    ),
                    child: CustomButton(
                      text: AppStrings.completePost,
                      onPressed: () => _completePost(),
                      backgroundColor: AppColors.success,
                      icon: Icons.check_circle,
                      textColor: AppColors.surface,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _navigateToAddOffer() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddOfferScreen(post: widget.post),
      ),
    );
  }

  void _completePost() async {
    if (_selectedOfferId == null) return;

    final postProvider = Provider.of<PostProvider>(context, listen: false);
    final success = await postProvider.completePost(
      postId: widget.post.id,
      selectedOfferId: _selectedOfferId!,
    );

    if (success && mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Post completed successfully!'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }
}
