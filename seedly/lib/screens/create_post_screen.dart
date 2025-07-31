import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/post.dart';
import '../providers/post_provider.dart';
import '../utils/constants.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class CreatePostScreen extends StatefulWidget {
  final Post? post; // If provided, we're editing an existing post

  const CreatePostScreen({super.key, this.post});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.post != null) {
      _titleController.text = widget.post!.title;
      _descriptionController.text = widget.post!.description;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _savePost() async {
    if (_formKey.currentState!.validate()) {
      final postProvider = Provider.of<PostProvider>(context, listen: false);
      bool success;

      if (widget.post != null) {
        // Update existing post
        success = await postProvider.updatePost(
          postId: widget.post!.id,
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
        );
      } else {
        // Create new post
        success = await postProvider.createPost(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
        );
      }

      if (success && mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.post != null
                  ? 'Post updated successfully'
                  : 'Post created successfully',
            ),
            backgroundColor: AppColors.success,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.post != null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(isEditing ? AppStrings.editPost : AppStrings.createPost),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.surface,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.paddingLarge),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Icon(Icons.post_add, size: 60, color: AppColors.primary),
                const SizedBox(height: AppDimensions.paddingMedium),
                Text(
                  isEditing ? AppStrings.editPost : AppStrings.createPost,
                  style: AppTextStyles.heading2,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppDimensions.paddingSmall),
                Text(
                  AppStrings.whatDoYouNeed,
                  style: AppTextStyles.body2,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppDimensions.paddingXLarge),

                // Title Field
                CustomTextField(
                  label: AppStrings.title,
                  hint: 'e.g., I want an iPhone 16',
                  controller: _titleController,
                  isRequired: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Title is required';
                    }
                    if (value.length < 5) {
                      return 'Title must be at least 5 characters';
                    }
                    return null;
                  },
                  prefixIcon: const Icon(Icons.title, color: AppColors.primary),
                ),
                const SizedBox(height: AppDimensions.paddingMedium),

                // Description Field
                CustomTextField(
                  label: AppStrings.description,
                  hint: AppStrings.describeYourRequest,
                  controller: _descriptionController,
                  maxLines: 5,
                  isRequired: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Description is required';
                    }
                    if (value.length < 10) {
                      return 'Description must be at least 10 characters';
                    }
                    return null;
                  },
                  prefixIcon: const Icon(
                    Icons.description,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingXLarge),

                // Save Button
                Consumer<PostProvider>(
                  builder: (context, postProvider, child) {
                    return CustomButton(
                      text: isEditing ? AppStrings.save : AppStrings.createPost,
                      onPressed: postProvider.isLoading ? null : _savePost,
                      isLoading: postProvider.isLoading,
                      icon: isEditing ? Icons.save : Icons.add,
                    );
                  },
                ),
                const SizedBox(height: AppDimensions.paddingMedium),

                // Error Message
                Consumer<PostProvider>(
                  builder: (context, postProvider, child) {
                    if (postProvider.error != null) {
                      return Container(
                        padding: const EdgeInsets.all(
                          AppDimensions.paddingMedium,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.error.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusMedium,
                          ),
                          border: Border.all(color: AppColors.error),
                        ),
                        child: Text(
                          postProvider.error!,
                          style: AppTextStyles.body2.copyWith(
                            color: AppColors.error,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
