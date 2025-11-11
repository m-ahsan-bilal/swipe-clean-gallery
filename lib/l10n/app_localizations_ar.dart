// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'معرض المسح النظيف';

  @override
  String get splashTitle => 'معرض المسح النظيف';

  @override
  String get splashSubtitle => 'اسحب لتنظيم ذكرياتك';

  @override
  String get splashSwipeHint => 'اسحب للتنظيف';

  @override
  String get languageSelectionTitle => 'اختر لغتك';

  @override
  String get languageSelectionSubtitle => 'حدد لغتك المفضلة للمتابعة';

  @override
  String get continueButton => 'متابعة';

  @override
  String get permissionRequired => 'الإذن مطلوب';

  @override
  String get accessYourPhotos => 'الوصول إلى صورك';

  @override
  String get permissionDeniedMessage =>
      'يتطلب هذا التطبيق وصولاً كاملاً إلى صورك والتخزين للعمل. بدون إذن، لا يمكنك استخدام التطبيق. يرجى النقر على الزر أدناه لمنح الوصول في الإعدادات.';

  @override
  String get permissionMessage =>
      'تحتاج مسح الصور إلى إذن لعرض وإدارة الصور على جهازك. اسحب للتصفح، اسحب لأعلى للحذف.';

  @override
  String get appCannotBeUsed => 'لا يمكن استخدام التطبيق بدون إذن';

  @override
  String get allowAccess => 'السماح بالوصول';

  @override
  String get openSettings => 'فتح الإعدادات';

  @override
  String get fullAccessRequired => 'الوصول الكامل مطلوب';

  @override
  String get fullAccessMessage =>
      'يتطلب هذا التطبيق وصولاً كاملاً إلى الصور للعمل بشكل صحيح. يرجى منح الوصول الكامل في الإعدادات.';

  @override
  String get ok => 'موافق';

  @override
  String get enableAllFilesAccess =>
      'يرجى تمكين الوصول إلى جميع الملفات في الإعدادات لاستخدام هذا التطبيق';

  @override
  String get yourPhotos => 'صورك';

  @override
  String get loadingPhotos => 'جاري تحميل صورك...';

  @override
  String get noPhotosFound => 'لم يتم العثور على صور';

  @override
  String get galleryRefreshed => 'تم تحديث المعرض';

  @override
  String errorLoadingGallery(String error) {
    return 'خطأ في تحميل المعرض: $error';
  }

  @override
  String get exitGallery => 'الخروج من المعرض';

  @override
  String get exitWithoutCleaningMessage => 'أنت تغادر دون تنظيف. عد قريباً!';

  @override
  String get cancel => 'إلغاء';

  @override
  String get exit => 'خروج';

  @override
  String filesDeleted(int count, String plural) {
    return 'تم حذف $count ملف$plural بنجاح';
  }

  @override
  String get freedUpSpace =>
      'لقد قمت بتحرير مساحة! هل تريد المتابعة أم الخروج؟';

  @override
  String get keepCleaning => 'استمر في التنظيف';

  @override
  String get settings => 'الإعدادات';

  @override
  String get language => 'اللغة';

  @override
  String get changeLanguage => 'تغيير اللغة';

  @override
  String get currentLanguage => 'اللغة الحالية';

  @override
  String get selectLanguage => 'اختر اللغة';

  @override
  String get languageChanged => 'تم تغيير اللغة بنجاح';

  @override
  String get systemDefault => 'افتراضي النظام';

  @override
  String get recentlyDeleted => 'المحذوفة مؤخراً';

  @override
  String get delete => 'حذف';

  @override
  String get restore => 'استعادة';

  @override
  String get deleteForever => 'حذف نهائياً';

  @override
  String get confirm => 'تأكيد';

  @override
  String get deleteConfirmation => 'هل أنت متأكد أنك تريد حذف هذا العنصر؟';

  @override
  String get permanentDeleteConfirmation =>
      'لا يمكن التراجع عن هذا الإجراء. هل أنت متأكد؟';

  @override
  String get itemRestored => 'تمت استعادة العنصر بنجاح';

  @override
  String get itemDeleted => 'تم حذف العنصر نهائياً';

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
  String get today => 'اليوم';

  @override
  String get yesterday => 'أمس';

  @override
  String get thisWeek => 'هذا الأسبوع';

  @override
  String get thisMonth => 'هذا الشهر';

  @override
  String get january => 'يناير';

  @override
  String get february => 'فبراير';

  @override
  String get march => 'مارس';

  @override
  String get april => 'أبريل';

  @override
  String get may => 'مايو';

  @override
  String get june => 'يونيو';

  @override
  String get july => 'يوليو';

  @override
  String get august => 'أغسطس';

  @override
  String get september => 'سبتمبر';

  @override
  String get october => 'أكتوبر';

  @override
  String get november => 'نوفمبر';

  @override
  String get december => 'ديسمبر';

  @override
  String daysAgo(int count) {
    return 'منذ $count أيام';
  }

  @override
  String weeksAgo(int count, String plural) {
    return 'منذ $count أسبوع$plural';
  }

  @override
  String monthsAgo(int count, String plural) {
    return 'منذ $count شهر$plural';
  }

  @override
  String get selectAll => 'تحديد الكل';

  @override
  String get deselectAll => 'إلغاء تحديد الكل';

  @override
  String get selectedCount => 'محددة';

  @override
  String get restoreSelected => 'استعادة المحدد';

  @override
  String get deleteSelected => 'حذف المحدد';

  @override
  String get emptyTrash => 'إفراغ سلة المهملات';

  @override
  String get noDeletedItems => 'لا توجد عناصر محذوفة';

  @override
  String get deletedItemsMessage => 'ستبقى العناصر المحذوفة لمدة 30 يوماً';

  @override
  String confirmRestore(int count, String plural) {
    return 'استعادة $count عنصر$plural؟';
  }

  @override
  String confirmDelete(int count, String plural) {
    return 'حذف $count عنصر$plural نهائياً؟';
  }

  @override
  String get confirmEmptyTrash => 'إفراغ سلة المهملات؟';

  @override
  String confirmEmptyTrashMessage(int count) {
    return 'سيؤدي هذا إلى حذف جميع العناصر الـ $count نهائياً. لا يمكن التراجع عن هذا الإجراء.';
  }

  @override
  String itemsRestored(int count, String plural) {
    return 'تمت استعادة $count عنصر$plural';
  }

  @override
  String itemsDeleted(int count, String plural) {
    return 'تم حذف $count عنصر$plural نهائياً';
  }

  @override
  String get trashEmptied => 'تم إفراغ سلة المهملات بنجاح';

  @override
  String get imageDeleted => 'تم حذف الصورة';

  @override
  String get videoDeleted => 'تم حذف الفيديو';

  @override
  String get deletedSuccessfully => 'تم الحذف بنجاح';

  @override
  String get restoredSuccessfully => 'تمت الاستعادة بنجاح';

  @override
  String get errorOccurred => 'حدث خطأ';

  @override
  String get swipeUpToDelete => 'اسحب لأعلى للحذف';

  @override
  String get releaseToDelete => 'اترك للحذف';

  @override
  String get deletingImage => 'جارٍ الحذف...';

  @override
  String get photo => 'صورة';

  @override
  String get video => 'فيديو';

  @override
  String get outOf => 'من';

  @override
  String get deleteThisItem => 'حذف هذا العنصر؟';

  @override
  String get deleteItemMessage => 'سيتم نقل هذا العنصر إلى المحذوفة مؤخراً';

  @override
  String get close => 'إغلاق';

  @override
  String get done => 'تم';

  @override
  String unableToPlayVideo(String error) {
    return 'تعذر تشغيل الفيديو: $error';
  }

  @override
  String get clearAll => 'مسح الكل';

  @override
  String get noMoreCards => 'لقد وصلت إلى النهاية';

  @override
  String get queueEmpty => 'لا توجد عناصر محددة للحذف';
}
