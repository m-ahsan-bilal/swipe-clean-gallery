// gallery_viewmodel.dart - MVVM ViewModel
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:swipe_clean_gallery/models/swipe_direction.dart';
import 'package:swipe_clean_gallery/services/gallery_service.dart';

class GalleryViewModel extends ChangeNotifier {
  final GalleryService _galleryService = GalleryService();

  // State
  bool _isInitializing = true;
  bool _isRefreshing = false;
  bool _hasPlayedIntro = false;

  final List<AssetEntity> _pendingDeletionQueue = [];
  List<AssetEntity> _cardAssets = [];
  int _topCardIndex = 0;
  Offset _cardOffset = Offset.zero;
  double _cardRotation = 0.0;
  int _totalDeletedCount = 0;

  // Track current asset ID for proper synchronization
  String? _currentAssetId;

  // Getters
  GalleryService get galleryService => _galleryService;
  bool get isInitializing => _isInitializing;
  bool get isRefreshing => _isRefreshing;
  bool get hasPlayedIntro => _hasPlayedIntro;
  List<AssetEntity> get pendingDeletionQueue =>
      List.unmodifiable(_pendingDeletionQueue);
  List<AssetEntity> get cardAssets => List.unmodifiable(_cardAssets);
  int get topCardIndex => _topCardIndex;
  Offset get cardOffset => _cardOffset;
  double get cardRotation => _cardRotation;
  int get totalDeletedCount => _totalDeletedCount;
  int get pendingCount => _pendingDeletionQueue.length;

  // Get current asset safely
  AssetEntity? get currentAsset {
    if (_cardAssets.isEmpty || _topCardIndex >= _cardAssets.length) {
      return null;
    }
    return _cardAssets[_topCardIndex];
  }

  // Intro animation
  void setHasPlayedIntro(bool value) {
    _hasPlayedIntro = value;
    notifyListeners();
  }

  // Initialize gallery
  Future<void> initGallery({bool playIntro = true}) async {
    if (_isRefreshing) return;

    try {
      _isRefreshing = true;
      _isInitializing = true;
      notifyListeners();

      await _galleryService.initGallery();

      _pendingDeletionQueue.clear();
      _cardOffset = Offset.zero;
      _cardRotation = 0.0;
      _currentAssetId = null;

      if (playIntro) _hasPlayedIntro = false;

      _isInitializing = false;
      notifyListeners();

      _syncCardAssets(resetIndex: true);
    } catch (e) {
      debugPrint("Gallery init error: $e");
      _isInitializing = false;
      notifyListeners();
      rethrow;
    } finally {
      _isRefreshing = false;
    }
  }

  // Load more images
  Future<void> loadMore() async {
    if (_galleryService.isLoading) return;
    await _galleryService.loadMoreImages();
    _syncCardAssets(resetIndex: false);
  }

