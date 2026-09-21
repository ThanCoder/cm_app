import 'package:cm_app/ui/platforms/components/dialog/error_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

Future<void> launchPageUrl(BuildContext context, String url) async {
  final success = await launchUrlString(url);
  if (success) return;
  if (!context.mounted) return;
  showErrorDialog(context, 'Launch Error: $url');
}
