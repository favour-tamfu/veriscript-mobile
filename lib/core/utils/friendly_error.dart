/// Maps raw error text (typically an exception's `toString()`) into a concise,
/// localized message that is safe to show end users.
///
/// The app catches errors in several notifiers and stores the raw message in
/// state, which the UI then renders directly. Without this mapper users can see
/// technical strings like `Exception: FunctionException…`, raw JSON bodies, or a
/// blank error view. This helper:
///   1. Localizes the handful of English-only messages the notifiers set.
///   2. Collapses connectivity failures into one friendly message.
///   3. Replaces anything empty or clearly technical with a generic message.
///   4. Otherwise passes through what is already a human-readable message.
///
/// It never changes control flow — only the text shown to the user.
String friendlyError(Object? error, {required bool isFrench}) {
  final raw = error?.toString().trim() ?? '';
  final lower = raw.toLowerCase();

  String pick(String fr, String en) => isFrench ? fr : en;

  // ── Known sentinels / server signals ──────────────────────────────────────
  if (lower.contains('insufficient_credits')) {
    return pick(
      'Le service est temporairement indisponible. Veuillez réessayer plus tard ou contacter le support.',
      'The service is temporarily unavailable. Please try again later or contact support.',
    );
  }

  // ── Connectivity ──────────────────────────────────────────────────────────
  if (_looksLikeNetwork(lower)) {
    return pick(
      'Problème de connexion. Vérifiez votre connexion internet et réessayez.',
      'Connection problem. Check your internet connection and try again.',
    );
  }

  // ── Known English app messages set by notifiers → localized ───────────────
  switch (raw) {
    case 'Missing file or target format.':
      return pick('Fichier ou format de destination manquant.', raw);
    case 'Conversion finished but no output file was found.':
      return pick(
        'La conversion est terminée mais aucun fichier n\'a été trouvé.',
        raw,
      );
    case 'Conversion failed. Please try again.':
      return pick('Échec de la conversion. Veuillez réessayer.', raw);
    case 'Could not track conversion status.':
      return pick('Impossible de suivre l\'état de la conversion.', raw);
    case 'Could not track scan status.':
      return pick('Impossible de suivre l\'état de l\'analyse.', raw);
    case 'Not signed in.':
      return pick('Vous n\'êtes pas connecté.', 'You are not signed in.');
  }

  // ── Empty or clearly technical → generic ──────────────────────────────────
  if (raw.isEmpty || _looksTechnical(lower)) {
    return pick(
      'Une erreur est survenue. Veuillez réessayer.',
      'Something went wrong. Please try again.',
    );
  }

  // ── Otherwise assume it is already a human-readable message ───────────────
  return raw;
}

bool _looksLikeNetwork(String lower) {
  return lower.contains('socketexception') ||
      lower.contains('failed host lookup') ||
      lower.contains('network is unreachable') ||
      lower.contains('connection closed') ||
      lower.contains('connection refused') ||
      lower.contains('connection reset') ||
      lower.contains('connection timed out') ||
      lower.contains('timeoutexception') ||
      lower.contains('clientexception') ||
      lower.contains('handshakeexception');
}

bool _looksTechnical(String lower) {
  return lower.contains('exception') ||
      lower.contains('statuscode') ||
      lower.contains('status code') ||
      lower.contains('postgrest') ||
      lower.contains('stacktrace') ||
      lower.startsWith('error:') ||
      lower.startsWith('type ') ||
      lower.startsWith('null') ||
      lower.startsWith('{') ||
      lower.startsWith('[') ||
      lower.startsWith('<');
}
