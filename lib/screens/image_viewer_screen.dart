import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:swipe_clean_gallery/services/app_colors.dart';

class ImageViewerScreen extends StatefulWidget {
  final List<AssetEntity> images;
  final int initialIndex;

  const ImageViewerScreen({
    super.key,
    required this.images,
    required this.initialIndex,
  });

  @override
  State<ImageViewerScreen> createState() => _ImageViewerScreenState();
}

class _ImageViewerScreenState extends State<ImageViewerScreen> {
  late PageController _pageController;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.black,
        title: Text(
          "${currentIndex + 1} / ${widget.images.length}",
          style: const TextStyle(color: AppColors.textPrimary),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: AppColors.textPrimary),
            onPressed: () async {
              try {
                final asset = widget.images[currentIndex];

                // Delete asset from device
                final deletedIds = await PhotoManager.editor.deleteWithIds([
                  asset.id,
                ]);

                // Check if deleted
                final success = deletedIds.contains(asset.id);
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Photo deleted successfully")),
                  );
                  // remove from local list chache
                  setState(() {
                    widget.images.removeAt(currentIndex);
                  });
                  // if the all images deleted
                  if (widget.images.isEmpty) {
                    Navigator.pop(context);
                    return;
                  }
                  // update currentIndex if needed
                  if (currentIndex >= widget.images.length) {
                    currentIndex = widget.images.length - 1;
                    _pageController.jumpToPage(currentIndex);
                  }
                } else {
                  // Failed to delete
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Failed to delete photo")),
                  );
                }
              } catch (e) {
                // Handle unexpected errors
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Error deleting photo: $e")),
                );
              }
            },
          ),
        ],
      ),
      body: PhotoViewGallery.builder(
        pageController: _pageController,
        itemCount: widget.images.length,
        onPageChanged: (index) {
          setState(() => currentIndex = index);
        },
        builder: (context, index) {
          final asset = widget.images[index];
          return PhotoViewGalleryPageOptions(
            imageProvider: AssetEntityImageProvider(asset, isOriginal: true),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 2.5,
            heroAttributes: PhotoViewHeroAttributes(tag: asset.id),
          );
        },
        scrollPhysics: const BouncingScrollPhysics(),
      ),
    );
  }
}
