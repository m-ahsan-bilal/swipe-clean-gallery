// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Urdu (`ur`).
class AppLocalizationsUr extends AppLocalizations {
  AppLocalizationsUr([String locale = 'ur']) : super(locale);

  @override
  String get appTitle => 'سوائپ کلین گیلری';

  @override
  String get splashTitle => 'سوائپ کلین گیلری';

  @override
  String get splashSubtitle => 'اپنی یادوں کو منظم کرنے کے لیے سوائپ کریں';

  @override
  String get splashSwipeHint => 'صاف کرنے کے لیے سوائپ کریں';

  @override
  String get languageSelectionTitle => 'اپنی زبان منتخب کریں';

  @override
  String get languageSelectionSubtitle =>
      'جاری رکھنے کے لیے اپنی پسندیدہ زبان منتخب کریں';

  @override
  String get continueButton => 'جاری رکھیں';

  @override
  String get permissionRequired => 'اجازت درکار ہے';

  @override
  String get accessYourPhotos => 'اپنی تصاویر تک رسائی';

  @override
  String get permissionDeniedMessage =>
      'اس ایپ کو کام کرنے کے لیے آپ کی تصاویر اور اسٹوریج تک مکمل رسائی کی ضرورت ہے۔ اجازت کے بغیر، آپ اس ایپ کو استعمال نہیں کر سکتے۔ براہ کرم سیٹنگز میں رسائی دینے کے لیے نیچے بٹن دبائیں۔';

  @override
  String get permissionMessage =>
      'فوٹو سوائپ کو آپ کے ڈیوائس پر تصاویر دیکھنے اور منظم کرنے کی اجازت کی ضرورت ہے۔ براؤز کرنے کے لیے سوائپ کریں، حذف کرنے کے لیے اوپر سوائپ کریں۔';

  @override
  String get appCannotBeUsed => 'اجازت کے بغیر ایپ استعمال نہیں ہو سکتی';

  @override
  String get allowAccess => 'رسائی کی اجازت دیں';

  @override
  String get openSettings => 'سیٹنگز کھولیں';

  @override
  String get fullAccessRequired => 'مکمل رسائی درکار ہے';

  @override
  String get fullAccessMessage =>
      'اس ایپ کو صحیح طریقے سے کام کرنے کے لیے مکمل تصاویر کی رسائی کی ضرورت ہے۔ براہ کرم سیٹنگز میں مکمل رسائی دیں۔';

  @override
  String get ok => 'ٹھیک ہے';

  @override
  String get enableAllFilesAccess =>
      'اس ایپ کو استعمال کرنے کے لیے براہ کرم سیٹنگز میں \"تمام فائلوں تک رسائی\" فعال کریں';

  @override
  String get yourPhotos => 'آپ کی تصاویر';

  @override
  String get loadingPhotos => 'آپ کی تصاویر لوڈ ہو رہی ہیں...';

  @override
  String get noPhotosFound => 'کوئی تصاویر نہیں ملیں';

  @override
  String get galleryRefreshed => 'گیلری تازہ ہو گئی';

  @override
  String errorLoadingGallery(String error) {
    return 'گیلری لوڈ کرنے میں خرابی: $error';
  }

  @override
  String get exitGallery => 'گیلری سے باہر نکلیں';

  @override
  String get exitWithoutCleaningMessage =>
      'آپ صاف کیے بغیر جا رہے ہیں۔ جلد واپس آئیں!';

  @override
  String get cancel => 'منسوخ کریں';

  @override
  String get exit => 'باہر نکلیں';

  @override
  String filesDeleted(int count, String plural) {
    return '$count فائل$plural کامیابی سے حذف ہو گئی';
  }

  @override
  String get freedUpSpace =>
      'آپ نے جگہ خالی کر لی ہے! جاری رکھیں یا باہر نکلیں؟';

  @override
  String get keepCleaning => 'صاف کرتے رہیں';

  @override
  String get settings => 'سیٹنگز';

  @override
  String get language => 'زبان';

  @override
  String get changeLanguage => 'زبان تبدیل کریں';

  @override
  String get currentLanguage => 'موجودہ زبان';

  @override
  String get selectLanguage => 'زبان منتخب کریں';

  @override
  String get languageChanged => 'زبان کامیابی سے تبدیل ہو گئی';

  @override
  String get systemDefault => 'سسٹم ڈیفالٹ';

  @override
  String get recentlyDeleted => 'حال ہی میں حذف شدہ';

  @override
  String get delete => 'حذف کریں';

  @override
  String get restore => 'بحال کریں';

