import 'package:url_launcher/url_launcher.dart';

/// Opens a URL in the system browser. Safe on every platform.
Future<void> openUrl(String url) async {
  final uri = Uri.tryParse(url);
  if (uri == null) return;
  try {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } catch (_) {
    // Ignore launch failures on unsupported platforms.
  }
}