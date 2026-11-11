import 'dart:async';
import 'dart:js_interop';

import 'package:flutter/services.dart';
import 'package:web/web.dart' as web;

import '../open.dart';
import '../portfolio_data.dart';

/// Fetches the bundled resume bytes and triggers a browser download as
/// `Amrut-Khochikar-Resume.pdf`. Works under any hosting base path.
Future<void> downloadResume() async {
  try {
    final data = await rootBundle.load('assets/resume.pdf');
    final bytes = data.buffer.asUint8List(
      data.offsetInBytes,
      data.lengthInBytes,
    );
    final blob = web.Blob(
      <JSAny>[bytes.toJS].toJS,
      web.BlobPropertyBag(type: 'application/pdf'),
    );
    final url = web.URL.createObjectURL(blob);
    final anchor = web.document.createElement('a') as web.HTMLAnchorElement
      ..href = url
      ..download = 'Amrut-Khochikar-Resume.pdf'
      ..style.display = 'none';
    web.document.body?.appendChild(anchor);
    anchor.click();
    anchor.remove();
    // Revoking synchronously can cancel the download in Safari / Firefox.
    Timer(const Duration(seconds: 30), () => web.URL.revokeObjectURL(url));
  } catch (_) {
    await openUrl(AppLinks.resumeUrl);
  }
}

String? initialFragment() {
  final hash = web.window.location.hash;
  if (hash.length <= 1) return null;
  return hash.substring(1);
}

void replaceFragment(String? id) {
  final location = web.window.location;
  final base = '${location.pathname}${location.search}';
  final next = id == null || id.isEmpty ? base : '$base#$id';
  if ('${location.pathname}${location.search}${location.hash}' == next) return;
  web.window.history.replaceState(null, '', next);
}
