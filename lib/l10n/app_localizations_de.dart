// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Swipe Clean Galerie';

  @override
  String get splashTitle => 'Swipe Clean Galerie';

  @override
  String get splashSubtitle =>
      'Wischen Sie, um Ihre Erinnerungen zu organisieren';

  @override
  String get splashSwipeHint => 'Wischen zum Reinigen';

  @override
  String get languageSelectionTitle => 'Wählen Sie Ihre Sprache';

  @override
  String get languageSelectionSubtitle =>
      'Wählen Sie Ihre bevorzugte Sprache, um fortzufahren';

  @override
  String get continueButton => 'Fortfahren';

  @override
  String get permissionRequired => 'Berechtigung erforderlich';

  @override
  String get accessYourPhotos => 'Zugriff auf Ihre Fotos';

  @override
  String get permissionDeniedMessage =>
      'Diese App benötigt vollen Zugriff auf Ihre Fotos und Ihren Speicher, um zu funktionieren. Ohne Berechtigung können Sie die App nicht verwenden. Bitte tippen Sie auf die Schaltfläche unten, um den Zugriff in den Einstellungen zu gewähren.';

  @override
  String get permissionMessage =>
      'Photo Swipe benötigt die Berechtigung, um Fotos auf Ihrem Gerät anzuzeigen und zu verwalten. Wischen Sie zum Durchsuchen, wischen Sie nach oben zum Löschen.';

  @override
  String get appCannotBeUsed =>
      'App kann ohne Berechtigung nicht verwendet werden';

  @override
  String get allowAccess => 'Zugriff erlauben';

  @override
  String get openSettings => 'Einstellungen öffnen';

  @override
  String get fullAccessRequired => 'Vollzugriff erforderlich';

  @override
  String get fullAccessMessage =>
      'Diese App benötigt vollen Fotozugriff, um ordnungsgemäß zu funktionieren. Bitte gewähren Sie vollen Zugriff in den Einstellungen.';

  @override
  String get ok => 'OK';

  @override
  String get enableAllFilesAccess =>
      'Bitte aktivieren Sie Zugriff auf alle Dateien in den Einstellungen, um diese App zu verwenden';

  @override
  String get yourPhotos => 'Ihre Fotos';

  @override
  String get loadingPhotos => 'Ihre Fotos werden geladen...';

  @override
  String get noPhotosFound => 'Keine Fotos gefunden';

  @override
  String get galleryRefreshed => 'Galerie aktualisiert';

  @override
  String errorLoadingGallery(String error) {
    return 'Fehler beim Laden der Galerie: $error';
  }

  @override
  String get exitGallery => 'Galerie verlassen';

  @override
  String get exitWithoutCleaningMessage =>
      'Sie gehen ohne zu reinigen. Kommen Sie bald wieder!';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get exit => 'Beenden';

  @override
  String filesDeleted(int count, String plural) {
    return '$count Datei$plural erfolgreich gelöscht';
  }

  @override
  String get freedUpSpace =>
      'Sie haben Platz geschaffen! Fortfahren oder beenden?';

  @override
  String get keepCleaning => 'Weiter reinigen';

  @override
  String get settings => 'Einstellungen';

  @override
  String get language => 'Sprache';

  @override
  String get changeLanguage => 'Sprache ändern';

  @override
  String get currentLanguage => 'Aktuelle Sprache';

  @override
  String get selectLanguage => 'Sprache auswählen';

  @override
  String get languageChanged => 'Sprache erfolgreich geändert';

  @override
  String get systemDefault => 'Systemstandard';

  @override
  String get recentlyDeleted => 'Kürzlich gelöscht';

  @override
  String get delete => 'Löschen';

  @override
  String get restore => 'Wiederherstellen';

  @override
  String get deleteForever => 'Für immer löschen';

  @override
  String get confirm => 'Bestätigen';

  @override
  String get deleteConfirmation =>
      'Sind Sie sicher, dass Sie dieses Element löschen möchten?';

  @override
  String get permanentDeleteConfirmation =>
      'Diese Aktion kann nicht rückgängig gemacht werden. Sind Sie sicher?';

  @override
  String get itemRestored => 'Element erfolgreich wiederhergestellt';

  @override
  String get itemDeleted => 'Element dauerhaft gelöscht';

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
  String get today => 'Heute';

  @override
  String get yesterday => 'Gestern';

  @override
  String get thisWeek => 'Diese Woche';

  @override
  String get thisMonth => 'Diesen Monat';

  @override
  String get january => 'Januar';

  @override
  String get february => 'Februar';

  @override
  String get march => 'März';

  @override
  String get april => 'April';

  @override
  String get may => 'Mai';

  @override
  String get june => 'Juni';

  @override
  String get july => 'Juli';

  @override
  String get august => 'August';

  @override
  String get september => 'September';

  @override
  String get october => 'Oktober';

  @override
  String get november => 'November';

  @override
  String get december => 'Dezember';

  @override
  String daysAgo(int count) {
    return 'Vor $count Tagen';
  }

  @override
  String weeksAgo(int count, String plural) {
    return 'Vor $count Woche$plural';
  }

  @override
  String monthsAgo(int count, String plural) {
    return 'Vor $count Monat$plural';
  }

  @override
  String get selectAll => 'Alle auswählen';

  @override
  String get deselectAll => 'Alle abwählen';

  @override
  String get selectedCount => 'ausgewählt';

  @override
  String get restoreSelected => 'Ausgewählte wiederherstellen';

  @override
  String get deleteSelected => 'Ausgewählte löschen';

  @override
  String get emptyTrash => 'Papierkorb leeren';

  @override
  String get noDeletedItems => 'Keine gelöschten Elemente';

  @override
  String get deletedItemsMessage =>
      'Gelöschte Elemente werden 30 Tage lang aufbewahrt';

  @override
  String confirmRestore(int count, String plural) {
    return '$count Element$plural wiederherstellen?';
  }

  @override
  String confirmDelete(int count, String plural) {
    return '$count Element$plural dauerhaft löschen?';
  }

  @override
  String get confirmEmptyTrash => 'Papierkorb leeren?';

  @override
  String confirmEmptyTrashMessage(int count) {
    return 'Dies löscht alle $count Elemente dauerhaft. Diese Aktion kann nicht rückgängig gemacht werden.';
  }

  @override
  String itemsRestored(int count, String plural) {
    return '$count Element$plural wiederhergestellt';
  }

  @override
  String itemsDeleted(int count, String plural) {
    return '$count Element$plural dauerhaft gelöscht';
  }

  @override
  String get trashEmptied => 'Papierkorb erfolgreich geleert';

  @override
  String get imageDeleted => 'Bild gelöscht';

  @override
  String get videoDeleted => 'Video gelöscht';

  @override
  String get deletedSuccessfully => 'Erfolgreich gelöscht';

  @override
  String get restoredSuccessfully => 'Erfolgreich wiederhergestellt';

  @override
  String get errorOccurred => 'Ein Fehler ist aufgetreten';

  @override
  String get swipeUpToDelete => 'Nach oben wischen zum Löschen';

  @override
  String get releaseToDelete => 'Loslassen zum Löschen';

  @override
  String get deletingImage => 'Löschen...';

  @override
  String get photo => 'Foto';

  @override
  String get video => 'Video';

  @override
  String get outOf => 'von';

  @override
  String get deleteThisItem => 'Dieses Element löschen?';

  @override
  String get deleteItemMessage =>
      'Dieses Element wird zu kürzlich gelöscht verschoben';

  @override
  String get close => 'Schließen';

  @override
  String get done => 'Fertig';

  @override
  String unableToPlayVideo(String error) {
    return 'Video kann nicht abgespielt werden: $error';
  }

  @override
  String get clearAll => 'Alles löschen';
}
