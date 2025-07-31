import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/offer.dart';
import '../services/phone_service.dart';
import '../utils/constants.dart';
import 'custom_button.dart';

class OfferCard extends StatelessWidget {
  final Offer offer;
  final VoidCallback? onSelect;
  final bool isSelected;
  final bool showSelectButton;

  const OfferCard({
    super.key,
    required this.offer,
    this.onSelect,
    this.isSelected = false,
    this.showSelectButton = true,
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
        side: isSelected
            ? const BorderSide(color: AppColors.primary, width: 2)
            : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.accent,
                  child: Text(
                    offer.sellerName[0].toUpperCase(),
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
                        offer.sellerName,
                        style: AppTextStyles.body1.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        _formatDate(offer.createdAt),
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  const Icon(
                    Icons.check_circle,
                    color: AppColors.primary,
                    size: 24,
                  ),
              ],
            ),
            const SizedBox(height: AppDimensions.paddingMedium),
            Text(
              'Tsh ${offer.price.toStringAsFixed(2)}',
              style: AppTextStyles.heading2.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppDimensions.paddingSmall),
            Text(offer.description, style: AppTextStyles.body2),
            if (offer.images.isNotEmpty) ...[
              const SizedBox(height: AppDimensions.paddingMedium),
              SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: offer.images.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 120,
                      margin: const EdgeInsets.only(
                        right: AppDimensions.paddingSmall,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusSmall,
                        ),
                        border: Border.all(color: AppColors.divider),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusSmall,
                        ),
                        child: CachedNetworkImage(
                          imageUrl: offer.images[index],
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: AppColors.background,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: AppColors.background,
                            child: const Icon(Icons.error),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
            const SizedBox(height: AppDimensions.paddingMedium),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: AppStrings.callSeller,
                    onPressed: () => _makePhoneCall(context),
                    icon: Icons.phone,
                    backgroundColor: AppColors.accent,
                    textColor: AppColors.surface,
                  ),
                ),
                if (showSelectButton) ...[
                  const SizedBox(width: AppDimensions.paddingMedium),
                  Expanded(
                    child: CustomButton(
                      text: isSelected ? 'Selected' : AppStrings.selectOffer,
                      onPressed: onSelect,
                      isOutlined: !isSelected,
                      backgroundColor: isSelected
                          ? AppColors.success
                          : AppColors.primary,
                      textColor: isSelected
                          ? AppColors.surface
                          : AppColors.primary,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _makePhoneCall(BuildContext context) async {
    final success = await PhoneService.makePhoneCall(offer.sellerPhone);
    if (!success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not make phone call'),
          backgroundColor: AppColors.error,
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
