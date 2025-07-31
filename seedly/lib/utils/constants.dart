import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF4CAF50);
  static const Color primaryDark = Color(0xFF388E3C);
  static const Color primaryLight = Color(0xFF81C784);
  static const Color accent = Color(0xFFFF9800);
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color divider = Color(0xFFBDBDBD);
  static const Color error = Color(0xFFD32F2F);
  static const Color success = Color(0xFF388E3C);
  static const Color warning = Color(0xFFFFA000);
}

class AppTextStyles {
  static const TextStyle heading1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle heading3 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle body1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  static const TextStyle body2 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );

  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.surface,
  );
}

class AppDimensions {
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;

  static const double marginSmall = 8.0;
  static const double marginMedium = 16.0;
  static const double marginLarge = 24.0;
  static const double marginXLarge = 32.0;

  static const double radiusSmall = 4.0;
  static const double radiusMedium = 8.0;
  static const double radiusLarge = 12.0;
  static const double radiusXLarge = 16.0;

  static const double elevationSmall = 2.0;
  static const double elevationMedium = 4.0;
  static const double elevationLarge = 8.0;
}

class AppStrings {
  // App
  static const String appName = 'Seedly';
  static const String appTagline = 'Find what you need, get the best offers';

  // Authentication
  static const String login = 'Login';
  static const String register = 'Register';
  static const String logout = 'Logout';
  static const String phone = 'Phone';
  static const String username = 'Username';
  static const String password = 'Password';
  static const String confirmPassword = 'Confirm Password';
  static const String customer = 'Customer';
  static const String seller = 'Seller';

  // Posts
  static const String createPost = 'Create Post';
  static const String editPost = 'Edit Post';
  static const String deletePost = 'Delete Post';
  static const String completePost = 'Complete Post';
  static const String title = 'Title';
  static const String description = 'Description';
  static const String whatDoYouNeed = 'What do you need?';
  static const String describeYourRequest =
      'Describe your request in detail...';

  // Offers
  static const String addOffer = 'Add Offer';
  static const String editOffer = 'Edit Offer';
  static const String price = 'Price (Tsh)';
  static const String offerDescription = 'Offer Description';
  static const String addImages = 'Add Images';
  static const String selectOffer = 'Select Offer';
  static const String callSeller = 'Call Seller';

  // Navigation
  static const String home = 'Home';
  static const String myPosts = 'My Posts';
  static const String history = 'History';
  static const String profile = 'Profile';
  static const String search = 'Search';

  // Messages
  static const String noPostsFound = 'No posts found';
  static const String noOffersFound = 'No offers found';
  static const String loading = 'Loading...';
  static const String error = 'Error';
  static const String success = 'Success';
  static const String cancel = 'Cancel';
  static const String save = 'Save';
  static const String delete = 'Delete';
  static const String yes = 'Yes';
  static const String no = 'No';
}
