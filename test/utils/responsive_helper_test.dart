import 'package:flutter_test/flutter_test.dart';
import 'package:pos_kasir_flutter/utils/responsive_helper.dart';
import 'package:flutter/material.dart';

void main() {
  group('ResponsiveHelper Tests', () {
    testWidgets('isMobile should return true for width < 600', (tester) async {
      print('\n🧪 TEST: ResponsiveHelper isMobile detection');
      print('   Testing: Screen width 400px should be detected as mobile');
      
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              // Mock a 400px width screen
              return MediaQuery(
                data: const MediaQueryData(size: Size(400, 800)),
                child: Builder(
                  builder: (context) {
                    expect(ResponsiveHelper.isMobile(context), true);
                    print('   ✅ Result: 400px correctly identified as mobile (< 600px)');
                    return Container();
                  },
                ),
              );
            },
          ),
        ),
      );
    });

    testWidgets('isMobile should return false for width >= 600', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return MediaQuery(
                data: const MediaQueryData(size: Size(800, 600)),
                child: Builder(
                  builder: (context) {
                    expect(ResponsiveHelper.isMobile(context), false);
                    return Container();
                  },
                ),
              );
            },
          ),
        ),
      );
    });

    testWidgets('isTablet should return true for width between 600-1200', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return MediaQuery(
                data: const MediaQueryData(size: Size(900, 600)),
                child: Builder(
                  builder: (context) {
                    expect(ResponsiveHelper.isTablet(context), true);
                    return Container();
                  },
                ),
              );
            },
          ),
        ),
      );
    });

    testWidgets('isDesktop should return true for width >= 1200', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return MediaQuery(
                data: const MediaQueryData(size: Size(1400, 900)),
                child: Builder(
                  builder: (context) {
                    expect(ResponsiveHelper.isDesktop(context), true);
                    return Container();
                  },
                ),
              );
            },
          ),
        ),
      );
    });

    testWidgets('isLandscape should detect landscape orientation', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return MediaQuery(
                data: const MediaQueryData(
                  size: Size(800, 600),
                ),
                child: Builder(
                  builder: (context) {
                    expect(ResponsiveHelper.isLandscape(context), true);
                    return Container();
                  },
                ),
              );
            },
          ),
        ),
      );
    });

    testWidgets('shouldShowSplitView should return true for width >= 600', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return MediaQuery(
                data: const MediaQueryData(size: Size(800, 600)),
                child: Builder(
                  builder: (context) {
                    expect(ResponsiveHelper.shouldShowSplitView(context), true);
                    return Container();
                  },
                ),
              );
            },
          ),
        ),
      );
    });

    testWidgets('screenWidth should return correct width', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return MediaQuery(
                data: const MediaQueryData(size: Size(1024, 768)),
                child: Builder(
                  builder: (context) {
                    expect(ResponsiveHelper.screenWidth(context), 1024);
                    return Container();
                  },
                ),
              );
            },
          ),
        ),
      );
    });

    testWidgets('screenHeight should return correct height', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return MediaQuery(
                data: const MediaQueryData(size: Size(1024, 768)),
                child: Builder(
                  builder: (context) {
                    expect(ResponsiveHelper.screenHeight(context), 768);
                    return Container();
                  },
                ),
              );
            },
          ),
        ),
      );
    });

    testWidgets('getScreenPadding should return correct padding for mobile', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return MediaQuery(
                data: const MediaQueryData(size: Size(400, 800)),
                child: Builder(
                  builder: (context) {
                    final padding = ResponsiveHelper.getScreenPadding(context);
                    expect(padding, const EdgeInsets.all(12));
                    return Container();
                  },
                ),
              );
            },
          ),
        ),
      );
    });

    testWidgets('getScreenPadding should return correct padding for tablet', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return MediaQuery(
                data: const MediaQueryData(size: Size(900, 600)),
                child: Builder(
                  builder: (context) {
                    final padding = ResponsiveHelper.getScreenPadding(context);
                    expect(padding, const EdgeInsets.all(16));
                    return Container();
                  },
                ),
              );
            },
          ),
        ),
      );
    });

    testWidgets('getScreenPadding should return correct padding for desktop', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return MediaQuery(
                data: const MediaQueryData(size: Size(1400, 900)),
                child: Builder(
                  builder: (context) {
                    final padding = ResponsiveHelper.getScreenPadding(context);
                    expect(padding, const EdgeInsets.all(24));
                    return Container();
                  },
                ),
              );
            },
          ),
        ),
      );
    });

    testWidgets('getResponsiveFontSize should scale correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return MediaQuery(
                data: const MediaQueryData(size: Size(400, 800)),
                child: Builder(
                  builder: (context) {
                    final fontSize = ResponsiveHelper.getResponsiveFontSize(context, 16);
                    expect(fontSize, 16); // Mobile base size
                    return Container();
                  },
                ),
              );
            },
          ),
        ),
      );
    });

    testWidgets('getGridCrossAxisCount should return correct count for different widths', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return MediaQuery(
                data: const MediaQueryData(size: Size(350, 800)),
                child: Builder(
                  builder: (context) {
                    final count = ResponsiveHelper.getGridCrossAxisCount(context);
                    expect(count, 2); // < 400px
                    return Container();
                  },
                ),
              );
            },
          ),
        ),
      );
    });

    testWidgets('getCatalogFlex should return correct flex value', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return MediaQuery(
                data: const MediaQueryData(size: Size(1000, 600)),
                child: Builder(
                  builder: (context) {
                    final flex = ResponsiveHelper.getCatalogFlex(context);
                    expect(flex, 2); // >= 1000px
                    return Container();
                  },
                ),
              );
            },
          ),
        ),
      );
    });

    testWidgets('getCartFlex should always return 1', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return MediaQuery(
                data: const MediaQueryData(size: Size(1000, 600)),
                child: Builder(
                  builder: (context) {
                    final flex = ResponsiveHelper.getCartFlex(context);
                    expect(flex, 1);
                    return Container();
                  },
                ),
              );
            },
          ),
        ),
      );
    });

    testWidgets('getLayoutType should return mobile for small screens', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return MediaQuery(
                data: const MediaQueryData(size: Size(500, 800)),
                child: Builder(
                  builder: (context) {
                    final layoutType = ResponsiveHelper.getLayoutType(context);
                    expect(layoutType, LayoutType.mobile);
                    return Container();
                  },
                ),
              );
            },
          ),
        ),
      );
    });

    testWidgets('getLayoutType should return tablet for medium screens', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return MediaQuery(
                data: const MediaQueryData(size: Size(900, 600)),
                child: Builder(
                  builder: (context) {
                    final layoutType = ResponsiveHelper.getLayoutType(context);
                    expect(layoutType, LayoutType.tablet);
                    return Container();
                  },
                ),
              );
            },
          ),
        ),
      );
    });

    testWidgets('getLayoutType should return desktop for large screens', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return MediaQuery(
                data: const MediaQueryData(size: Size(1400, 900)),
                child: Builder(
                  builder: (context) {
                    final layoutType = ResponsiveHelper.getLayoutType(context);
                    expect(layoutType, LayoutType.desktop);
                    return Container();
                  },
                ),
              );
            },
          ),
        ),
      );
    });
  });

  group('ResponsiveHelper Breakpoint Tests', () {
    test('mobile breakpoint should be 600', () {
      print('\n🧪 TEST: Mobile breakpoint constant');
      print('   Expected: mobileBreakpoint = 600');
      
      expect(ResponsiveHelper.mobileBreakpoint, 600);
      
      print('   ✅ Result: Mobile breakpoint verified at 600px');
    });

    test('tablet breakpoint should be 900', () {
      print('\n🧪 TEST: Tablet breakpoint constant');
      print('   Expected: tabletBreakpoint = 900');
      
      expect(ResponsiveHelper.tabletBreakpoint, 900);
      
      print('   ✅ Result: Tablet breakpoint verified at 900px');
    });

    test('desktop breakpoint should be 1200', () {
      print('\n🧪 TEST: Desktop breakpoint constant');
      print('   Expected: desktopBreakpoint = 1200');
      
      expect(ResponsiveHelper.desktopBreakpoint, 1200);
      
      print('   ✅ Result: Desktop breakpoint verified at 1200px');
    });
  });
}
