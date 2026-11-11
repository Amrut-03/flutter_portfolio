import 'browser_stub.dart'
    if (dart.library.js_interop) 'browser_web.dart'
    as impl;

/// Small, platform-safe wrappers around the few browser APIs the site uses.
abstract final class Browser {
  /// Downloads the bundled resume (web) or opens the hosted copy elsewhere.
  static Future<void> downloadResume() => impl.downloadResume();

  /// The `#fragment` the page was opened with, without the `#`.
  static String? initialFragment() => impl.initialFragment();

  /// Replaces the current URL's fragment without adding a history entry.
  static void replaceFragment(String? id) => impl.replaceFragment(id);
}
