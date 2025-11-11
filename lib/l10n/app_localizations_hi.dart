// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'स्वाइप क्लीन गैलरी';

  @override
  String get splashTitle => 'स्वाइप क्लीन गैलरी';

  @override
  String get splashSubtitle =>
      'अपनी यादों को व्यवस्थित करने के लिए स्वाइप करें';

  @override
  String get splashSwipeHint => 'साफ करने के लिए स्वाइप करें';

  @override
  String get languageSelectionTitle => 'अपनी भाषा चुनें';

  @override
  String get languageSelectionSubtitle =>
      'जारी रखने के लिए अपनी पसंदीदा भाषा चुनें';

  @override
  String get continueButton => 'जारी रखें';

  @override
  String get permissionRequired => 'अनुमति आवश्यक है';

  @override
  String get accessYourPhotos => 'अपनी तस्वीरों तक पहुंचें';

  @override
  String get permissionDeniedMessage =>
      'इस ऐप को काम करने के लिए आपकी तस्वीरों और स्टोरेज तक पूर्ण पहुंच की आवश्यकता है। अनुमति के बिना, आप इस ऐप का उपयोग नहीं कर सकते। कृपया सेटिंग्स में पहुंच देने के लिए नीचे बटन दबाएं।';

  @override
  String get permissionMessage =>
      'फोटो स्वाइप को आपके डिवाइस पर तस्वीरें देखने और प्रबंधित करने की अनुमति की आवश्यकता है। ब्राउज़ करने के लिए स्वाइप करें, हटाने के लिए ऊपर स्वाइप करें।';

  @override
  String get appCannotBeUsed => 'अनुमति के बिना ऐप का उपयोग नहीं किया जा सकता';

  @override
  String get allowAccess => 'पहुंच की अनुमति दें';

  @override
  String get openSettings => 'सेटिंग्स खोलें';

  @override
  String get fullAccessRequired => 'पूर्ण पहुंच आवश्यक है';

  @override
  String get fullAccessMessage =>
      'इस ऐप को ठीक से काम करने के लिए तस्वीरों की पूर्ण पहुंच की आवश्यकता है। कृपया सेटिंग्स में पूर्ण पहुंच दें।';

  @override
  String get ok => 'ठीक है';

  @override
  String get enableAllFilesAccess =>
      'इस ऐप का उपयोग करने के लिए कृपया सेटिंग्स में सभी फ़ाइलों तक पहुंच सक्षम करें';

  @override
  String get yourPhotos => 'आपकी तस्वीरें';

  @override
  String get loadingPhotos => 'आपकी तस्वीरें लोड हो रही हैं...';

  @override
  String get noPhotosFound => 'कोई तस्वीरें नहीं मिलीं';

  @override
  String get galleryRefreshed => 'गैलरी ताज़ा हो गई';

  @override
  String errorLoadingGallery(String error) {
    return 'गैलरी लोड करने में त्रुटि: $error';
  }

  @override
  String get exitGallery => 'गैलरी से बाहर निकलें';

  @override
  String get exitWithoutCleaningMessage =>
      'आप साफ किए बिना जा रहे हैं। जल्द वापस आएं!';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get exit => 'बाहर निकलें';

  @override
  String filesDeleted(int count, String plural) {
    return '$count फ़ाइल$plural सफलतापूर्वक हटाई गई';
  }

  @override
  String get freedUpSpace =>
      'आपने जगह खाली कर ली है! जारी रखें या बाहर निकलें?';

  @override
  String get keepCleaning => 'साफ करते रहें';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get language => 'भाषा';

  @override
  String get changeLanguage => 'भाषा बदलें';

  @override
  String get currentLanguage => 'वर्तमान भाषा';

  @override
  String get selectLanguage => 'भाषा चुनें';

  @override
  String get languageChanged => 'भाषा सफलतापूर्वक बदल गई';

  @override
  String get systemDefault => 'सिस्टम डिफ़ॉल्ट';

  @override
  String get recentlyDeleted => 'हाल ही में हटाए गए';

  @override
  String get delete => 'हटाएं';

  @override
  String get restore => 'पुनर्स्थापित करें';

  @override
  String get deleteForever => 'हमेशा के लिए हटाएं';

  @override
  String get confirm => 'पुष्टि करें';

  @override
  String get deleteConfirmation => 'क्या आप वाकई इस आइटम को हटाना चाहते हैं?';

  @override
  String get permanentDeleteConfirmation =>
      'यह कार्रवाई पूर्ववत नहीं की जा सकती। क्या आप सुनिश्चित हैं?';

  @override
  String get itemRestored => 'आइटम सफलतापूर्वक पुनर्स्थापित किया गया';

  @override
  String get itemDeleted => 'आइटम स्थायी रूप से हटा दिया गया';

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
  String get today => 'आज';

  @override
  String get yesterday => 'कल';

  @override
  String get thisWeek => 'इस सप्ताह';

  @override
  String get thisMonth => 'इस महीने';

  @override
  String get january => 'जनवरी';

  @override
  String get february => 'फरवरी';

  @override
  String get march => 'मार्च';

  @override
  String get april => 'अप्रैल';

  @override
  String get may => 'मई';

  @override
  String get june => 'जून';

  @override
  String get july => 'जुलाई';

  @override
  String get august => 'अगस्त';

  @override
  String get september => 'सितंबर';

  @override
  String get october => 'अक्टूबर';

  @override
  String get november => 'नवंबर';

  @override
  String get december => 'दिसंबर';

  @override
  String daysAgo(int count) {
    return '$count दिन पहले';
  }

  @override
  String weeksAgo(int count, String plural) {
    return '$count सप्ताह$plural पहले';
  }

  @override
  String monthsAgo(int count, String plural) {
    return '$count महीने$plural पहले';
  }

  @override
  String get selectAll => 'सभी चुनें';

  @override
  String get deselectAll => 'सभी अचयनित करें';

  @override
  String get selectedCount => 'चयनित';

  @override
  String get restoreSelected => 'चयनित पुनर्स्थापित करें';

  @override
  String get deleteSelected => 'चयनित हटाएं';

  @override
  String get emptyTrash => 'ट्रैश खाली करें';

  @override
  String get noDeletedItems => 'कोई हटाए गए आइटम नहीं';

  @override
  String get deletedItemsMessage => 'हटाए गए आइटम 30 दिनों तक रखे जाएंगे';

  @override
  String confirmRestore(int count, String plural) {
    return '$count आइटम$plural पुनर्स्थापित करें?';
  }

  @override
  String confirmDelete(int count, String plural) {
    return '$count आइटम$plural स्थायी रूप से हटाएं?';
  }

  @override
  String get confirmEmptyTrash => 'ट्रैश खाली करें?';

  @override
  String confirmEmptyTrashMessage(int count) {
    return 'यह सभी $count आइटमों को स्थायी रूप से हटा देगा। इस क्रिया को पूर्ववत नहीं किया जा सकता।';
  }

  @override
  String itemsRestored(int count, String plural) {
    return '$count आइटम$plural पुनर्स्थापित';
  }

  @override
  String itemsDeleted(int count, String plural) {
    return '$count आइटम$plural स्थायी रूप से हटाए गए';
  }

  @override
  String get trashEmptied => 'ट्रैश सफलतापूर्वक खाली किया गया';

  @override
  String get imageDeleted => 'छवि हटाई गई';

  @override
  String get videoDeleted => 'वीडियो हटाया गया';

  @override
  String get deletedSuccessfully => 'सफलतापूर्वक हटाया गया';

  @override
  String get restoredSuccessfully => 'सफलतापूर्वक पुनर्स्थापित किया गया';

  @override
  String get errorOccurred => 'एक त्रुटि हुई';

  @override
  String get swipeUpToDelete => 'हटाने के लिए ऊपर स्वाइप करें';

  @override
  String get releaseToDelete => 'हटाने के लिए छोड़ें';

  @override
  String get deletingImage => 'हटा रहा है...';

  @override
  String get photo => 'फोटो';

  @override
  String get video => 'वीडियो';

  @override
  String get outOf => 'का';

  @override
  String get deleteThisItem => 'इस आइटम को हटाएं?';

  @override
  String get deleteItemMessage =>
      'यह आइटम हाल ही में हटाए गए में स्थानांतरित कर दिया जाएगा';

  @override
  String get close => 'बंद करें';

  @override
  String get done => 'पूर्ण';

  @override
  String unableToPlayVideo(String error) {
    return 'वीडियो चलाने में असमर्थ: $error';
  }

  @override
  String get clearAll => 'सभी साफ़ करें';

  @override
  String get noMoreCards => 'आप अंत तक पहुँच गए हैं';

  @override
  String get queueEmpty => 'हटाने के लिए कोई आइटम लंबित नहीं है';
}
