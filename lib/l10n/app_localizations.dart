import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_ur.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('hi'),
    Locale('ur'),
    Locale('zh'),
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Swipe Clean Gallery'**
  String get appTitle;

  /// Title shown on splash screen
  ///
  /// In en, this message translates to:
  /// **'Swipe Clean Gallery'**
  String get splashTitle;

  /// Subtitle shown on splash screen
  ///
  /// In en, this message translates to:
  /// **'Swipe to organize your memories'**
  String get splashSubtitle;

  /// Hint text for swipe gesture
  ///
  /// In en, this message translates to:
  /// **'Swipe to clean'**
  String get splashSwipeHint;

  /// Title of language selection screen
  ///
  /// In en, this message translates to:
  /// **'Choose Your Language'**
  String get languageSelectionTitle;

  /// Subtitle of language selection screen
  ///
  /// In en, this message translates to:
  /// **'Select your preferred language to continue'**
  String get languageSelectionSubtitle;

  /// Continue button text
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// Permission required title
  ///
  /// In en, this message translates to:
  /// **'Permission Required'**
  String get permissionRequired;

  /// Title for photo access permission
  ///
  /// In en, this message translates to:
  /// **'Access Your Photos'**
  String get accessYourPhotos;

  /// Message shown when permission is denied
  ///
  /// In en, this message translates to:
  /// **'This app requires full access to your photos and storage to function. Without permission, you cannot use the app. Please tap the button below to grant access in Settings.'**
  String get permissionDeniedMessage;

  /// Initial permission request message
  ///
  /// In en, this message translates to:
  /// **'Photo Swipe needs permission to view and manage photos on your device. Swipe to browse, swipe up to delete.'**
  String get permissionMessage;

  /// Warning message for denied permission
  ///
  /// In en, this message translates to:
  /// **'App cannot be used without permission'**
  String get appCannotBeUsed;

  /// Button to allow permission
  ///
  /// In en, this message translates to:
  /// **'Allow Access'**
  String get allowAccess;

  /// Button to open app settings
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get openSettings;

  /// Dialog title for full access requirement
  ///
  /// In en, this message translates to:
  /// **'Full Access Required'**
  String get fullAccessRequired;

  /// Dialog message for full access requirement
  ///
  /// In en, this message translates to:
  /// **'This app requires full photo access to function properly. Please grant full access in Settings.'**
  String get fullAccessMessage;

  /// OK button text
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// Snackbar message for enabling all files access
  ///
  /// In en, this message translates to:
  /// **'Please enable \"All files access\" in Settings to use this app'**
  String get enableAllFilesAccess;

  /// Gallery screen title
  ///
  /// In en, this message translates to:
  /// **'Your Photos'**
  String get yourPhotos;

  /// Loading message for gallery
  ///
  /// In en, this message translates to:
  /// **'Loading your photos...'**
  String get loadingPhotos;

  /// Message when no photos are available
  ///
  /// In en, this message translates to:
  /// **'No photos found'**
  String get noPhotosFound;

  /// Snackbar message after refreshing gallery
  ///
  /// In en, this message translates to:
  /// **'Gallery refreshed'**
  String get galleryRefreshed;

  /// Error message when gallery fails to load
  ///
  /// In en, this message translates to:
  /// **'Error loading gallery: {error}'**
  String errorLoadingGallery(String error);

  /// Exit dialog title
  ///
  /// In en, this message translates to:
  /// **'Exit Gallery'**
  String get exitGallery;

  /// Message shown when exiting without deleting photos
  ///
  /// In en, this message translates to:
  /// **'You\'re leaving without cleaning. Come back soon!'**
  String get exitWithoutCleaningMessage;

  /// Cancel button text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Exit button text
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exit;

  /// Message showing number of deleted files
  ///
  /// In en, this message translates to:
  /// **'{count} file{plural} successfully deleted'**
  String filesDeleted(int count, String plural);

  /// Message after successfully deleting files
  ///
  /// In en, this message translates to:
  /// **'You\'ve freed up space! Continue or exit?'**
  String get freedUpSpace;

  /// Button to continue cleaning
  ///
  /// In en, this message translates to:
  /// **'Keep Cleaning'**
  String get keepCleaning;

  /// Settings screen title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Language option title
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Button text to change language
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get changeLanguage;

  /// Label for current language
  ///
  /// In en, this message translates to:
  /// **'Current Language'**
  String get currentLanguage;

  /// Dialog title for language selection
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// Snackbar message after language change
  ///
  /// In en, this message translates to:
  /// **'Language changed successfully'**
  String get languageChanged;

  /// Option to use system default language
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get systemDefault;

  /// Recently deleted screen title
  ///
  /// In en, this message translates to:
  /// **'Recently Deleted'**
  String get recentlyDeleted;

  /// Delete button text
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Restore button text
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get restore;

  /// Permanently delete button text
  ///
  /// In en, this message translates to:
  /// **'Delete Forever'**
  String get deleteForever;

  /// Confirm button text
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// Confirmation message for deletion
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this item?'**
  String get deleteConfirmation;

  /// Confirmation message for permanent deletion
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone. Are you sure?'**
  String get permanentDeleteConfirmation;

  /// Message after restoring an item
  ///
  /// In en, this message translates to:
  /// **'Item restored successfully'**
  String get itemRestored;

  /// Message after permanently deleting an item
  ///
  /// In en, this message translates to:
  /// **'Item deleted permanently'**
  String get itemDeleted;

  /// English language name
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// Urdu language name
  ///
  /// In en, this message translates to:
  /// **'اردو'**
  String get urdu;

  /// Arabic language name
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get arabic;

  /// Spanish language name
  ///
  /// In en, this message translates to:
  /// **'Español'**
  String get spanish;

  /// French language name
  ///
  /// In en, this message translates to:
  /// **'Français'**
  String get french;

  /// German language name
  ///
  /// In en, this message translates to:
  /// **'Deutsch'**
  String get german;

  /// Chinese language name
  ///
  /// In en, this message translates to:
  /// **'中文'**
  String get chinese;

  /// Hindi language name
  ///
  /// In en, this message translates to:
  /// **'हिन्दी'**
  String get hindi;

  /// Label for today's date
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// Label for yesterday's date
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// Label for this week
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get thisWeek;

  /// Label for this month
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get thisMonth;

  /// No description provided for @january.
  ///
  /// In en, this message translates to:
  /// **'January'**
  String get january;

  /// No description provided for @february.
  ///
  /// In en, this message translates to:
  /// **'February'**
  String get february;

  /// No description provided for @march.
  ///
  /// In en, this message translates to:
  /// **'March'**
  String get march;

  /// No description provided for @april.
  ///
  /// In en, this message translates to:
  /// **'April'**
  String get april;

  /// No description provided for @may.
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get may;

  /// No description provided for @june.
  ///
  /// In en, this message translates to:
  /// **'June'**
  String get june;

  /// No description provided for @july.
  ///
  /// In en, this message translates to:
  /// **'July'**
  String get july;

  /// No description provided for @august.
  ///
  /// In en, this message translates to:
  /// **'August'**
  String get august;

  /// No description provided for @september.
  ///
  /// In en, this message translates to:
  /// **'September'**
  String get september;

  /// No description provided for @october.
  ///
  /// In en, this message translates to:
  /// **'October'**
  String get october;

  /// No description provided for @november.
  ///
  /// In en, this message translates to:
  /// **'November'**
  String get november;

  /// No description provided for @december.
  ///
  /// In en, this message translates to:
  /// **'December'**
  String get december;

  /// Label for days ago
  ///
  /// In en, this message translates to:
  /// **'{count} days ago'**
  String daysAgo(int count);

  /// Label for weeks ago
  ///
  /// In en, this message translates to:
  /// **'{count} week{plural} ago'**
  String weeksAgo(int count, String plural);

  /// Label for months ago
  ///
  /// In en, this message translates to:
  /// **'{count} month{plural} ago'**
  String monthsAgo(int count, String plural);

  /// No description provided for @selectAll.
  ///
  /// In en, this message translates to:
  /// **'Select All'**
  String get selectAll;

  /// No description provided for @deselectAll.
  ///
  /// In en, this message translates to:
  /// **'Deselect All'**
  String get deselectAll;

  /// Label for selected items
  ///
  /// In en, this message translates to:
  /// **'selected'**
  String get selectedCount;

  /// No description provided for @restoreSelected.
  ///
  /// In en, this message translates to:
  /// **'Restore Selected'**
  String get restoreSelected;

  /// No description provided for @deleteSelected.
  ///
  /// In en, this message translates to:
  /// **'Delete Selected'**
  String get deleteSelected;

  /// No description provided for @emptyTrash.
  ///
  /// In en, this message translates to:
  /// **'Empty Trash'**
  String get emptyTrash;

  /// No description provided for @noDeletedItems.
  ///
  /// In en, this message translates to:
  /// **'No deleted items'**
  String get noDeletedItems;

  /// No description provided for @deletedItemsMessage.
  ///
  /// In en, this message translates to:
  /// **'Deleted items will be kept for 30 days'**
  String get deletedItemsMessage;

  /// Confirmation for restore
  ///
  /// In en, this message translates to:
  /// **'Restore {count} item{plural}?'**
  String confirmRestore(int count, String plural);

  /// Confirmation for permanent delete
  ///
  /// In en, this message translates to:
  /// **'Permanently delete {count} item{plural}?'**
  String confirmDelete(int count, String plural);

  /// No description provided for @confirmEmptyTrash.
  ///
  /// In en, this message translates to:
  /// **'Empty trash?'**
  String get confirmEmptyTrash;

  /// Confirmation message for emptying trash
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete all {count} items. This action cannot be undone.'**
  String confirmEmptyTrashMessage(int count);

  /// Message for restored items
  ///
  /// In en, this message translates to:
  /// **'{count} item{plural} restored'**
  String itemsRestored(int count, String plural);

  /// Message for deleted items
  ///
  /// In en, this message translates to:
  /// **'{count} item{plural} deleted permanently'**
  String itemsDeleted(int count, String plural);

  /// No description provided for @trashEmptied.
  ///
  /// In en, this message translates to:
  /// **'Trash emptied successfully'**
  String get trashEmptied;

  /// No description provided for @imageDeleted.
  ///
  /// In en, this message translates to:
  /// **'Image deleted'**
  String get imageDeleted;

  /// No description provided for @videoDeleted.
  ///
  /// In en, this message translates to:
  /// **'Video deleted'**
  String get videoDeleted;

  /// No description provided for @deletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Deleted successfully'**
  String get deletedSuccessfully;

  /// No description provided for @restoredSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Restored successfully'**
  String get restoredSuccessfully;

  /// No description provided for @errorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get errorOccurred;

  /// No description provided for @swipeUpToDelete.
  ///
  /// In en, this message translates to:
  /// **'Swipe up to delete'**
  String get swipeUpToDelete;

  /// No description provided for @releaseToDelete.
  ///
  /// In en, this message translates to:
  /// **'Release to delete'**
  String get releaseToDelete;

  /// No description provided for @deletingImage.
  ///
  /// In en, this message translates to:
  /// **'Deleting...'**
  String get deletingImage;

  /// No description provided for @photo.
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get photo;

  /// No description provided for @video.
  ///
  /// In en, this message translates to:
  /// **'Video'**
  String get video;

  /// No description provided for @outOf.
  ///
  /// In en, this message translates to:
  /// **'of'**
  String get outOf;

  /// No description provided for @deleteThisItem.
  ///
  /// In en, this message translates to:
  /// **'Delete this item?'**
  String get deleteThisItem;

  /// No description provided for @deleteItemMessage.
  ///
  /// In en, this message translates to:
  /// **'This item will be moved to recently deleted'**
  String get deleteItemMessage;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// Error message when video playback fails
  ///
  /// In en, this message translates to:
  /// **'Unable to play video: {error}'**
  String unableToPlayVideo(String error);

  /// No description provided for @clearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get clearAll;

  /// No description provided for @noMoreCards.
  ///
  /// In en, this message translates to:
  /// **'You\'ve reached the end'**
  String get noMoreCards;

  /// No description provided for @queueEmpty.
  ///
  /// In en, this message translates to:
  /// **'No items queued for deletion'**
  String get queueEmpty;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'de',
    'en',
    'es',
    'fr',
    'hi',
    'ur',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'ur':
      return AppLocalizationsUr();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
