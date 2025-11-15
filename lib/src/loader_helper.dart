import 'dart:async';
import 'dart:io';

import 'package:flashly/src/utils.dart';
import 'package:flutter/material.dart';

import 'alert_helper.dart';

Widget loader({
  double? size = 24, 
  Color? color, 
  Key? key, 
  double? scaleFactor,
}) {
  final indicator = Transform.scale(
    scale: scaleFactor ?? (Platform.isIOS ? 1.2 : 1),
    child: CircularProgressIndicator.adaptive(
      valueColor: AlwaysStoppedAnimation(color),
    ),
  );

  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      SizedBox(
        width: size, height: size,
        child: color != null ? ColorFiltered(
          colorFilter: ColorFilter.mode(color, BlendMode.srcATop),
          child: indicator,
        ) : indicator,
      ),
    ],
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
  BuildContext? context,
}) {
  final placeholdr = placeholder != null ? '$placeholder...' : '';
  showAlert(
    placeholdr, 
    context: context,
    asLoader: true, 
    isDestructive: true,
    negativeTitle: 'Fechar',
    closeLoaderAfterSecs: closeLoaderAfterSecs ?? 45,
  );
}

void closeLoaderAlert([BuildContext? context]) {
  if (Navigator.canPop(context ?? Flashly.context)) {
    Navigator.pop(context ?? Flashly.context);
  }
} 