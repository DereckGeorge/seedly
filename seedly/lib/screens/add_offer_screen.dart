import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../models/post.dart';
import '../providers/post_provider.dart';
import '../utils/constants.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class AddOfferScreen extends StatefulWidget {
  final Post post;

  const AddOfferScreen({super.key, required this.post});

  @override
  State<AddOfferScreen> createState() => _AddOfferScreenState();
}

class _AddOfferScreenState extends State<AddOfferScreen> {
  final _formKey = GlobalKey<FormState>();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final List<File> _images = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _addOffer() async {
    if (_formKey.currentState!.validate()) {
      final postProvider = Provider.of<PostProvider>(context, listen: false);

      // Convert File objects to base64 strings for demo
      // In a real app, you would upload these to a server
      final imageUrls = _images.map((file) => file.path).toList();

      final success = await postProvider.addOffer(
        postId: widget.post.id,
        price: double.parse(_priceController.text),
        description: _descriptionController.text.trim(),
        images: imageUrls,
      );

      if (success && mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Offer added successfully!'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _images.add(File(image.path));
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking image: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(AppStrings.addOffer),
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
                Icon(Icons.offline_bolt, size: 60, color: AppColors.accent),
                const SizedBox(height: AppDimensions.paddingMedium),
                Text(
                  AppStrings.addOffer,
                  style: AppTextStyles.heading2,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppDimensions.paddingSmall),
                Text(
                  'Make an offer for: ${widget.post.title}',
                  style: AppTextStyles.body2,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppDimensions.paddingXLarge),

                // Price Field
                CustomTextField(
                  label: AppStrings.price,
                  hint: '0.00',
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  isRequired: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Price is required';
                    }
                    final price = double.tryParse(value);
                    if (price == null || price <= 0) {
                      return 'Please enter a valid price';
                    }
                    return null;
                  },
                  prefixIcon: const Icon(
                    Icons.attach_money,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingMedium),

                // Description Field
                CustomTextField(
                  label: AppStrings.offerDescription,
                  hint: 'Describe your offer in detail...',
                  controller: _descriptionController,
                  maxLines: 4,
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
                const SizedBox(height: AppDimensions.paddingMedium),

                // Images Section
                Text(
                  AppStrings.addImages,
                  style: AppTextStyles.body1.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingSmall),

                // Images Grid
                if (_images.isNotEmpty)
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: AppDimensions.paddingSmall,
                          mainAxisSpacing: AppDimensions.paddingSmall,
                        ),
                    itemCount: _images.length,
                    itemBuilder: (context, index) {
                      return Stack(
                        children: [
                          Container(
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
                              child: Image.file(
                                _images[index],
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: AppColors.background,
                                    child: const Icon(Icons.error),
                                  );
                                },
                              ),
                            ),
                          ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: GestureDetector(
                              onTap: () => _removeImage(index),
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: AppColors.error,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: AppColors.surface,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                const SizedBox(height: AppDimensions.paddingMedium),

                // Add Image Button
                CustomButton(
                  text: 'Add Image from Gallery',
                  onPressed: _pickImage,
                  isOutlined: true,
                  icon: Icons.add_photo_alternate,
                ),
                const SizedBox(height: AppDimensions.paddingXLarge),

                // Submit Button
                Consumer<PostProvider>(
                  builder: (context, postProvider, child) {
                    return CustomButton(
                      text: AppStrings.addOffer,
                      onPressed: postProvider.isLoading ? null : _addOffer,
                      isLoading: postProvider.isLoading,
                      icon: Icons.send,
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
