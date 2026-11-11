import 'dart:ui';

import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'core/anchors.dart';
import 'core/platform/browser.dart';
import 'firebase_options.dart';
import 'sections/portfolio_page.dart';
import 'theme/app_theme.dart';

/// reCAPTCHA v3 site key for Firebase App Check. Pass it at build time:
/// `flutter build web --dart-define=RECAPTCHA_SITE_KEY=...`
const _recaptchaSiteKey = String.fromEnvironment('RECAPTCHA_SITE_KEY');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Read `#section` before runApp: the Navigator rewrites the URL on startup.
  final initialSection = SectionId.tryParse(Browser.initialFragment());
  // Clean URLs (no "#/"), which frees the fragment for section deep links.
  usePathUrlStrategy();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    if (_recaptchaSiteKey.isNotEmpty) {
      await FirebaseAppCheck.instance.activate(
        providerWeb: ReCaptchaV3Provider(_recaptchaSiteKey),
      );
    }
  }
  runApp(PortfolioApp(initialSection: initialSection));
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key, this.initialSection});

  /// Section to scroll to on load (from a `/#projects` style deep link).
  final SectionId? initialSection;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Amrut Khochikar — Flutter Developer',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      scrollBehavior: const _AppScrollBehavior(),
      home: PortfolioPage(initialSection: initialSection),
    );
  }
}

class _AppScrollBehavior extends MaterialScrollBehavior {
  const _AppScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
  };
}
