import 'package:flutter_test/flutter_test.dart';

/// Helper untuk combine multiple finders
class FinderHelper {
  /// Find first matching finder from list
  static Finder firstOf(List<Finder> finders) {
    for (final finder in finders) {
      if (finder.evaluate().isNotEmpty) {
        return finder;
      }
    }
    // Return last finder if none found (for consistency)
    return finders.last;
  }

  /// Check if any finder has matches
  static bool anyMatches(List<Finder> finders) {
    return finders.any((finder) => finder.evaluate().isNotEmpty);
  }
}

/// Extension method untuk combine finders
extension FinderExtension on Finder {
  /// Combine two finders - returns first if found, otherwise second
  Finder orElse(Finder other) {
    return evaluate().isNotEmpty ? this : other;
  }

  /// Convenience method to match current tests using `.or(...)`.
  Finder or(Finder other) {
    return orElse(other);
  }
}
