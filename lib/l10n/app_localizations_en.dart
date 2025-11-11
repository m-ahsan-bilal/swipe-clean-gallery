// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Swipe Clean Gallery';

  @override
  String get splashTitle => 'Swipe Clean Gallery';

  @override
  String get splashSubtitle => 'Swipe to organize your memories';

  @override
  String get splashSwipeHint => 'Swipe to clean';

  @override
  String get languageSelectionTitle => 'Choose Your Language';

  @override
  String get languageSelectionSubtitle =>
      'Select your preferred language to continue';

  @override
  String get continueButton => 'Continue';

  @override
  String get permissionRequired => 'Permission Required';

  @override
  String get accessYourPhotos => 'Access Your Photos';

  @override
  String get permissionDeniedMessage =>
      'This app requires full access to your photos and storage to function. Without permission, you cannot use the app. Please tap the button below to grant access in Settings.';

  @override
  String get permissionMessage =>
      'Photo Swipe needs permission to view and manage photos on your device. Swipe to browse, swipe up to delete.';

  @override
  String get appCannotBeUsed => 'App cannot be used without permission';

  @override
  String get allowAccess => 'Allow Access';

  @override
  String get openSettings => 'Open Settings';

  @override
  String get fullAccessRequired => 'Full Access Required';

  @override
  String get fullAccessMessage =>
      'This app requires full photo access to function properly. Please grant full access in Settings.';

  @override
  String get ok => 'OK';

  @override
  String get enableAllFilesAccess =>
      'Please enable \"All files access\" in Settings to use this app';

  @override
  String get yourPhotos => 'Your Photos';

  @override
  String get loadingPhotos => 'Loading your photos...';

  @override
  String get noPhotosFound => 'No photos found';

  @override
  String get galleryRefreshed => 'Gallery refreshed';

  @override
  String errorLoadingGallery(String error) {
    return 'Error loading gallery: $error';
  }

  @override
  String get exitGallery => 'Exit Gallery';

  @override
  String get exitWithoutCleaningMessage =>
      'You\'re leaving without cleaning. Come back soon!';

  @override
  String get cancel => 'Cancel';

  @override
  String get exit => 'Exit';

  @override
  String filesDeleted(int count, String plural) {
    return '$count file$plural successfully deleted';
  }

  @override
  String get freedUpSpace => 'You\'ve freed up space! Continue or exit?';

  @override
  String get keepCleaning => 'Keep Cleaning';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get changeLanguage => 'Change Language';

  @override
  String get currentLanguage => 'Current Language';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get languageChanged => 'Language changed successfully';

  @override
  String get systemDefault => 'System Default';

  @override
  String get recentlyDeleted => 'Recently Deleted';

  @override
  String get delete => 'Delete';

  @override
  String get restore => 'Restore';

  @override
  String get deleteForever => 'Delete Forever';

  @override
  String get confirm => 'Confirm';

  @override
  String get deleteConfirmation => 'Are you sure you want to delete this item?';

  @override
  String get permanentDeleteConfirmation =>
      'This action cannot be undone. Are you sure?';

  @override
  String get itemRestored => 'Item restored successfully';

  @override
  String get itemDeleted => 'Item deleted permanently';

  @override
  String get english => 'English';

  @override
  String get urdu => 'اردو';

  @override
  String get arabic => 'العربية';

  @override
  String get spanish => 'Español';

  @override
  String get french => 'Français';

  @override
  String get german => 'Deutsch';

  @override
  String get chinese => '中文';

  @override
  String get hindi => 'हिन्दी';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get thisWeek => 'This Week';

  @override
  String get thisMonth => 'This Month';

  @override
  String get january => 'January';

  @override
  String get february => 'February';

  @override
  String get march => 'March';

  @override
  String get april => 'April';

  @override
  String get may => 'May';

  @override
  String get june => 'June';

  @override
  String get july => 'July';

  @override
  String get august => 'August';

  @override
  String get september => 'September';

  @override
  String get october => 'October';

  @override
  String get november => 'November';

  @override
  String get december => 'December';

  @override
  String daysAgo(int count) {
    return '$count days ago';
  }

  @override
  String weeksAgo(int count, String plural) {
    return '$count week$plural ago';
  }

  @override
  String monthsAgo(int count, String plural) {
    return '$count month$plural ago';
  }

  @override
  String get selectAll => 'Select All';

  @override
  String get deselectAll => 'Deselect All';

  @override
  String get selectedCount => 'selected';

  @override
  String get restoreSelected => 'Restore Selected';

  @override
  String get deleteSelected => 'Delete Selected';

  @override
  String get emptyTrash => 'Empty Trash';

  @override
  String get noDeletedItems => 'No deleted items';

  @override
  String get deletedItemsMessage => 'Deleted items will be kept for 30 days';

  @override
  String confirmRestore(int count, String plural) {
    return 'Restore $count item$plural?';
  }

  @override
  String confirmDelete(int count, String plural) {
    return 'Permanently delete $count item$plural?';
  }

  @override
  String get confirmEmptyTrash => 'Empty trash?';

  @override
  String confirmEmptyTrashMessage(int count) {
    return 'This will permanently delete all $count items. This action cannot be undone.';
  }

  @override
  String itemsRestored(int count, String plural) {
    return '$count item$plural restored';
  }

  @override
  String itemsDeleted(int count, String plural) {
    return '$count item$plural deleted permanently';
  }

  @override
  String get trashEmptied => 'Trash emptied successfully';

  @override
  String get imageDeleted => 'Image deleted';

  @override
  String get videoDeleted => 'Video deleted';

  @override
  String get deletedSuccessfully => 'Deleted successfully';

  @override
  String get restoredSuccessfully => 'Restored successfully';

  @override
  String get errorOccurred => 'An error occurred';

  @override
  String get swipeUpToDelete => 'Swipe up to delete';

  @override
  String get releaseToDelete => 'Release to delete';

  @override
  String get deletingImage => 'Deleting...';

  @override
  String get photo => 'Photo';

  @override
  String get video => 'Video';

  @override
  String get outOf => 'of';

  @override
  String get deleteThisItem => 'Delete this item?';

  @override
  String get deleteItemMessage => 'This item will be moved to recently deleted';

  @override
  String get close => 'Close';

  @override
  String get done => 'Done';

  @override
  String unableToPlayVideo(String error) {
    return 'Unable to play video: $error';
  }

  @override
  String get clearAll => 'Clear All';

  @override
  String get noMoreCards => 'You\'ve reached the end';

  @override
  String get queueEmpty => 'No items queued for deletion';
}
