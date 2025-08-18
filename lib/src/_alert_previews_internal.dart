import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

import '../flashly.dart';

Widget _buildAlertContent(
  String title, {
  String? description,
  String? negativeTitle,
  String? positiveTitle,
  bool isDestructive = false,
  bool asLoader = false,
  VoidCallback? onNegative,
  int? closeLoaderAfterSecs,
  Color? actionButtonColor,
  Future<void> Function()? onPositive,
}) {
  bool showButton = false;
  bool timerStarted = false;

  return AnimatedSize(
    duration: Duration(milliseconds: 500),
    curve: Curves.easeInOut,
    child: Padding(
      padding: EdgeInsets.symmetric(
        vertical: asLoader ? 32 : 20, 
        horizontal: 16,
      ),
      child: StatefulBuilder(
        builder: (context, setState) {
          if (!timerStarted && closeLoaderAfterSecs != null) {
            timerStarted = true;
            Future.delayed(Duration(seconds: closeLoaderAfterSecs), () {
              if (context.mounted && Navigator.canPop(Flashly.context)) {
                setState(() => showButton = true);
              }
            });
          }
      
          return Column(
            spacing: (asLoader && showButton) || !asLoader ? 16 : 0,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (asLoader) Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  spacing: 18,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: 30, height: 30,
                      child: ColorFiltered(
                        colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcATop),
                        child: Transform.scale(
                          scale: 1.2,
                          child: CircularProgressIndicator.adaptive(
                            valueColor: AlwaysStoppedAnimation(Colors.black),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Txt(
                        title,
                        fontWeight: FontWeight.bold, 
                        fontSize: 17, 
                      ),
                    ),
                  ],
                ),
              ) 
              else Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 2,
                  children: [
                    if (title.isNotEmpty) 
                      Txt(
                        title, 
                        fontWeight: FontWeight.bold, 
                        fontSize: 17,
                      ),
                    if (description != null)
                      Txt(
                        description, 
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: .6), 
                        fontSize: 15, 
                        fontWeight: FontWeight.w600, 
                      ),
                  ],
                ),
              ),
              Row(
                spacing: 10,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (!asLoader)
                    Expanded(
                      child: CupertinoButton.filled(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        borderRadius: BorderRadius.circular(26),
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: .07),
                        onPressed: () {
                          Navigator.pop(Flashly.context);
                          if (onNegative != null) onNegative();
                        },
                        child: Txt(
                          negativeTitle ?? 'Cancelar', 
                          fontSize: 17,
                          color: isDestructive ? CupertinoColors.destructiveRed : null,
                          fontWeight: FontWeight.w700,
                        ), 
                      ),
                    ),
                  if (positiveTitle != null && !asLoader)
                    Expanded(
                      child: CupertinoButton.filled(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        borderRadius: BorderRadius.circular(26),
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: .07),
                        onPressed: () {
                          Navigator.pop(Flashly.context);
                          if (onPositive != null) onPositive();
                        },
                        child: Txt(
                          positiveTitle, 
                          fontSize: 17,
                          color: isDestructive ? CupertinoColors.destructiveRed : actionButtonColor,
                          fontWeight: FontWeight.w700,
                        ), 
                      ),
                    ),
                    if (asLoader) Expanded(
                      child: AnimatedScale(
                        scale: showButton ? 1.0 : .5,
                        duration: const Duration(milliseconds: 500),
                        child: Visibility(
                          visible: showButton && positiveTitle != null,
                          maintainSize: false,
                          maintainAnimation: true,
                          maintainState: true,
                          child: CupertinoButton.filled(
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            borderRadius: BorderRadius.circular(26),
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: .07),
                            onPressed: () {
                              Navigator.pop(Flashly.context);
                              if (onPositive != null) onPositive();
                            },
                            child: Txt(
                              positiveTitle!, 
                              fontSize: 17,
                              color: isDestructive ? CupertinoColors.destructiveRed : null,
                              fontWeight: FontWeight.w700,
                            ), 
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          );
        }
      ),
    ),
  );
}

@Preview(name: 'Alert')
Widget alertPreview() {
  return MaterialApp(
    home: Scaffold(
      backgroundColor: Colors.black,
      body: ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 320, maxHeight: 300),
      child: Dialog(
        elevation: 0,
        insetPadding: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(26),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 400),
              curve: Curves.easeOutCubic,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(26),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withValues(alpha: 0.25),
                    Colors.white.withValues(alpha: 0.15),
                    Colors.white.withValues(alpha: 0.08),
                    Colors.white.withValues(alpha: 0.12),
                  ],
                  stops: [0.0, 0.3, 0.7, 1.0],
                ),
                color: null,
                border: Border.all(
                  width: .6,
                  color: Colors.white.withValues(alpha: 0.4),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withValues(alpha: 0.6),
                    offset: Offset(0, 1),
                    blurRadius: 0,
                    spreadRadius: 0,
                    blurStyle: BlurStyle.inner,
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    offset: Offset(0, 8),
                    blurRadius: 32,
                    spreadRadius: -8,
                  ),
                ],
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(26),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withValues(alpha: 0.08),
                      Colors.white.withValues(alpha: 0.02),
                    ],
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(26),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          center: Alignment.topLeft,
                          radius: 2.0,
                          colors: [
                            Colors.white.withValues(alpha: 0.03),
                            Colors.transparent,
                          ],
                        ),
                      ),
                      child: _buildAlertContent(
                        'Alert Title',
                        // asLoader: true,
                        // positiveTitle: 'Fechar'
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
    ),
  );
}
