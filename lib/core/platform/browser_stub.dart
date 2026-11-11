import '../open.dart';
import '../portfolio_data.dart';

Future<void> downloadResume() => openUrl(AppLinks.resumeUrl);

String? initialFragment() => null;

void replaceFragment(String? id) {}
