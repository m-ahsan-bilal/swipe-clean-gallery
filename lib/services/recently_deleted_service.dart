import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swipe_clean_gallery/l10n/app_localizations.dart';

class RecentlyDeletedService {
  static const String _storageKey = 'recently_deleted_items';
  static const Duration _retentionPeriod = Duration(days: 30);

  List<DeletedItem> _deletedItems = [];
  final VoidCallback? onUpdate;

  RecentlyDeletedService({this.onUpdate});

  List<DeletedItem> get deletedItems => List.unmodifiable(_deletedItems);
  int get count => _deletedItems.length;

  /// Initialize the service and load deleted items
  Future<void> init() async {
    await loadDeletedItems();
  }

  /// Check if an asset is in recently deleted
  bool isDeleted(String assetId) {
    return _deletedItems.any((item) => item.id == assetId);
  }

  /// Get all deleted asset IDs
  Set<String> getDeletedIds() {
    return _deletedItems.map((item) => item.id).toSet();
  }

  /// Load deleted items from shared preferences
  Future<void> loadDeletedItems() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_storageKey);

      if (jsonString != null) {
        final List<dynamic> jsonList = json.decode(jsonString);
        _deletedItems = jsonList
            .map((item) => DeletedItem.fromJson(item))
            .where((item) => !item.isExpired())
            .toList();

        // Sort by deletion date, newest first
        _deletedItems.sort((a, b) => b.deletedAt.compareTo(a.deletedAt));

        // Save cleaned list (removes expired items)
        await _saveToStorage();
        onUpdate?.call();
      }
    } catch (e) {
      debugPrint('Error loading deleted items: $e');
    }
  }

  /// Add an item to recently deleted (temporary deletion)
  Future<bool> addDeletedItem(AssetEntity asset) async {
    try {
      // Check if already in recently deleted
      if (_deletedItems.any((item) => item.id == asset.id)) {
        debugPrint('Item already in recently deleted');
        return true;
      }

      // Store metadata for recently deleted
      final deletedItem = DeletedItem(
        id: asset.id,
        title: asset.title ?? 'Untitled',
        type: asset.type,
        width: asset.width,
        height: asset.height,
        duration: asset.duration,
        createDateTime: asset.createDateTime,
        modifiedDateTime: asset.modifiedDateTime,
        deletedAt: DateTime.now(),
      );

      _deletedItems.insert(0, deletedItem);
      await _saveToStorage();

      // Clear cache to ensure gallery updates
      await PhotoManager.clearFileCache();
      onUpdate?.call();

      // Return true as the item is successfully moved to recently deleted
      // The actual file is NOT deleted from device yet
      return true;
    } catch (e) {
      debugPrint('Error adding deleted item: $e');
      return false;
    }
  }

  /// Restore an item from recently deleted
  Future<bool> restoreItem(String itemId) async {
    try {
      // Find and remove from deleted items
      _deletedItems.removeWhere((item) => item.id == itemId);
      await _saveToStorage();
      onUpdate?.call();
      return true;
    } catch (e) {
      debugPrint('Error restoring item: $e');
      return false;
    }
  }

  /// Permanently delete an item
  Future<bool> permanentlyDeleteItem(String itemId) async {
    try {
      debugPrint('Attempting to permanently delete item: $itemId');

      // Actually delete the file using PhotoManager
      final deletedIds = await PhotoManager.editor.deleteWithIds([itemId]);

      // Clear cache to ensure updates
      await PhotoManager.clearFileCache();

      // Remove from list regardless (item might not exist anymore)
      _deletedItems.removeWhere((item) => item.id == itemId);
      await _saveToStorage();
      onUpdate?.call();

      final success = deletedIds.contains(itemId);
      debugPrint(
        success
            ? 'Item permanently deleted'
            : 'Item not found but removed from list',
      );
      return true;
    } catch (e) {
      debugPrint('Error permanently deleting item: $e');
      // Try to remove from list anyway
      try {
        _deletedItems.removeWhere((item) => item.id == itemId);
        await _saveToStorage();
        onUpdate?.call();
      } catch (e2) {
        debugPrint('Failed to remove from list: $e2');
      }
      return false;
    }
  }

  /// Clear all recently deleted items (permanently delete)
  Future<bool> clearAll() async {
    try {
      if (_deletedItems.isEmpty) {
        debugPrint('No items to clear');
        return true;
      }

      // Get all IDs to delete
      final idsToDelete = _deletedItems.map((item) => item.id).toList();
      debugPrint(
        'Attempting to permanently delete ${idsToDelete.length} items',
      );

      // Delete all files from device
      final deletedIds = await PhotoManager.editor.deleteWithIds(idsToDelete);
      debugPrint('Permanently deleted ${deletedIds.length} items from device');

      // Clear the file cache to ensure gallery updates
      await PhotoManager.clearFileCache();
      debugPrint('Cleared PhotoManager cache');

      // Clear the list regardless of how many were actually deleted
      // (Some might not exist anymore)
      _deletedItems.clear();
      await _saveToStorage();
      debugPrint('Cleared recently deleted storage');

      // Notify listeners
      onUpdate?.call();

      return true;
    } catch (e) {
      debugPrint('Error clearing all items: $e');
      // Even on error, try to clear the storage
      try {
        _deletedItems.clear();
        await _saveToStorage();
        onUpdate?.call();
      } catch (e2) {
        debugPrint('Failed to clear storage: $e2');
      }
      return false;
    }
  }

  /// Save deleted items to storage
  Future<void> _saveToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = _deletedItems.map((item) => item.toJson()).toList();
      await prefs.setString(_storageKey, json.encode(jsonList));
    } catch (e) {
      debugPrint('Error saving deleted items: $e');
    }
  }

  /// Group deleted items by date
  Map<String, List<DeletedItem>> getGroupedItems({BuildContext? context}) {
    final Map<String, List<DeletedItem>> grouped = {};

    for (final item in _deletedItems) {
      final dateKey = _getDateLabel(item.deletedAt, context: context);
      grouped.putIfAbsent(dateKey, () => []).add(item);
    }

    return grouped;
  }

  String _getDateLabel(DateTime date, {BuildContext? context}) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    // Get localizations if context is available
    final l10n = context != null ? AppLocalizations.of(context) : null;

    if (difference.inDays == 0) {
      return l10n?.today ?? 'Today';
    } else if (difference.inDays == 1) {
      return l10n?.yesterday ?? 'Yesterday';
    } else if (difference.inDays < 7) {
      return l10n?.daysAgo(difference.inDays) ?? '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      final plural = weeks > 1 ? 's' : '';
      return l10n?.weeksAgo(weeks, plural) ?? '$weeks week$plural ago';
    } else {
      final months = (difference.inDays / 30).floor();
      final plural = months > 1 ? 's' : '';
      return l10n?.monthsAgo(months, plural) ?? '$months month$plural ago';
    }
  }
}

