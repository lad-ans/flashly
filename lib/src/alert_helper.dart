import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flashly/src/alert_action_button.dart';
import 'package:flashly/src/hapticsound_helper.dart';
import 'package:flashly/src/loader_helper.dart';
import 'package:flashly/src/txt.dart';
import 'package:flashly/src/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum AlertState { error, info, success }

Future<T?> showAlert<T>(
  String title, {
  String? description,
  String? negativeTitle,
  String? positiveTitle,
  AlertState? state = AlertState.success,
  bool isDestructive = false,
  bool asLoader = false,
  VoidCallback? onNegative,
  int? closeLoaderAfterSecs,
  Color? actionButtonColor,
  Future<void> Function()? onPositive,
  bool enableHaptics = false,
  bool enableSound = false,
}) async {
  if (!asLoader) {
    if (enableHaptics) haptics();
    if (enableSound) playSound(state == AlertState.error);
  }

  return await _showDialog<T>(
    title,
    description: description,
    negativeTitle: negativeTitle,
    positiveTitle: positiveTitle,
    isDestructive: isDestructive,
    onNegative: onNegative,
    onPositive: onPositive,
    asLoader: asLoader,
    closeLoaderAfterSecs: closeLoaderAfterSecs,
    actionButtonColor: actionButtonColor,
  );
}

Future<T?> _showDialog<T>(
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
}) async {
  bool showButton = false;
  bool timerStarted = false;

  Widget buildDefaultActionButton() {
    return AlertActionButton(
      text: negativeTitle ?? 'Cancelar',
      color: positiveTitle == null && isDestructive 
        ? CupertinoColors.destructiveRed 
        : actionButtonColor,
      onPressed: () {
        Navigator.pop(Flashly.context);
        if (onNegative != null) onNegative();
      },
    );
  }

  Widget buildChild(BuildContext context) => AnimatedSize(
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
                    loader(),
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
                  if (asLoader) Expanded(
                      child: AnimatedScale(
                        scale: showButton ? 1.0 : .5,
                        duration: const Duration(milliseconds: 500),
                        child: Visibility(
                          visible: showButton && positiveTitle != null,
                          maintainSize: false,
                          maintainAnimation: true,
                          maintainState: true,
                          child: buildDefaultActionButton(),
                        ),
                      ),
                    )
                  else
                    Expanded(child: buildDefaultActionButton()),

                  if (positiveTitle != null && !asLoader)
                    Expanded(
                      child: AlertActionButton(
                        text: positiveTitle,
                        color: isDestructive ? CupertinoColors.destructiveRed : actionButtonColor,
                        onPressed: () {
                          Navigator.pop(Flashly.context);
                          if (onPositive != null) onPositive();
                        },
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

  return showDialog<T>(
    context: Flashly.context,
    barrierDismissible: false,
    barrierColor: Colors.black26,
    builder: (context) => Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(
        1, (index) => _AlertContainer(
          asLoader: asLoader, 
          child: buildChild(context),
        ),
      ),
    ),
  );
}

class _AlertContainer extends StatelessWidget {
  final bool asLoader;
  final Widget child;

  const _AlertContainer({
    required this.asLoader, 
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final content = ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 320, maxHeight: 300),
      child: Dialog(
        elevation: 0,
        insetPadding: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Platform.isIOS ? 30 : 20),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: Platform.isIOS ? 20 : 3, 
              sigmaY: Platform.isIOS ? 20 : 3
            ),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 400),
              curve: Curves.easeOutCubic,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Platform.isIOS ? 30 : 20),
                gradient: Platform.isIOS ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).cardColor.withValues(alpha: 0.25),
                    Theme.of(context).cardColor.withValues(alpha: 0.15),
                    Theme.of(context).cardColor.withValues(alpha: 0.08),
                    Theme.of(context).cardColor.withValues(alpha: 0.12),
                  ],
                  stops: [0.0, 0.3, 0.7, 1.0],
                ) : null,
                color: Platform.isIOS ? null : Theme.of(Flashly.context).cardColor,
                border: Platform.isIOS ? Border.all(
                  width: .6,
                  color: Theme.of(context).cardColor.withValues(alpha: 0.4),
                ) : null,
                boxShadow: Platform.isIOS ? [
                  BoxShadow(
                    color: Theme.of(context).cardColor.withValues(alpha: 0.6),
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
                ] : null,
              ),
              child: Container(
                decoration: Platform.isIOS ? BoxDecoration(
                  borderRadius: BorderRadius.circular(26),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Theme.of(context).cardColor.withValues(alpha: 0.08),
                      Theme.of(context).cardColor.withValues(alpha: 0.02),
                    ],
                  ),
                ) : null,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(Platform.isIOS ? 30 : 20),
                  child: BackdropFilter(
                    filter: Platform.isIOS 
                      ? ImageFilter.blur(sigmaX: 4, sigmaY: 4)
                      : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                    child: Container(
                      decoration: Platform.isIOS ? BoxDecoration(
                        gradient: RadialGradient(
                          center: Alignment.topLeft,
                          radius: 2.0,
                          colors: [
                            Theme.of(context).cardColor.withValues(alpha: 0.03),
                            Colors.transparent,
                          ],
                        ),
                      ) : null,
                      child: child,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    if (asLoader) return Center(child: content);
    return content;
  }
}