import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:intl/intl.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import 'package:swipe_clean_gallery/screens/image_viewer_screen.dart';
import 'package:swipe_clean_gallery/services/app_colors.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  Map<String, List<AssetEntity>> groupedImages = {};
  final ScrollController _scrollController = ScrollController();

  int _currentPage = 0;
  bool _isLoading = false;
  bool _hasMore = true;
  AssetPathEntity? _album;

  @override
  void initState() {
    super.initState();
    _initGallery();
    _scrollController.addListener(_scrollListener);
  }

  // images with index
  List<AssetEntity> get allImages {
    final list = <AssetEntity>[];
    groupedImages.forEach((key, value) => list.addAll(value));
    return list;
  }

  Future<void> _initGallery() async {
    final albums = await PhotoManager.getAssetPathList(
      type: RequestType.image,
      hasAll: true,
    );
    if (albums.isEmpty) return;

    _album = albums.first;
    await _loadMoreImages();
  }

  Future<void> _loadMoreImages() async {
    if (_isLoading || !_hasMore) return;
    _isLoading = true;

    final photos = await _album!.getAssetListPaged(
      page: _currentPage,
      size: 100,
    );

    if (photos.isEmpty) {
      _hasMore = false;
      _isLoading = false;
      return;
    }

    // Add to grouped map
    final now = DateTime.now();
    for (var photo in photos) {
      final date = photo.createDateTime;
      String label;

      if (isSameDay(date, now)) {
        label = "Today";
      } else if (date.isAfter(now.subtract(const Duration(days: 7)))) {
        label = "This Week";
      } else if (date.isAfter(DateTime(now.year, now.month, 1))) {
        label = "This Month";
      } else if (date.year == now.year) {
        label = DateFormat.MMMM().format(date);
      } else {
        label = date.year.toString();
      }

      groupedImages.putIfAbsent(label, () => []).add(photo);
    }

    _currentPage++;
    _isLoading = false;

    setState(() {});
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >
        _scrollController.position.maxScrollExtent - 400) {
      _loadMoreImages();
    }
  }

  @override
  Widget build(BuildContext context) {
    final sectionKeys = groupedImages.keys.toList();

    return Scaffold(
      backgroundColor: const Color(0xFF0F1417),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F1417),
        title: const Text(
          "Your Photos",
          style: TextStyle(color: AppColors.textPrimary),
        ),
      ),
      body: groupedImages.isEmpty
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : ListView.builder(
              controller: _scrollController,
              itemCount: sectionKeys.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, sectionIndex) {
                if (sectionIndex >= sectionKeys.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  );
                }

                final label = sectionKeys[sectionIndex];
                final photos = groupedImages[label]!;

                return StickyHeader(
                  header: Container(
                    width: double.infinity,
                    color: const Color(0xFF0F1417),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Text(
                      label,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  content: GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 4,
                          mainAxisSpacing: 4,
                        ),
                    itemCount: photos.length,
                    itemBuilder: (context, index) {
                      final asset = photos[index];
                      final globalIndex = allImages.indexOf(asset);

                      return GestureDetector(
                        onTap: () async {
                          final updateList = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ImageViewerScreen(
                                images: allImages,
                                initialIndex: globalIndex,
                              ),
                            ),
                          );
                          if (updateList != null && mounted) {
                            setState(() {
                              groupedImages.clear();
                              _currentPage = 0;
                              _hasMore = true;
                            });
                            await _initGallery();
                          }
                        },
                        child: Hero(
                          tag: asset.id,
                          child: AssetEntityImage(
                            asset,
                            isOriginal: false,
                            thumbnailSize: const ThumbnailSize.square(150),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
