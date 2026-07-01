import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Launches [uri] in an external app/browser and shows a localized snackbar if
/// nothing can handle it.
///
/// `launchUrl` returns `false` (or throws) when there is no app able to open the
/// link — e.g. no browser, or a `wa.me` deep link with WhatsApp missing. Calling
/// it unguarded makes buttons appear dead. This wrapper guarantees the user
/// always gets feedback.
Future<void> openExternalUrl(
  BuildContext context,
  Uri uri, {
  required bool isFrench,
}) async {
  final messenger = ScaffoldMessenger.of(context);
  var opened = false;
  try {
    opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
  } catch (_) {
    opened = false;
  }
  if (!opened) {
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          isFrench ? 'Impossible d\'ouvrir le lien' : "Couldn't open the link",
        ),
      ),
    );
  }
}
