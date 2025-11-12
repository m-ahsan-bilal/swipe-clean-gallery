// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '滑动清理相册';

  @override
  String get splashTitle => '滑动清理相册';

  @override
  String get splashSubtitle => '滑动整理您的回忆';

  @override
  String get splashSwipeHint => '滑动清理';

  @override
  String get languageSelectionTitle => '选择您的语言';

  @override
  String get languageSelectionSubtitle => '选择您喜欢的语言以继续';

  @override
  String get continueButton => '继续';

  @override
  String get permissionRequired => '需要权限';

  @override
  String get accessYourPhotos => '访问您的照片';

  @override
  String get permissionDeniedMessage =>
      '此应用需要完全访问您的照片和存储才能运行。没有权限，您无法使用该应用。请点击下面的按钮以在设置中授予访问权限。';

  @override
  String get permissionMessage => 'Photo Swipe 需要权限才能查看和管理您设备上的照片。滑动浏览，向上滑动删除。';

  @override
  String get appCannotBeUsed => '没有权限无法使用应用';

  @override
  String get allowAccess => '允许访问';

  @override
  String get openSettings => '打开设置';

  @override
  String get fullAccessRequired => '需要完全访问';

  @override
  String get fullAccessMessage => '此应用需要完全的照片访问权限才能正常运行。请在设置中授予完全访问权限。';

  @override
  String get ok => '确定';

  @override
  String get enableAllFilesAccess => '请在设置中启用 所有文件访问 以使用此应用';

  @override
  String get yourPhotos => '您的照片';

  @override
  String get loadingPhotos => '正在加载您的照片...';

  @override
  String get noPhotosFound => '未找到照片';

  @override
  String get galleryRefreshed => '相册已刷新';

  @override
  String errorLoadingGallery(String error) {
    return '加载相册时出错：$error';
  }

  @override
  String get exitGallery => '退出相册';

  @override
  String get exitWithoutCleaningMessage => '您在清理前离开。请尽快回来！';

  @override
  String get cancel => '取消';

  @override
  String get yes => '是';

  @override
  String get no => '否';

  @override
  String get onboardingWelcomeTitle => '欢迎使用 SnapBin Gallery';

  @override
  String get onboardingWelcomeSubtitle => '体验智能又富有动感的图库。';

  @override
  String get onboardingSwipeTitle => '浏览你的图库';

  @override
  String get onboardingSwipeSubtitle => '左右滑动即可查看所有照片和视频。';

  @override
  String get onboardingDeleteTitle => '上滑即可删除';

  @override
  String get onboardingDeleteSubtitle => '纸张折叠动画让删除变得快捷、干净又有趣！';

  @override
  String get onboardingOrganizeTitle => '轻松管理';

  @override
  String get onboardingOrganizeSubtitle => '轻点回收站图标即可查看或永久删除项目。';

  @override
  String get onboardingSkip => '跳过';

  @override
  String get onboardingNext => '下一步';

  @override
  String get onboardingDone => '开始使用';

  @override
  String get theme => '主题';

  @override
  String get themeModeLabel => '主题模式';

  @override
  String get themeDark => '深色模式';

  @override
  String get themeLight => '浅色模式';

  @override
  String get about => '关于';

  @override
  String get exit => '退出';

  @override
  String filesDeleted(int count, String plural) {
    return '已成功删除 $count 个文件$plural';
  }

  @override
  String get freedUpSpace => '您已释放空间！继续还是退出？';

  @override
  String get keepCleaning => '继续清理';

  @override
  String get settings => '设置';

  @override
  String get language => '语言';

  @override
  String get changeLanguage => '更改语言';

  @override
  String get currentLanguage => '当前语言';

  @override
  String get selectLanguage => '选择语言';

  @override
  String get languageChanged => '语言更改成功';

  @override
  String get systemDefault => '系统默认';

  @override
  String get recentlyDeleted => '最近删除';

  @override
  String get delete => '删除';

  @override
  String get restore => '恢复';

  @override
  String get deleteForever => '永久删除';

  @override
  String get confirm => '确认';

  @override
  String get deleteConfirmation => '您确定要删除此项吗？';

  @override
  String get permanentDeleteConfirmation => '此操作无法撤消。您确定吗？';

  @override
  String get itemRestored => '项目已成功恢复';

  @override
  String get itemDeleted => '项目已永久删除';

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
  String get today => '今天';

  @override
  String get yesterday => '昨天';

  @override
  String get thisWeek => '本周';

  @override
  String get thisMonth => '本月';

  @override
  String get january => '一月';

  @override
  String get february => '二月';

  @override
  String get march => '三月';

  @override
  String get april => '四月';

  @override
  String get may => '五月';

  @override
  String get june => '六月';

  @override
  String get july => '七月';

  @override
  String get august => '八月';

  @override
  String get september => '九月';

  @override
  String get october => '十月';

  @override
  String get november => '十一月';

  @override
  String get december => '十二月';

  @override
  String daysAgo(int count) {
    return '$count 天前';
  }

  @override
  String weeksAgo(int count, String plural) {
    return '$count 周$plural前';
  }

  @override
  String monthsAgo(int count, String plural) {
    return '$count 个月$plural前';
  }

  @override
  String get selectAll => '全选';

  @override
  String get deselectAll => '取消全选';

  @override
  String get selectedCount => '已选择';

  @override
  String get restoreSelected => '恢复所选';

  @override
  String get deleteSelected => '删除所选';

  @override
  String get emptyTrash => '清空回收站';

  @override
  String get noDeletedItems => '没有已删除的项目';

  @override
  String get deletedItemsMessage => '已删除的项目将保留30天';

  @override
  String confirmRestore(int count, String plural) {
    return '恢复 $count 个项目$plural？';
  }

  @override
  String confirmDelete(int count, String plural) {
    return '永久删除 $count 个项目$plural？';
  }

  @override
  String get confirmEmptyTrash => '清空回收站？';

  @override
  String confirmEmptyTrashMessage(int count) {
    return '这将永久删除所有 $count 个项目。此操作无法撤消。';
  }

  @override
  String itemsRestored(int count, String plural) {
    return '已恢复 $count 个项目$plural';
  }

  @override
  String itemsDeleted(int count, String plural) {
    return '已永久删除 $count 个项目$plural';
  }

  @override
  String get trashEmptied => '回收站已成功清空';

  @override
  String get imageDeleted => '图片已删除';

  @override
  String get videoDeleted => '视频已删除';

  @override
  String get deletedSuccessfully => '删除成功';

  @override
  String get restoredSuccessfully => '恢复成功';

  @override
  String get errorOccurred => '发生错误';

  @override
  String get swipeUpToDelete => '向上滑动删除';

  @override
  String get releaseToDelete => '松开删除';

  @override
  String get deletingImage => '正在删除...';

  @override
  String get photo => '照片';

  @override
  String get video => '视频';

  @override
  String get outOf => '的';

  @override
  String get deleteThisItem => '删除此项目？';

  @override
  String get deleteItemMessage => '此项目将移至最近删除';

  @override
  String get close => '关闭';

  @override
  String get done => '完成';

  @override
  String unableToPlayVideo(String error) {
    return '无法播放视频：$error';
  }

  @override
  String get clearAll => '全部清除';

  @override
  String get noMoreCards => '你已经到达末尾';

  @override
  String get queueEmpty => '没有待删除的项目';

  @override
  String get aboutAppName => '滑动清理相册';

  @override
  String aboutVersion(String version) {
    return '版本 $version';
  }

  @override
  String get aboutDescription =>
      '滑动清理相册旨在让清理您的媒体库变得轻松。通过流畅的动画浏览您的照片和视频，将它们排队删除，并在您清理空间时享受庆祝效果。';

  @override
  String get aboutKeyFeatures => '主要功能';

  @override
  String get aboutFeature1 => '类似Tinder的卡片堆叠，一次浏览一个媒体项目。';

  @override
  String get aboutFeature2 => '滑动手势实现快速导航和令人满意的删除动画。';

  @override
  String get aboutFeature3 => '支持多种语言和从右到左布局的本地化体验。';

  @override
  String get aboutFeature4 => '可自定义主题，您可以在浅色和深色模式之间进行选择。';

  @override
  String get aboutClosing => '我们构建了滑动清理相册，将性能、可访问性和一点乐趣相结合。感谢您的试用！';
}