class DeletedItem {
  final String id;
  final String title;
  final AssetType type;
  final int width;
  final int height;
  final int duration;
  final DateTime createDateTime;
  final DateTime modifiedDateTime;
  final DateTime deletedAt;

  DeletedItem({
    required this.id,
    required this.title,
    required this.type,
    required this.width,
    required this.height,
    required this.duration,
    required this.createDateTime,
    required this.modifiedDateTime,
    required this.deletedAt,
  });

  bool isExpired() {
    return DateTime.now().difference(deletedAt) >
        RecentlyDeletedService._retentionPeriod;
  }

  int get daysUntilPermanentDeletion {
    final expirationDate = deletedAt.add(
      RecentlyDeletedService._retentionPeriod,
    );
    final daysLeft = expirationDate.difference(DateTime.now()).inDays;
    return daysLeft > 0 ? daysLeft : 0;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'type': type.index,
    'width': width,
    'height': height,
    'duration': duration,
    'createDateTime': createDateTime.toIso8601String(),
    'modifiedDateTime': modifiedDateTime.toIso8601String(),
    'deletedAt': deletedAt.toIso8601String(),
  };

  factory DeletedItem.fromJson(Map<String, dynamic> json) => DeletedItem(
    id: json['id'],
    title: json['title'],
    type: AssetType.values[json['type']],
    width: json['width'],
    height: json['height'],
    duration: json['duration'],
    createDateTime: DateTime.parse(json['createDateTime']),
    modifiedDateTime: DateTime.parse(json['modifiedDateTime']),
    deletedAt: DateTime.parse(json['deletedAt']),
  );
}
