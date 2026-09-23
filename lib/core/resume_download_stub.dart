/// Non-web fallback. The resume is currently distributed on web only, so
/// this is a no-op to keep the import graph valid outside of `dart:html`.
Future<void> downloadResume() async {}