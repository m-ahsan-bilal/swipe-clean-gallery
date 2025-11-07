import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import 'package:swipe_clean_gallery/services/app_colors.dart';
import 'package:swipe_clean_gallery/services/recently_deleted_service.dart';

class RecentlyDeletedScreen extends StatefulWidget {
  const RecentlyDeletedScreen({super.key});

  @override
  State<RecentlyDeletedScreen> createState() => _RecentlyDeletedScreenState();
}

class _RecentlyDeletedScreenState extends State<RecentlyDeletedScreen> {
  late RecentlyDeletedService _deletedService;
  bool _isSelectionMode = false;
  final Set<String> _selectedItems = {};
  bool _showFireworks = false;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _deletedService = RecentlyDeletedService(
      onUpdate: () {
        if (mounted) setState(() {});
      },
    );
    _initService();
  }

  Future<void> _initService() async {
    await _deletedService.init();
    if (mounted) setState(() {});
  }

  void _toggleSelection(String itemId) {
    setState(() {
      if (_selectedItems.contains(itemId)) {
        _selectedItems.remove(itemId);
      } else {
        _selectedItems.add(itemId);
      }
    });
  }

  void _selectAll() {
    setState(() {
      _selectedItems.clear();
      _selectedItems.addAll(
        _deletedService.deletedItems.map((item) => item.id),
      );
    });
  }

  void _clearSelection() {
    setState(() {
      _selectedItems.clear();
      _isSelectionMode = false;
    });
  }

  Future<void> _restoreSelected() async {
    final itemsToRestore = List<String>.from(_selectedItems);
    int restoredCount = 0;

    for (final itemId in itemsToRestore) {
      final success = await _deletedService.restoreItem(itemId);
      if (success) restoredCount++;
    }

    _clearSelection();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '$restoredCount item${restoredCount != 1 ? 's' : ''} restored',
          ),
          backgroundColor: Colors.green,
        ),
      );

      // Mark changes to notify gallery
      if (restoredCount > 0) {
        _hasChanges = true;
      }
    }
  }

  Future<void> _clearAll() async {
    if (_deletedService.count == 0) return;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.dialogBackground,
        title: const Text('Clear All?', style: TextStyle(color: Colors.white)),
        content: Text(
          'Permanently delete all ${_deletedService.count} items? This cannot be undone.',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Clear All', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (result == true) {
      debugPrint('🗑️ Starting clear all operation...');
      final success = await _deletedService.clearAll();

      debugPrint('Clear all result: $success');

      if (mounted) {
        if (success) {
          _hasChanges = true;
          _showFireworks = true;
          setState(() {});

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('All items permanently deleted'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 2),
            ),
          );

          // Force an additional reload after animation completes
          Future.delayed(const Duration(seconds: 4), () async {
            if (mounted) {
              await PhotoManager.clearFileCache();
              debugPrint('🔄 Additional cache clear after clear all');
            }
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to delete some items'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final groupedItems = _deletedService.getGroupedItems();
    final sectionKeys = groupedItems.keys.toList();

    return WillPopScope(
      onWillPop: () async {
        if (_isSelectionMode) {
          _clearSelection();
          return false;
        }
        // Return true/false to indicate if gallery should refresh
        Navigator.pop(context, _hasChanges);
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundPrimary,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundPrimary,
          elevation: 0,
          title: Text(
            _isSelectionMode
                ? '${_selectedItems.length} selected'
                : 'Recently Deleted',
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          leading: IconButton(
            icon: Icon(
              _isSelectionMode ? Icons.close : Icons.arrow_back_ios_new,
              color: Colors.white,
            ),
            onPressed: () {
              if (_isSelectionMode) {
                _clearSelection();
              } else {
                Navigator.pop(context, _hasChanges);
              }
            },
          ),
          actions: [
            if (_isSelectionMode) ...[
              TextButton(
                onPressed: _selectAll,
                child: const Text('Select All'),
              ),
            ] else if (_deletedService.count > 0) ...[
              TextButton(
                onPressed: _clearAll,
                child: const Text(
                  'Clear All',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ],
        ),
        body: Stack(
          children: [
            if (_deletedService.count == 0)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.delete_outline,
                      size: 80,
                      color: Colors.white.withOpacity(0.3),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'No recently deleted items',
                      style: TextStyle(color: Colors.white70, fontSize: 18),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Items you delete will appear here',
                      style: TextStyle(color: Colors.white54, fontSize: 14),
                    ),
                  ],
                ),
              )
            else
              Column(
                children: [
                  Container(
                    color: AppColors.backgroundPrimary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Text(
                      'Items will be permanently deleted after 30 days',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: sectionKeys.length,
                      itemBuilder: (context, sectionIndex) {
                        final label = sectionKeys[sectionIndex];
                        final items = groupedItems[label]!;

                        return StickyHeader(
                          header: Container(
                            color: AppColors.backgroundPrimary,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            child: Text(
                              label,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
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
                            itemCount: items.length,
                            itemBuilder: (_, index) {
                              final item = items[index];
                              final isSelected = _selectedItems.contains(
                                item.id,
                              );

                              return FutureBuilder<AssetEntity?>(
                                future: AssetEntity.fromId(item.id),
                                builder: (context, snapshot) {
                                  final asset = snapshot.data;

                                  return GestureDetector(
                                    onTap: () {
                                      if (_isSelectionMode) {
                                        _toggleSelection(item.id);
                                      } else {
                                        setState(() {
                                          _isSelectionMode = true;
                                          _selectedItems.add(item.id);
                                        });
                                      }
                                    },
                                    onLongPress: () {
                                      if (!_isSelectionMode) {
                                        setState(() {
                                          _isSelectionMode = true;
                                          _selectedItems.add(item.id);
                                        });
                                      }
                                    },
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                          child: asset != null
                                              ? AssetEntityImage(
                                                  asset,
                                                  isOriginal: false,
                                                  thumbnailSize:
                                                      const ThumbnailSize.square(
                                                        150,
                                                      ),
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (_, __, ___) =>
                                                      Container(
                                                        color: Colors.grey[800],
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            const Icon(
                                                              Icons
                                                                  .broken_image,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                            const SizedBox(
                                                              height: 4,
                                                            ),
                                                            Text(
                                                              '${item.daysUntilPermanentDeletion}d',
                                                              style:
                                                                  const TextStyle(
                                                                    color: Colors
                                                                        .grey,
                                                                    fontSize:
                                                                        10,
                                                                  ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                )
                                              : Container(
                                                  color: Colors.grey[800],
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        item.type ==
                                                                AssetType.video
                                                            ? Icons.videocam_off
                                                            : Icons
                                                                  .image_not_supported,
                                                        color: Colors.grey,
                                                        size: 30,
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        '${item.daysUntilPermanentDeletion}d',
                                                        style: const TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 10,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                        ),
                                        // Selection overlay
                                        if (_isSelectionMode)
                                          Container(
                                            decoration: BoxDecoration(
                                              color: isSelected
                                                  ? Colors.white.withOpacity(
                                                      0.3,
                                                    )
                                                  : Colors.black.withOpacity(
                                                      0.3,
                                                    ),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                          ),
                                        // Selection checkbox
                                        if (_isSelectionMode)
                                          Positioned(
                                            top: 4,
                                            right: 4,
                                            child: Container(
                                              width: 24,
                                              height: 24,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: isSelected
                                                    ? AppColors.brandPrimary
                                                    : Colors.white.withOpacity(
                                                        0.3,
                                                      ),
                                                border: Border.all(
                                                  color: Colors.white,
                                                  width: 2,
                                                ),
                                              ),
                                              child: isSelected
                                                  ? const Icon(
                                                      Icons.check,
                                                      size: 16,
                                                      color: Colors.white,
                                                    )
                                                  : null,
                                            ),
                                          ),
                                        // Video indicator
                                        if (item.type == AssetType.video)
                                          Positioned(
                                            bottom: 4,
                                            left: 4,
                                            child: Container(
                                              padding: const EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                color: Colors.black54,
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              child: const Icon(
                                                Icons.play_arrow,
                                                color: Colors.white,
                                                size: 16,
                                              ),
                                            ),
                                          ),
                                        // Days remaining
                                        Positioned(
                                          bottom: 4,
                                          right: 4,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 6,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.black54,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Text(
                                              '${item.daysUntilPermanentDeletion}d',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            // Selection mode bottom bar - only restore button
            if (_isSelectionMode && _selectedItems.isNotEmpty)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: AppColors.backgroundSurface,
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 12,
                    bottom: MediaQuery.of(context).padding.bottom + 12,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _restoreSelected,
                      icon: const Icon(Icons.restore),
                      label: Text(
                        'Restore ${_selectedItems.length} item${_selectedItems.length != 1 ? 's' : ''}',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.brandPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ),
              ),
            // Fireworks overlay
            if (_showFireworks)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.8),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TweenAnimationBuilder<double>(
                          duration: const Duration(seconds: 3),
                          tween: Tween(begin: 0.0, end: 1.0),
                          onEnd: () {
                            if (mounted) {
                              setState(() => _showFireworks = false);
                              // Return true to force gallery refresh
                              Navigator.pop(context, _hasChanges);
                            }
                          },
                          builder: (context, value, child) {
                            return SizedBox(
                              width: 300,
                              height: 300,
                              child: CustomPaint(
                                painter: FireworksPainter(progress: value),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Congratulations!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'All items have been cleared',
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// Custom painter for fireworks animation
class FireworksPainter extends CustomPainter {
  final double progress;

  FireworksPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Draw multiple fireworks
    for (int i = 0; i < 5; i++) {
      final centerX = size.width * (0.2 + i * 0.15);
      final centerY = size.height * (0.3 + (i % 2) * 0.2);

      _drawFirework(canvas, Offset(centerX, centerY), progress, paint, i);
    }
  }

  void _drawFirework(
    Canvas canvas,
    Offset center,
    double progress,
    Paint paint,
    int seed,
  ) {
    final random = math.Random(seed);
    final particleCount = 20 + random.nextInt(10);

    for (int i = 0; i < particleCount; i++) {
      final angle = (i / particleCount) * 2 * math.pi;
      final velocity = 50 + random.nextDouble() * 100;

      // Calculate particle position
      final distance =
          velocity * progress * (2 - progress); // Slow down over time
      final x = center.dx + math.cos(angle) * distance;
      final y =
          center.dy +
          math.sin(angle) * distance +
          (progress * progress * 50); // Gravity

      // Fade out
      final opacity = (1 - progress).clamp(0.0, 1.0);

      // Random colors
      final colors = [
        Colors.red,
        Colors.blue,
        Colors.yellow,
        Colors.green,
        Colors.purple,
        Colors.orange,
        Colors.pink,
      ];

      paint.color = colors[random.nextInt(colors.length)].withOpacity(opacity);

      // Particle size
      final size = (3 + random.nextDouble() * 3) * (1 - progress * 0.5);

      canvas.drawCircle(Offset(x, y), size, paint);
    }
  }

  @override
  bool shouldRepaint(FireworksPainter oldDelegate) => true;
}
