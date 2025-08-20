import 'dart:async';
import 'dart:io';

import 'package:flashly/src/utils.dart';
import 'package:flutter/material.dart';

import 'alert_helper.dart';

Widget loader({double? size, Color? color, Key? key}) {
  final indicator = Transform.scale(
    scale: Platform.isIOS ? 1.2 : 1,
    child: CircularProgressIndicator.adaptive(
      valueColor: AlwaysStoppedAnimation(color),
    ),
  );

  return Container(
    alignment: Alignment.center,
    width: size, height: size,
    child: color != null ? ColorFiltered(
      colorFilter: ColorFilter.mode(color, BlendMode.srcATop),
      child: indicator,
    ) : indicator,
  );
}

void showTimingLoaderAlert(
  String placeholder, 
  [int? secs]
) {
  WidgetsBinding.instance.addPostFrameCallback((_) => showLoaderAlert(placeholder: placeholder));
  Timer(Duration(seconds: secs ?? 2), () => Navigator.pop(Flashly.context));
}

void showLoaderAlert({
  String? placeholder,
  int? closeLoaderAfterSecs,
  Color? actionButtonColor,
}) {
  final placeholdr = placeholder != null ? '$placeholder...' : '';
  showAlert(
    placeholdr, 
    asLoader: true, 
    isDestructive: true,
    positiveTitle: 'Fechar',
    closeLoaderAfterSecs: closeLoaderAfterSecs ?? 45,
    actionButtonColor: actionButtonColor,
    onPositive: () async {},
  );
}

void closeLoaderAlert() {
  if (Navigator.canPop(Flashly.context)) {
    Navigator.pop(Flashly.context);
  }
} 