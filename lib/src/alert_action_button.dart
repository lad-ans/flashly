import 'dart:io';

import 'package:flashly/src/colors.dart';
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

  Widget _buildButtonDecoration(
    BuildContext context, {
    required Widget child,
    double? radius,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius ?? 20),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).cardColor.withValues(alpha: .5),
            isDestructive ? destructiveRed : Theme.of(context).primaryColor,
          ],
        ),
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final materialBackgroundColor = isDestructive ? destructiveRed : primaryColor;

    final child = Txt(
      text, 
      fontSize: 16,
      color: Theme.of(context).cardColor,
      fontWeight: FontWeight.w600,
    );

    if (Platform.isIOS) {
      return _buildButtonDecoration(
        context,
        radius: 30,
        child: CupertinoButton.filled(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          borderRadius: BorderRadius.circular(30),
          color: isDestructive ? destructiveRed : primaryColor,
          onPressed: onPressed,
          child: child, 
        ),
      );
    }

    return _buildButtonDecoration(
      context,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          overlayColor: materialBackgroundColor.withValues(alpha: .04),
          backgroundColor: materialBackgroundColor,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          shape: RoundedSuperellipseBorder(borderRadius: BorderRadius.circular(20)),
        ), 
        child: child,
      ),
    );
  }
}
