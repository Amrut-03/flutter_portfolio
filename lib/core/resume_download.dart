import 'resume_download_stub.dart'
    if (dart.library.html) 'resume_download_web.dart' as impl;

/// Triggers a download (or opens) of the bundled resume PDF.
Future<void> downloadResume() => impl.downloadResume();