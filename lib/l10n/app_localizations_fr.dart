// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Galerie Swipe Clean';

  @override
  String get splashTitle => 'Galerie Swipe Clean';

  @override
  String get splashSubtitle => 'Balayez pour organiser vos souvenirs';

  @override
  String get splashSwipeHint => 'Balayez pour nettoyer';

  @override
  String get languageSelectionTitle => 'Choisissez votre langue';

  @override
  String get languageSelectionSubtitle =>
      'Sélectionnez votre langue préférée pour continuer';

  @override
  String get continueButton => 'Continuer';

  @override
  String get permissionRequired => 'Permission requise';

  @override
  String get accessYourPhotos => 'Accédez à vos photos';

  @override
  String get permissionDeniedMessage =>
      'Cette application nécessite un accès complet à vos photos et au stockage pour fonctionner. Sans permission, vous ne pouvez pas utiliser l\'application. Veuillez appuyer sur le bouton ci-dessous pour accorder l\'accès dans les Paramètres.';

  @override
  String get permissionMessage =>
      'Photo Swipe a besoin de la permission de voir et de gérer les photos sur votre appareil. Balayez pour parcourir, balayez vers le haut pour supprimer.';

  @override
  String get appCannotBeUsed =>
      'L\'application ne peut pas être utilisée sans permission';

  @override
  String get allowAccess => 'Autoriser l\'accès';

  @override
  String get openSettings => 'Ouvrir les paramètres';

  @override
  String get fullAccessRequired => 'Accès complet requis';

  @override
  String get fullAccessMessage =>
      'Cette application nécessite un accès complet aux photos pour fonctionner correctement. Veuillez accorder un accès complet dans les Paramètres.';

  @override
  String get ok => 'OK';

  @override
  String get enableAllFilesAccess =>
      'Veuillez activer Accès à tous les fichiers dans les Paramètres pour utiliser cette application';

  @override
  String get yourPhotos => 'Vos photos';

  @override
  String get loadingPhotos => 'Chargement de vos photos...';

  @override
  String get noPhotosFound => 'Aucune photo trouvée';

  @override
  String get galleryRefreshed => 'Galerie actualisée';

  @override
  String errorLoadingGallery(String error) {
    return 'Erreur lors du chargement de la galerie : $error';
  }

  @override
  String get exitGallery => 'Quitter la galerie';

  @override
  String get exitWithoutCleaningMessage =>
      'Vous partez sans nettoyer. Revenez bientôt !';

  @override
  String get cancel => 'Annuler';

  @override
  String get exit => 'Quitter';

  @override
  String filesDeleted(int count, String plural) {
    return '$count fichier$plural supprimé$plural avec succès';
  }

  @override
  String get freedUpSpace =>
      'Vous avez libéré de l\'espace ! Continuer ou quitter ?';

  @override
  String get keepCleaning => 'Continuer le nettoyage';

  @override
  String get settings => 'Paramètres';

  @override
  String get language => 'Langue';

  @override
  String get changeLanguage => 'Changer de langue';

  @override
  String get currentLanguage => 'Langue actuelle';

  @override
  String get selectLanguage => 'Sélectionner la langue';

  @override
  String get languageChanged => 'Langue changée avec succès';

  @override
  String get systemDefault => 'Par défaut du système';

  @override
  String get recentlyDeleted => 'Supprimés récemment';

  @override
  String get delete => 'Supprimer';

  @override
  String get restore => 'Restaurer';

  @override
  String get deleteForever => 'Supprimer définitivement';

  @override
  String get confirm => 'Confirmer';

  @override
  String get deleteConfirmation =>
      'Êtes-vous sûr de vouloir supprimer cet élément ?';

  @override
  String get permanentDeleteConfirmation =>
      'Cette action ne peut pas être annulée. Êtes-vous sûr ?';

  @override
  String get itemRestored => 'Élément restauré avec succès';

  @override
  String get itemDeleted => 'Élément supprimé définitivement';

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
  String get today => 'Aujourd\'hui';

  @override
  String get yesterday => 'Hier';

  @override
  String get thisWeek => 'Cette semaine';

  @override
  String get thisMonth => 'Ce mois';

  @override
  String get january => 'Janvier';

  @override
  String get february => 'Février';

  @override
  String get march => 'Mars';

  @override
  String get april => 'Avril';

  @override
  String get may => 'Mai';

  @override
  String get june => 'Juin';

  @override
  String get july => 'Juillet';

  @override
  String get august => 'Août';

  @override
  String get september => 'Septembre';

  @override
  String get october => 'Octobre';

  @override
  String get november => 'Novembre';

  @override
  String get december => 'Décembre';

  @override
  String daysAgo(int count) {
    return 'Il y a $count jours';
  }

  @override
  String weeksAgo(int count, String plural) {
    return 'Il y a $count semaine$plural';
  }

  @override
  String monthsAgo(int count, String plural) {
    return 'Il y a $count mois';
  }

  @override
  String get selectAll => 'Tout sélectionner';

  @override
  String get deselectAll => 'Tout désélectionner';

  @override
  String get selectedCount => 'sélectionné(s)';

  @override
  String get restoreSelected => 'Restaurer la sélection';

  @override
  String get deleteSelected => 'Supprimer la sélection';

  @override
  String get emptyTrash => 'Vider la corbeille';

  @override
  String get noDeletedItems => 'Aucun élément supprimé';

  @override
  String get deletedItemsMessage =>
      'Les éléments supprimés seront conservés pendant 30 jours';

  @override
  String confirmRestore(int count, String plural) {
    return 'Restaurer $count élément$plural ?';
  }

  @override
  String confirmDelete(int count, String plural) {
    return 'Supprimer définitivement $count élément$plural ?';
  }

  @override
  String get confirmEmptyTrash => 'Vider la corbeille ?';

  @override
  String confirmEmptyTrashMessage(int count) {
    return 'Cela supprimera définitivement tous les $count éléments. Cette action ne peut pas être annulée.';
  }

  @override
  String itemsRestored(int count, String plural) {
    return '$count élément$plural restauré$plural';
  }

  @override
  String itemsDeleted(int count, String plural) {
    return '$count élément$plural supprimé$plural définitivement';
  }

  @override
  String get trashEmptied => 'Corbeille vidée avec succès';

  @override
  String get imageDeleted => 'Image supprimée';

  @override
  String get videoDeleted => 'Vidéo supprimée';

  @override
  String get deletedSuccessfully => 'Supprimé avec succès';

  @override
  String get restoredSuccessfully => 'Restauré avec succès';

  @override
  String get errorOccurred => 'Une erreur s\'est produite';

  @override
  String get swipeUpToDelete => 'Balayez vers le haut pour supprimer';

  @override
  String get releaseToDelete => 'Relâchez pour supprimer';

  @override
  String get deletingImage => 'Suppression...';

  @override
  String get photo => 'Photo';

  @override
  String get video => 'Vidéo';

  @override
  String get outOf => 'de';

  @override
  String get deleteThisItem => 'Supprimer cet élément ?';

  @override
  String get deleteItemMessage =>
      'Cet élément sera déplacé vers les éléments supprimés récemment';

  @override
  String get close => 'Fermer';

  @override
  String get done => 'Terminé';

  @override
  String unableToPlayVideo(String error) {
    return 'Impossible de lire la vidéo : $error';
  }

  @override
  String get clearAll => 'Tout effacer';

  @override
  String get noMoreCards => 'Vous êtes arrivé au bout';

  @override
  String get queueEmpty => 'Aucun élément en attente de suppression';
}