  // Sync card assets with improved index tracking
  void _syncCardAssets({required bool resetIndex}) {
    try {
      final pendingIds = _pendingDeletionQueue.map((asset) => asset.id).toSet();

      // Sort DESCENDING = newest first
      // Use try-catch for date comparison in case of invalid dates
      final sorted = <AssetEntity>[];
      try {
        sorted.addAll(_galleryService.allImages);
        sorted.sort((a, b) {
          try {
            return b.createDateTime.compareTo(a.createDateTime);
          } catch (e) {
            debugPrint('Error comparing dates: $e');
            return 0;
          }
        });
      } catch (e) {
        debugPrint('Error sorting assets: $e');
        sorted.addAll(_galleryService.allImages);
      }

      final filtered = sorted
          .where(
            (asset) => asset.id.isNotEmpty && !pendingIds.contains(asset.id),
          )
          .toList();

      _cardAssets = filtered;

      if (_cardAssets.isEmpty) {
        _topCardIndex = 0;
        _cardOffset = Offset.zero;
        _cardRotation = 0;
        _currentAssetId = null;
        notifyListeners();
        return;
      }

      // Ensure topCardIndex is valid
      if (_topCardIndex < 0) _topCardIndex = 0;
      if (_topCardIndex >= _cardAssets.length) {
        _topCardIndex = _cardAssets.length - 1;
      }

      if (resetIndex) {
        // Starting fresh - show most recent
        _topCardIndex = 0;
        if (_cardAssets.isNotEmpty) {
          _currentAssetId = _cardAssets[0].id;
        }
      } else if (_currentAssetId != null) {
        // Try to maintain position by finding current asset ID
        final newIndex = _cardAssets.indexWhere(
          (asset) => asset.id == _currentAssetId,
        );

        if (newIndex != -1) {
          // Found the asset, update index
          _topCardIndex = newIndex;
        } else {
          // Asset was removed, stay at same position if possible
          if (_topCardIndex >= _cardAssets.length) {
            _topCardIndex = _cardAssets.length - 1;
          }
          if (_topCardIndex >= 0 && _topCardIndex < _cardAssets.length) {
            _currentAssetId = _cardAssets[_topCardIndex].id;
          }
        }
      } else {
        // No current asset tracked, clamp index
        if (_topCardIndex >= _cardAssets.length) {
          _topCardIndex = _cardAssets.length - 1;
        }
        if (_topCardIndex >= 0 && _topCardIndex < _cardAssets.length) {
          _currentAssetId = _cardAssets[_topCardIndex].id;
        }
      }

      notifyListeners();
    } catch (e, stackTrace) {
      debugPrint('Error in _syncCardAssets: $e');
      debugPrint('Stack trace: $stackTrace');
      // Reset to safe state on error
      _cardOffset = Offset.zero;
      _cardRotation = 0.0;
      if (_cardAssets.isEmpty && _galleryService.allImages.isNotEmpty) {
        // Try to recover by resetting
        _topCardIndex = 0;
        _currentAssetId = null;
      }
      notifyListeners();
    }
  }

  // Maybe load more
  void maybeLoadMore() {
    if (_cardAssets.isEmpty) return;
    if (_topCardIndex >= _cardAssets.length - 3) loadMore();
  }

  // Card pan update
  void onCardPanUpdate(DragUpdateDetails details, double screenWidth) {
    _cardOffset += details.delta;
    _cardRotation = (_cardOffset.dx / screenWidth) * 0.4;
    notifyListeners();
  }

  // Card pan end
  String? onCardPanEnd(DragEndDetails details) {
    const horizontalThreshold = 120;
    const verticalThreshold = 120;

    final dx = _cardOffset.dx;
    final dy = _cardOffset.dy;

    if (dy < -verticalThreshold) {
      return handleSwipe(SwipeDirection.up);
    } else if (dx > horizontalThreshold) {
      return handleSwipe(SwipeDirection.right);
    } else if (dx < -horizontalThreshold) {
      return handleSwipe(SwipeDirection.left);
    } else {
      resetCardPosition();
      return null;
    }
  }

  // Handle swipe with improved safety checks
  String? handleSwipe(SwipeDirection direction) {
    if (_cardAssets.isEmpty) {
      resetCardPosition();
      return null;
    }

    // Ensure index is valid before any operation
    if (_topCardIndex >= _cardAssets.length) {
      _topCardIndex = _cardAssets.length - 1;
    }

    switch (direction) {
      case SwipeDirection.left:
        // Older photos (next card)
        if (_topCardIndex < _cardAssets.length - 1) {
          _topCardIndex++;
          _currentAssetId = _cardAssets[_topCardIndex].id;
          _cardOffset = Offset.zero;
          _cardRotation = 0.0;
          notifyListeners();
          maybeLoadMore();
          return null;
        } else {
          resetCardPosition();
          return 'noMoreCards';
        }

      case SwipeDirection.right:
        // Newer photos (previous card)
        if (_topCardIndex > 0) {
          _topCardIndex--;
          _currentAssetId = _cardAssets[_topCardIndex].id;
          _cardOffset = Offset.zero;
          _cardRotation = 0.0;
          notifyListeners();
          return null;
        } else {
          resetCardPosition();
          return 'alreadyAtMostRecent';
        }

      case SwipeDirection.up:
        // Ensure we have a valid index and get the actual top card asset
        if (_topCardIndex < 0 || _topCardIndex >= _cardAssets.length) {
          resetCardPosition();
          return null;
        }

        final asset = _cardAssets[_topCardIndex];

        // Add to deletion queue if not already there
        if (!_pendingDeletionQueue.any((item) => item.id == asset.id)) {
          _pendingDeletionQueue.add(asset);
        }

        // Remove card from display list
        _cardAssets.removeAt(_topCardIndex);

        // Update index and current asset ID
        if (_cardAssets.isEmpty) {
          _topCardIndex = 0;
          _currentAssetId = null;
        } else {
          // After removing the top card, we stay at index 0 (which now has the next card)
          // Only adjust if we were at the end
          if (_topCardIndex >= _cardAssets.length) {
            _topCardIndex = _cardAssets.length - 1;
          }
          // Update current asset ID to the card now at this position
          if (_topCardIndex < _cardAssets.length) {
            _currentAssetId = _cardAssets[_topCardIndex].id;
          }
        }

        _cardOffset = Offset.zero;
        _cardRotation = 0.0;
        notifyListeners();

        if (_cardAssets.isNotEmpty) maybeLoadMore();

        return null;
    }
  }

