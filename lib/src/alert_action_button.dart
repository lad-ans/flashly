import 'dart:io';

import 'package:flashly/src/txt.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AlertActionButton extends StatelessWidget {
  const AlertActionButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.fontSize,
    this.fontWeight,
    this.color,
  });

  final VoidCallback? onPressed;
  final FontWeight? fontWeight;
  final String text;
  final double? fontSize;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final child = Txt(
      text, 
      fontSize: 17,
      color: color ?? (Platform.isIOS ? Theme.of(context).colorScheme.onSurface : Theme.of(context).primaryColor),
      fontWeight: FontWeight.w700,
    );

    if (Platform.isIOS) {
      return CupertinoButton.filled(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        borderRadius: BorderRadius.circular(Platform.isIOS ? 30 : 20),
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: .07),
        onPressed: onPressed,
        child: child, 
      );
    }

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        shadowColor: Colors.transparent,
        overlayColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: .04),
        surfaceTintColor: Colors.transparent,
        backgroundColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: .07),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 11),
        shape: RoundedSuperellipseBorder(borderRadius: BorderRadius.circular(Platform.isIOS ? 30 : 20)),
      ), 
      child: child,
    );
  }
}
