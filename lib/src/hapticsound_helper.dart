import 'package:flashly/src/utils.dart';
import 'package:flutter/services.dart';

enum HapticImpact {medium, vibrate, light, heavy}

void haptics({
  HapticImpact impact = HapticImpact.heavy,
}) {
  if (impact == HapticImpact.heavy) {
    HapticFeedback.heavyImpact();
  }
  if (impact == HapticImpact.medium) {
    HapticFeedback.mediumImpact();
  }
  if (impact == HapticImpact.light) {
    HapticFeedback.lightImpact();
  }
  if (impact == HapticImpact.vibrate) {
    HapticFeedback.vibrate();
  }
}

Future<void> playSound([bool error = false]) async {
  await playAlert(
    isError: error,
    path: 'audio/success.mp3',
    errorPath: error ? 'audio/error.mp3' : null,
  );
}