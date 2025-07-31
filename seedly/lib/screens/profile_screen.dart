import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../providers/auth_provider.dart';
import '../utils/constants.dart';
import '../widgets/custom_button.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(AppStrings.profile),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.surface,
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          if (!authProvider.isLoggedIn) {
            return const Center(child: CircularProgressIndicator());
          }

          final user = authProvider.currentUser!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimensions.paddingLarge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Profile Header
                Card(
                  elevation: AppDimensions.elevationSmall,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusMedium,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(AppDimensions.paddingLarge),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: AppColors.primary,
                          child: Text(
                            user.username[0].toUpperCase(),
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: AppColors.surface,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppDimensions.paddingMedium),
                        Text(user.username, style: AppTextStyles.heading2),
                        const SizedBox(height: AppDimensions.paddingSmall),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppDimensions.paddingMedium,
                            vertical: AppDimensions.paddingSmall,
                          ),
                          decoration: BoxDecoration(
                            color: user.userType == UserType.customer
                                ? AppColors.primary.withOpacity(0.1)
                                : AppColors.accent.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(
                              AppDimensions.radiusMedium,
                            ),
                            border: Border.all(
                              color: user.userType == UserType.customer
                                  ? AppColors.primary
                                  : AppColors.accent,
                            ),
                          ),
                          child: Text(
                            user.userType == UserType.customer
                                ? AppStrings.customer
                                : AppStrings.seller,
                            style: AppTextStyles.body2.copyWith(
                              color: user.userType == UserType.customer
                                  ? AppColors.primary
                                  : AppColors.accent,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingLarge),

                // Profile Information
                Card(
                  elevation: AppDimensions.elevationSmall,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusMedium,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(AppDimensions.paddingLarge),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Profile Information',
                          style: AppTextStyles.heading3,
                        ),
                        const SizedBox(height: AppDimensions.paddingMedium),

                        _buildInfoRow('Username', user.username),
                        const Divider(),
                        _buildInfoRow('Phone', user.phone),
                        const Divider(),
                        _buildInfoRow(
                          'User Type',
                          user.userType == UserType.customer
                              ? AppStrings.customer
                              : AppStrings.seller,
                        ),
                        const Divider(),
                        _buildInfoRow(
                          'Member Since',
                          _formatDate(user.createdAt),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingLarge),

                // Actions
                Card(
                  elevation: AppDimensions.elevationSmall,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusMedium,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(AppDimensions.paddingLarge),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Actions', style: AppTextStyles.heading3),
                        const SizedBox(height: AppDimensions.paddingMedium),

                        ListTile(
                          leading: const Icon(
                            Icons.edit,
                            color: AppColors.primary,
                          ),
                          title: const Text('Edit Profile'),
                          subtitle: const Text(
                            'Update your profile information',
                          ),
                          onTap: () {
                            // TODO: Implement edit profile functionality
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Edit profile feature coming soon!',
                                ),
                              ),
                            );
                          },
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(
                            Icons.security,
                            color: AppColors.primary,
                          ),
                          title: const Text('Change Password'),
                          subtitle: const Text('Update your password'),
                          onTap: () {
                            // TODO: Implement change password functionality
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Change password feature coming soon!',
                                ),
                              ),
                            );
                          },
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(
                            Icons.help,
                            color: AppColors.primary,
                          ),
                          title: const Text('Help & Support'),
                          subtitle: const Text('Get help and contact support'),
                          onTap: () {
                            // TODO: Implement help and support functionality
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Help & support feature coming soon!',
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingLarge),

                // Logout Button
                CustomButton(
                  text: AppStrings.logout,
                  onPressed: () => _showLogoutDialog(context),
                  backgroundColor: AppColors.error,
                  icon: Icons.logout,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingSmall),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: AppTextStyles.body2.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(child: Text(value, style: AppTextStyles.body1)),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _logout(context);
            },
            child: const Text(
              AppStrings.logout,
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  void _logout(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.logout();

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