  // Reset card position
  void resetCardPosition() {
    _cardOffset = Offset.zero;
    _cardRotation = 0.0;
    notifyListeners();
  }

  // Delete queued assets
  Future<Map<String, dynamic>> deleteQueuedAssets() async {
    if (_pendingDeletionQueue.isEmpty) {
      return {'success': false, 'message': 'queueEmpty'};
    }

    // Create a copy of assets to delete before clearing state
    final assetsToDelete = List<AssetEntity>.from(_pendingDeletionQueue);
    final ids = assetsToDelete.map((asset) => asset.id).toList();
    final deletedIdsSet = <String>{};

    try {
      final List<String> deletedIds = await PhotoManager.editor.deleteWithIds(
        ids,
      );

      if (deletedIds.isEmpty) {
        return {'success': false, 'message': 'deletionCancelled'};
      }

      deletedIdsSet.addAll(deletedIds);

      await PhotoManager.clearFileCache();

      // Remove successfully deleted items from queue
      _pendingDeletionQueue.removeWhere(
        (asset) => deletedIdsSet.contains(asset.id),
      );

      // Remove deleted assets from gallery service to keep it in sync
      _galleryService.allImages.removeWhere(
        (asset) => deletedIdsSet.contains(asset.id),
      );

      // Also remove from grouped images
      for (var group in _galleryService.groupedImages.values) {
        group.removeWhere((asset) => deletedIdsSet.contains(asset.id));
      }
      // Remove empty groups
      _galleryService.groupedImages.removeWhere((key, value) => value.isEmpty);

      _totalDeletedCount += deletedIds.length;

      // Reset card state after deletion to prevent crashes
      _cardOffset = Offset.zero;
      _cardRotation = 0.0;

      // Sync card assets to remove deleted items from display
      // Use try-catch to prevent crashes during sync
      // Note: _syncCardAssets already calls notifyListeners() internally
      try {
        _syncCardAssets(resetIndex: false);
      } catch (e) {
        debugPrint('Error syncing card assets after deletion: $e');
        // If sync fails, reset to safe state
        if (_cardAssets.isEmpty && _galleryService.allImages.isNotEmpty) {
          try {
            _syncCardAssets(resetIndex: true);
          } catch (e2) {
            debugPrint('Error in recovery sync: $e2');
            // Still notify to update UI even on error
            notifyListeners();
          }
        } else {
          // Notify even on error to update UI
          notifyListeners();
        }
      }

      return deletedIds.length < ids.length
          ? {
              'success': true,
              'partial': true,
              'deleted': deletedIds.length,
              'total': ids.length,
            }
          : {'success': true, 'deleted': deletedIds.length};
    } catch (e, stackTrace) {
      debugPrint('Error deleting assets: $e');
      debugPrint('Stack trace: $stackTrace');

      // Reset state on error to prevent inconsistent state
      _cardOffset = Offset.zero;
      _cardRotation = 0.0;

      return {'success': false, 'message': 'error', 'error': e.toString()};
    }
  }

  // Update grouping with context
  void updateGroupingWithContext(BuildContext context) {
    _galleryService.updateGroupingWithContext(context);
  }
}
