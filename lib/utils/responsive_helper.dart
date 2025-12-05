import 'package:flutter/material.dart';

/// Helper class untuk menentukan breakpoint responsive
class ResponsiveHelper {
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;

  /// Cek apakah device adalah mobile (portrait)
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobileBreakpoint;
  }

  /// Cek apakah device adalah tablet atau mobile landscape
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobileBreakpoint && width < desktopBreakpoint;
  }

  /// Cek apakah device adalah desktop
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= desktopBreakpoint;
  }

  /// Cek apakah orientation adalah landscape
  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  /// Cek apakah harus menampilkan split view (catalog + cart side by side)
  static bool shouldShowSplitView(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobileBreakpoint;
  }

  /// Get screen width
  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  /// Get screen height
  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  /// Get responsive padding
  static EdgeInsets getScreenPadding(BuildContext context) {
    if (isMobile(context)) {
      return const EdgeInsets.all(12);
    } else if (isTablet(context)) {
      return const EdgeInsets.all(16);
    } else {
      return const EdgeInsets.all(24);
    }
  }

  /// Get responsive font size
  static double getResponsiveFontSize(BuildContext context, double baseSize) {
    if (isMobile(context)) {
      return baseSize;
    } else if (isTablet(context)) {
      return baseSize * 1.1;
    } else {
      return baseSize * 1.2;
    }
  }

  /// Get grid cross axis count untuk product grid
  static int getGridCrossAxisCount(BuildContext context) {
    final width = screenWidth(context);
    if (width < 400) return 2;
    if (width < 600) return 2;
    if (width < 900) return 3;
    if (width < 1200) return 4;
    return 5;
  }

  /// Get catalog flex ratio untuk split view
  static int getCatalogFlex(BuildContext context) {
    final width = screenWidth(context);
    if (width < 800) return 1;
    if (width < 1000) return 2;
    return 2;
  }

  /// Get cart flex ratio untuk split view
  static int getCartFlex(BuildContext context) {
    return 1;
  }

  /// Layout type enum
  static LayoutType getLayoutType(BuildContext context) {
    final width = screenWidth(context);
    if (width < mobileBreakpoint) {
      return LayoutType.mobile;
    } else if (width < desktopBreakpoint) {
      return LayoutType.tablet;
    } else {
      return LayoutType.desktop;
    }
  }
}

enum LayoutType {
  mobile,
  tablet,
  desktop,
}

/// Widget builder untuk responsive layout
class ResponsiveBuilder extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveBuilder({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= ResponsiveHelper.desktopBreakpoint) {
          return desktop ?? tablet ?? mobile;
        } else if (constraints.maxWidth >= ResponsiveHelper.mobileBreakpoint) {
          return tablet ?? mobile;
        } else {
          return mobile;
        }
      },
    );
  }
}
