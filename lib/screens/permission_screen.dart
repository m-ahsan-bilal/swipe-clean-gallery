import 'package:flutter/material.dart';
import 'package:swipe_clean_gallery/l10n/app_localizations.dart';
import '../services/permission_service.dart';
import 'gallery_screen.dart';

class PermissionScreen extends StatefulWidget {
  const PermissionScreen({super.key});

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> with WidgetsBindingObserver {
  bool _isPermissionDenied = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkPermissions();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Check permissions when app resumes from settings
    if (state == AppLifecycleState.resumed) {
      _checkPermissions();
    }
  }

  Future<void> _checkPermissions() async {
    final hasPermission = await PermissionService.hasAllPermissions();
    if (!mounted) return;
    
    if (hasPermission) {
      // Navigate to gallery if permissions are granted
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const GalleryScreen()),
      );
    } else {
      // Show permission request UI
      setState(() => _isPermissionDenied = false);
    }
  }

  Future<void> _requestPermission() async {
    setState(() => _isLoading = true);
    
    final status = await PermissionService.requestPermission(context);
    
    if (!mounted) return;
    
    setState(() => _isLoading = false);

    // After permission request, wait a moment and check again
    // This handles the case where user granted permission in settings
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    
    final hasAllPermissions = await PermissionService.hasAllPermissions();
    
    if (hasAllPermissions) {
      // Navigate to gallery if all permissions are now granted
      if (mounted) {
        PermissionService.navigateToGallery(context);
      }
      return;
    }

    switch (status) {
      case PermissionStatus.granted:
        // Navigate to gallery
        PermissionService.navigateToGallery(context);
        break;
      
      case PermissionStatus.denied:
      case PermissionStatus.permanentlyDenied:
        // Show error state with instructions
        setState(() => _isPermissionDenied = true);
        if (mounted) {
          _showDeniedInstructions();
        }
        break;
      
      case PermissionStatus.limited:
        // Show dialog explaining full access is needed
        if (mounted) {
          await _showLimitedAccessDialog();
        }
        setState(() => _isPermissionDenied = true);
        break;
    }
  }

  void _showDeniedInstructions() {
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.enableAllFilesAccess),
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _showLimitedAccessDialog() async {
    final l10n = AppLocalizations.of(context)!;
    return showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l10n.fullAccessRequired),
        content: Text(l10n.fullAccessMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.ok),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFF0F1417),
      body: SafeArea(
        child: SizedBox(
          width: width,
          height: height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Container(
                    width: width,
                    height: height * 0.32,
                    padding: const EdgeInsets.all(16),
                    color: const Color(0xFF0F1417),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: const DecorationImage(
                          image: AssetImage('assets/images/sample.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _isPermissionDenied ? l10n.permissionRequired : l10n.accessYourPhotos,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                      height: 1.25,
                      color: _isPermissionDenied ? Colors.red[300] : Colors.white,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 12,
                    ),
                    child: Text(
                      _isPermissionDenied
                          ? l10n.permissionDeniedMessage
                          : l10n.permissionMessage,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        height: 1.5,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  if (_isPermissionDenied)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.red.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: Colors.red[300],
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                l10n.appCannotBeUsed,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isPermissionDenied 
                          ? Colors.red[700] 
                          : const Color(0xFF0A8AFF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    onPressed: _isLoading ? null : () async {
                      if (_isPermissionDenied) {
                        // Open app settings
                        await PermissionService.openAppSettings();
                      } else {
                        // Request permission
                        await _requestPermission();
                      }
                    },
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            _isPermissionDenied ? l10n.openSettings : l10n.allowAccess,
                            style: const TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              height: 1.5,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
