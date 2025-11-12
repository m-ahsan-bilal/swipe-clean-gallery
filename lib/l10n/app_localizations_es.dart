// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Galería Swipe Clean';

  @override
  String get splashTitle => 'Galería Swipe Clean';

  @override
  String get splashSubtitle => 'Desliza para organizar tus recuerdos';

  @override
  String get splashSwipeHint => 'Desliza para limpiar';

  @override
  String get languageSelectionTitle => 'Elige tu idioma';

  @override
  String get languageSelectionSubtitle =>
      'Selecciona tu idioma preferido para continuar';

  @override
  String get continueButton => 'Continuar';

  @override
  String get permissionRequired => 'Permiso requerido';

  @override
  String get accessYourPhotos => 'Accede a tus fotos';

  @override
  String get permissionDeniedMessage =>
      'Esta aplicación requiere acceso completo a tus fotos y almacenamiento para funcionar. Sin permiso, no puedes usar la aplicación. Por favor, toca el botón de abajo para otorgar acceso en Configuración.';

  @override
  String get permissionMessage =>
      'Photo Swipe necesita permiso para ver y administrar fotos en tu dispositivo. Desliza para navegar, desliza hacia arriba para eliminar.';

  @override
  String get appCannotBeUsed => 'La aplicación no se puede usar sin permiso';

  @override
  String get allowAccess => 'Permitir acceso';

  @override
  String get openSettings => 'Abrir configuración';

  @override
  String get fullAccessRequired => 'Acceso completo requerido';

  @override
  String get fullAccessMessage =>
      'Esta aplicación requiere acceso completo a las fotos para funcionar correctamente. Por favor, otorga acceso completo en Configuración.';

  @override
  String get ok => 'Aceptar';

  @override
  String get enableAllFilesAccess =>
      'Por favor, habilita Acceso a todos los archivos en Configuración para usar esta aplicación';

  @override
  String get yourPhotos => 'Tus fotos';

  @override
  String get loadingPhotos => 'Cargando tus fotos...';

  @override
  String get noPhotosFound => 'No se encontraron fotos';

  @override
  String get galleryRefreshed => 'Galería actualizada';

  @override
  String errorLoadingGallery(String error) {
    return 'Error al cargar la galería: $error';
  }

  @override
  String get exitGallery => 'Salir de la galería';

  @override
  String get exitWithoutCleaningMessage =>
      'Te vas sin limpiar. ¡Vuelve pronto!';

  @override
  String get cancel => 'Cancelar';

  @override
  String get yes => 'Sí';

  @override
  String get no => 'No';

  @override
  String get onboardingWelcomeTitle => 'Bienvenido a SnapBin Gallery';

  @override
  String get onboardingWelcomeSubtitle =>
      'Tu experiencia de galería inteligente y animada.';

  @override
  String get onboardingSwipeTitle => 'Explora tu galería';

  @override
  String get onboardingSwipeSubtitle =>
      'Desliza a la izquierda o derecha para navegar por tus fotos y videos.';

  @override
  String get onboardingDeleteTitle => 'Desliza hacia arriba para eliminar';

  @override
  String get onboardingDeleteSubtitle =>
      'Una animación de papel plegado envía tu archivo al contenedor: rápido, limpio y divertido.';

  @override
  String get onboardingOrganizeTitle => 'Mantente organizado';

  @override
  String get onboardingOrganizeSubtitle =>
      'Toca el ícono del contenedor para revisar o eliminar elementos permanentemente.';

  @override
  String get onboardingSkip => 'Saltar';

  @override
  String get onboardingNext => 'Siguiente';

  @override
  String get onboardingDone => 'Empezar';

  @override
  String get theme => 'Tema';

  @override
  String get themeModeLabel => 'Modo de tema';

  @override
  String get themeDark => 'Modo oscuro';

  @override
  String get themeLight => 'Modo claro';

  @override
  String get about => 'Acerca de';

  @override
  String get exit => 'Salir';

  @override
  String filesDeleted(int count, String plural) {
    return '$count archivo$plural eliminado$plural correctamente';
  }

  @override
  String get freedUpSpace => '¡Has liberado espacio! ¿Continuar o salir?';

  @override
  String get keepCleaning => 'Seguir limpiando';

  @override
  String get settings => 'Configuración';

  @override
  String get language => 'Idioma';

  @override
  String get changeLanguage => 'Cambiar idioma';

  @override
  String get currentLanguage => 'Idioma actual';

  @override
  String get selectLanguage => 'Seleccionar idioma';

  @override
  String get languageChanged => 'Idioma cambiado correctamente';

  @override
  String get systemDefault => 'Predeterminado del sistema';

  @override
  String get recentlyDeleted => 'Eliminados recientemente';

  @override
  String get delete => 'Eliminar';

  @override
  String get restore => 'Restaurar';

  @override
  String get deleteForever => 'Eliminar para siempre';

  @override
  String get confirm => 'Confirmar';

  @override
  String get deleteConfirmation =>
      '¿Estás seguro de que quieres eliminar este elemento?';

  @override
  String get permanentDeleteConfirmation =>
      'Esta acción no se puede deshacer. ¿Estás seguro?';

  @override
  String get itemRestored => 'Elemento restaurado correctamente';

  @override
  String get itemDeleted => 'Elemento eliminado permanentemente';

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
  String get today => 'Hoy';

  @override
  String get yesterday => 'Ayer';

  @override
  String get thisWeek => 'Esta semana';

  @override
  String get thisMonth => 'Este mes';

  @override
  String get january => 'Enero';

  @override
  String get february => 'Febrero';

  @override
  String get march => 'Marzo';

  @override
  String get april => 'Abril';

  @override
  String get may => 'Mayo';

  @override
  String get june => 'Junio';

  @override
  String get july => 'Julio';

  @override
  String get august => 'Agosto';

  @override
  String get september => 'Septiembre';

  @override
  String get october => 'Octubre';

  @override
  String get november => 'Noviembre';

  @override
  String get december => 'Diciembre';

  @override
  String daysAgo(int count) {
    return 'Hace $count días';
  }

  @override
  String weeksAgo(int count, String plural) {
    return 'Hace $count semana$plural';
  }

  @override
  String monthsAgo(int count, String plural) {
    return 'Hace $count mes$plural';
  }

  @override
  String get selectAll => 'Seleccionar todo';

  @override
  String get deselectAll => 'Deseleccionar todo';

  @override
  String get selectedCount => 'seleccionados';

  @override
  String get restoreSelected => 'Restaurar seleccionados';

  @override
  String get deleteSelected => 'Eliminar seleccionados';

  @override
  String get emptyTrash => 'Vaciar papelera';

  @override
  String get noDeletedItems => 'No hay elementos eliminados';

  @override
  String get deletedItemsMessage =>
      'Los elementos eliminados se conservarán durante 30 días';

  @override
  String confirmRestore(int count, String plural) {
    return '¿Restaurar $count elemento$plural?';
  }

  @override
  String confirmDelete(int count, String plural) {
    return '¿Eliminar permanentemente $count elemento$plural?';
  }

  @override
  String get confirmEmptyTrash => '¿Vaciar papelera?';

  @override
  String confirmEmptyTrashMessage(int count) {
    return 'Esto eliminará permanentemente todos los $count elementos. Esta acción no se puede deshacer.';
  }

  @override
  String itemsRestored(int count, String plural) {
    return '$count elemento$plural restaurado$plural';
  }

  @override
  String itemsDeleted(int count, String plural) {
    return '$count elemento$plural eliminado$plural permanentemente';
  }

  @override
  String get trashEmptied => 'Papelera vaciada correctamente';

  @override
  String get imageDeleted => 'Imagen eliminada';

  @override
  String get videoDeleted => 'Video eliminado';

  @override
  String get deletedSuccessfully => 'Eliminado correctamente';

  @override
  String get restoredSuccessfully => 'Restaurado correctamente';

  @override
  String get errorOccurred => 'Ocurrió un error';

  @override
  String get swipeUpToDelete => 'Desliza hacia arriba para eliminar';

  @override
  String get releaseToDelete => 'Suelta para eliminar';

  @override
  String get deletingImage => 'Eliminando...';

  @override
  String get photo => 'Foto';

  @override
  String get video => 'Video';

  @override
  String get outOf => 'de';

  @override
  String get deleteThisItem => '¿Eliminar este elemento?';

  @override
  String get deleteItemMessage =>
      'Este elemento se moverá a eliminados recientemente';

  @override
  String get close => 'Cerrar';

  @override
  String get done => 'Listo';

  @override
  String unableToPlayVideo(String error) {
    return 'No se puede reproducir el video: $error';
  }

  @override
  String get clearAll => 'Borrar todo';

  @override
  String get noMoreCards => 'Has llegado al final';

  @override
  String get queueEmpty => 'No hay elementos pendientes por eliminar';

  @override
  String get aboutAppName => 'SwipeClean Galería';

  @override
  String aboutVersion(String version) {
    return 'Versión $version';
  }

  @override
  String get aboutDescription =>
      'SwipeClean Galería está diseñada para hacer que limpiar tu biblioteca multimedia sea sin esfuerzo. Desliza a través de tus fotos y videos con animaciones fluidas, ponlos en cola para eliminar y disfruta de efectos de celebración cuando liberes espacio.';

  @override
  String get aboutKeyFeatures => 'Características principales';

  @override
  String get aboutFeature1 =>
      'Pila de tarjetas estilo Tinder para explorar medios de uno en uno.';

  @override
  String get aboutFeature2 =>
      'Gestos de deslizamiento para navegación rápida y animaciones de eliminación satisfactorias.';

  @override
  String get aboutFeature3 =>
      'Experiencia localizada con soporte para múltiples idiomas y diseños de derecha a izquierda.';

  @override
  String get aboutFeature4 =>
      'Temas personalizables para que puedas elegir entre modos claro y oscuro.';

  @override
  String get aboutClosing =>
      'Construimos SwipeClean Galería para combinar rendimiento, accesibilidad y un poco de alegría. ¡Gracias por probarlo!';
}
