// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:swipe_clean_gallery/main.dart';
import 'package:swipe_clean_gallery/services/localization_service.dart';
import 'package:swipe_clean_gallery/services/theme_service.dart';

void main() {
  testWidgets('App launches successfully', (WidgetTester tester) async {
    // Create services for testing
    final localizationService = LocalizationService();
    final themeService = ThemeService();
    
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(
      localizationService: localizationService,
      themeService: themeService,
    ));

    // Verify that app builds successfully
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
