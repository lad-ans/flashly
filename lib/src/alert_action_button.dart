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
    this.isDestructive = false,
  });

  final VoidCallback? onPressed;
  final FontWeight? fontWeight;
  final String text;
  final double? fontSize;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final primaryColor = Theme.of(context).primaryColor;

    final child = Txt(
      text, 
      fontSize: 16,
      color: isDestructive 
        ? Colors.red.shade800 
        : (Platform.isIOS ? onSurface : primaryColor),
      fontWeight: FontWeight.w600,
    );

    if (Platform.isIOS) {
      return CupertinoButton.filled(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        borderRadius: BorderRadius.circular(30),
        color: onSurface.withValues(alpha: .1),
        onPressed: onPressed,
        child: child, 
      );
    }

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        overlayColor: (isDestructive ? Colors.red.shade800 : onSurface).withValues(alpha: .04),
        backgroundColor: (isDestructive ? Colors.red.shade800 : onSurface).withValues(alpha: .1),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedSuperellipseBorder(borderRadius: BorderRadius.circular(20)),
      ), 
      child: child,
    );
  }
}
