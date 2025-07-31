import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../providers/auth_provider.dart';
import '../providers/post_provider.dart';
import '../utils/constants.dart';
import 'customer_home_screen.dart';
import 'seller_home_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final postProvider = Provider.of<PostProvider>(context, listen: false);

    if (authProvider.currentUser != null) {
      if (authProvider.currentUser!.userType == UserType.customer) {
        postProvider.loadMyPosts(authProvider.currentUser!.id);
      } else {
        postProvider.loadActivePosts();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (!authProvider.isLoggedIn) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = authProvider.currentUser!;
        final isCustomer = user.userType == UserType.customer;

        return Scaffold(
          body: IndexedStack(
            index: _currentIndex,
            children: [
              isCustomer
                  ? const CustomerHomeScreen()
                  : const SellerHomeScreen(),
              const ProfileScreen(),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            selectedItemColor: AppColors.primary,
            unselectedItemColor: AppColors.textSecondary,
            items: [
              BottomNavigationBarItem(
                icon: Icon(isCustomer ? Icons.home : Icons.search),
                label: isCustomer ? AppStrings.myPosts : AppStrings.search,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.person),
                label: AppStrings.profile,
              ),
            ],
          ),
        );
      },
    );
  }
}
