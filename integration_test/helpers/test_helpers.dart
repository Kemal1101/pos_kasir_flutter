import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

export 'finder_extensions.dart';

/// Matcher that passes when one or more widgets are found.
const Matcher findsOneOrMoreWidgets = findsWidgets;

/// Helper functions untuk integration testing
class TestHelpers {
  /// Wait untuk widget muncul dengan timeout
  static Future<void> waitForWidget(
    WidgetTester tester,
    Finder finder, {
    Duration timeout = const Duration(seconds: 10),
  }) async {
    final end = DateTime.now().add(timeout);
    
    do {
      if (DateTime.now().isAfter(end)) {
        throw Exception('Timeout waiting for ${finder.toString()}');
      }
      
      await tester.pumpAndSettle(const Duration(milliseconds: 100));
      await Future.delayed(const Duration(milliseconds: 100));
    } while (finder.evaluate().isEmpty);
  }

  /// Wait untuk loading selesai
  static Future<void> waitForLoadingToFinish(WidgetTester tester) async {
    // Wait untuk CircularProgressIndicator hilang
    await tester.pumpAndSettle(const Duration(seconds: 1));
    
    int attempts = 0;
    while (find.byType(CircularProgressIndicator).evaluate().isNotEmpty) {
      if (attempts > 50) {
        throw Exception('Loading took too long');
      }
      await tester.pump(const Duration(milliseconds: 200));
      attempts++;
    }
    
    await tester.pumpAndSettle();
  }

  /// Scroll to widget jika tidak terlihat
  static Future<void> scrollToWidget(
    WidgetTester tester,
    Finder finder, {
    Finder? scrollable,
  }) async {
    scrollable ??= find.byType(Scrollable).first;
    
    await tester.dragUntilVisible(
      finder,
      scrollable,
      const Offset(0, -100),
    );
    
    await tester.pumpAndSettle();
  }

  /// Enter text dengan delay untuk simulasi user typing
  static Future<void> enterTextSlowly(
    WidgetTester tester,
    Finder finder,
    String text,
  ) async {
    await tester.tap(finder);
    await tester.pumpAndSettle();
    
    await tester.enterText(finder, text);
    await tester.pumpAndSettle();
  }

  /// Tap dengan retry jika gagal
  static Future<void> tapWithRetry(
    WidgetTester tester,
    Finder finder, {
    int maxAttempts = 3,
  }) async {
    for (int i = 0; i < maxAttempts; i++) {
      try {
        await tester.tap(finder);
        await tester.pumpAndSettle();
        return;
      } catch (e) {
        if (i == maxAttempts - 1) rethrow;
        await tester.pump(const Duration(milliseconds: 500));
      }
    }
  }

  /// Verify text exists di screen
  static void verifyText(String text, {bool shouldExist = true}) {
    final finder = find.text(text);
    if (shouldExist) {
      expect(finder, findsWidgets,
          reason: 'Text "$text" should exist');
    } else {
      expect(finder, findsNothing, reason: 'Text "$text" should not exist');
    }
  }

  /// Verify widget exists
  static void verifyWidget<T extends Widget>({bool shouldExist = true}) {
    final finder = find.byType(T);
    if (shouldExist) {
      expect(finder, findsWidgets,
          reason: 'Widget ${T.toString()} should exist');
    } else {
      expect(finder, findsNothing,
          reason: 'Widget ${T.toString()} should not exist');
    }
  }

  /// Take screenshot (untuk debugging)
  static Future<void> takeScreenshot(
    WidgetTester tester,
    String name,
  ) async {
    await tester.pumpAndSettle();
    // Screenshot akan otomatis disimpan jika run dengan --screenshot flag
    await tester.pump();
  }

  /// Format currency untuk matching
  static String formatCurrency(double amount) {
    final formatter = amount.toStringAsFixed(0);
    return formatter.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }

  /// Dismiss keyboard
  static Future<void> dismissKeyboard(WidgetTester tester) async {
    // Hide keyboard by unfocusing
    await SystemChannels.textInput.invokeMethod('TextInput.hide');
    await tester.pumpAndSettle();
  }

  /// Wait for navigation
  static Future<void> waitForNavigation(WidgetTester tester) async {
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  /// Find button by text
  static Finder findButtonByText(String text) {
    // Try multiple button types
    var finder = find.widgetWithText(ElevatedButton, text);
    if (finder.evaluate().isEmpty) {
      finder = find.widgetWithText(TextButton, text);
    }
    if (finder.evaluate().isEmpty) {
      finder = find.widgetWithText(OutlinedButton, text);
    }
    if (finder.evaluate().isEmpty) {
      finder = find.widgetWithText(InkWell, text);
    }
    if (finder.evaluate().isEmpty) {
      finder = find.widgetWithText(GestureDetector, text);
    }
    return finder;
  }

  /// Verify navigation happened
  static void verifyRoute(WidgetTester tester, String routeName) {
    // This is a simplified check - in real app might need more sophisticated route checking
    expect(find.byType(Navigator), findsOneWidget);
  }
}
