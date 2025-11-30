import 'package:flutter/material.dart';

class ImageSourceBottomSheet extends StatelessWidget {
  final VoidCallback onCameraPressed;
  final VoidCallback onGalleryPressed;

  const ImageSourceBottomSheet({
    super.key,
    required this.onCameraPressed,
    required this.onGalleryPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHandleBar(),
          _buildHeader(),
          _buildCameraOption(),
          _buildGalleryOption(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildHandleBar() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildHeader() {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Text(
        'Choose Image Source',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildCameraOption() {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF667eea).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(
          Icons.camera_alt,
          color: Color(0xFF667eea),
          size: 24,
        ),
      ),
      title: const Text(
        'Take Photo',
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: const Text('Scan receipt with camera'),
      onTap: onCameraPressed,
    );
  }

  Widget _buildGalleryOption() {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF764ba2).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(
          Icons.photo_library,
          color: Color(0xFF764ba2),
          size: 24,
        ),
      ),
      title: const Text(
        'Choose from Gallery',
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: const Text('Select existing photo'),
      onTap: onGalleryPressed,
    );
  }
} 