  @override
  String get deleteForever => 'ہمیشہ کے لیے حذف کریں';

  @override
  String get confirm => 'تصدیق کریں';

  @override
  String get deleteConfirmation =>
      'کیا آپ واقعی اس آئٹم کو حذف کرنا چاہتے ہیں؟';

  @override
  String get permanentDeleteConfirmation =>
      'یہ عمل کالعدم نہیں ہو سکتا۔ کیا آپ کو یقین ہے؟';

  @override
  String get itemRestored => 'آئٹم کامیابی سے بحال ہو گیا';

  @override
  String get itemDeleted => 'آئٹم مستقل طور پر حذف ہو گیا';

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
  String get today => 'آج';

  @override
  String get yesterday => 'کل';

  @override
  String get thisWeek => 'اس ہفتے';

  @override
  String get thisMonth => 'اس ماہ';

  @override
  String get january => 'جنوری';

  @override
  String get february => 'فروری';

  @override
  String get march => 'مارچ';

  @override
  String get april => 'اپریل';

  @override
  String get may => 'مئی';

  @override
  String get june => 'جون';

  @override
  String get july => 'جولائی';

  @override
  String get august => 'اگست';

  @override
  String get september => 'ستمبر';

  @override
  String get october => 'اکتوبر';

  @override
  String get november => 'نومبر';

  @override
  String get december => 'دسمبر';

  @override
  String daysAgo(int count) {
    return '$count دن پہلے';
  }

  @override
  String weeksAgo(int count, String plural) {
    return '$count ہفتے$plural پہلے';
  }

  @override
  String monthsAgo(int count, String plural) {
    return '$count ماہ$plural پہلے';
  }

  @override
  String get selectAll => 'سب منتخب کریں';

  @override
  String get deselectAll => 'سب غیر منتخب کریں';

  @override
  String get selectedCount => 'منتخب';

  @override
  String get restoreSelected => 'منتخب کو بحال کریں';

  @override
  String get deleteSelected => 'منتخب کو حذف کریں';

  @override
  String get emptyTrash => 'ٹریش خالی کریں';

  @override
  String get noDeletedItems => 'کوئی حذف شدہ آئٹمز نہیں';

  @override
  String get deletedItemsMessage => 'حذف شدہ آئٹمز 30 دنوں تک رکھے جائیں گے';

  @override
  String confirmRestore(int count, String plural) {
    return '$count آئٹم$plural بحال کریں؟';
  }

  @override
  String confirmDelete(int count, String plural) {
    return '$count آئٹم$plural مستقل طور پر حذف کریں؟';
  }

  @override
  String get confirmEmptyTrash => 'ٹریش خالی کریں؟';

  @override
  String confirmEmptyTrashMessage(int count) {
    return 'یہ تمام $count آئٹمز کو مستقل طور پر حذف کر دے گا۔ اس عمل کو کالعدم نہیں کیا جا سکتا۔';
  }

  @override
  String itemsRestored(int count, String plural) {
    return '$count آئٹم$plural بحال ہو گئے';
  }

  @override
  String itemsDeleted(int count, String plural) {
    return '$count آئٹم$plural مستقل طور پر حذف ہو گئے';
  }

  @override
  String get trashEmptied => 'ٹریش کامیابی سے خالی ہو گیا';

  @override
  String get imageDeleted => 'تصویر حذف ہو گئی';

  @override
  String get videoDeleted => 'ویڈیو حذف ہو گئی';

  @override
  String get deletedSuccessfully => 'کامیابی سے حذف ہو گیا';

  @override
  String get restoredSuccessfully => 'کامیابی سے بحال ہو گیا';

  @override
  String get errorOccurred => 'ایک خرابی پیش آئی';

  @override
  String get swipeUpToDelete => 'حذف کرنے کے لیے اوپر سوائپ کریں';

  @override
  String get releaseToDelete => 'حذف کرنے کے لیے چھوڑ دیں';

  @override
  String get deletingImage => 'حذف ہو رہا ہے...';

  @override
  String get photo => 'تصویر';

  @override
  String get video => 'ویڈیو';

  @override
  String get outOf => 'میں سے';

  @override
  String get deleteThisItem => 'اس آئٹم کو حذف کریں؟';

  @override
  String get deleteItemMessage =>
      'یہ آئٹم حال ہی میں حذف شدہ میں منتقل ہو جائے گا';

  @override
  String get close => 'بند کریں';

  @override
  String get done => 'مکمل';

  @override
  String unableToPlayVideo(String error) {
    return 'ویڈیو چلانے میں ناکام: $error';
  }

  @override
  String get clearAll => 'سب صاف کریں';
}
