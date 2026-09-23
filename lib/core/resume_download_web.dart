import 'dart:js_interop';

import 'package:flutter/services.dart';
import 'package:web/web.dart' as web;

/// Fetches the bundled resume bytes and triggers a browser download as
/// `Amrut-Khochikar-Resume.pdf`. Works under any hosting base path.
Future<void> downloadResume() async {
  try {
    final data = await rootBundle.load('assets/resume.pdf');
    final bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
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
    web.URL.revokeObjectURL(url);
  } catch (_) {
    // Ignore download failures (e.g. on unsupported browsers).
  }
}