import 'package:flutter/material.dart';
import '../models/post.dart';
import '../utils/constants.dart';

class PostCard extends StatelessWidget {
  final Post post;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onComplete;
  final bool showActions;

  const PostCard({
    super.key,
    required this.post,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.onComplete,
    this.showActions = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimensions.marginMedium,
        vertical: AppDimensions.marginSmall,
      ),
      elevation: AppDimensions.elevationSmall,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
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
                      post.customerName[0].toUpperCase(),
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
                          post.customerName,
                          style: AppTextStyles.body1.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          _formatDate(post.createdAt),
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ),
                  if (post.status == PostStatus.completed)
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
              Text(post.title, style: AppTextStyles.heading3),
              const SizedBox(height: AppDimensions.paddingSmall),
              Text(
                post.description,
                style: AppTextStyles.body2,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              if (showActions) ...[
                const SizedBox(height: AppDimensions.paddingMedium),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (post.status == PostStatus.active && onEdit != null)
                      IconButton(
                        onPressed: onEdit,
                        icon: const Icon(Icons.edit, color: AppColors.primary),
                        tooltip: 'Edit',
                      ),
                    if (post.status == PostStatus.active && onDelete != null)
                      IconButton(
                        onPressed: onDelete,
                        icon: const Icon(Icons.delete, color: AppColors.error),
                        tooltip: 'Delete',
                      ),
                    if (post.status == PostStatus.active && onComplete != null)
                      IconButton(
                        onPressed: onComplete,
                        icon: const Icon(
                          Icons.check_circle,
                          color: AppColors.success,
                        ),
                        tooltip: 'Complete',
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
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
