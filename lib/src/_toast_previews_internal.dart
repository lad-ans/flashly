import 'dart:ui';

import 'package:flashly/src/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

import '../flashly.dart';

@Preview()
Widget buildToasPreviewsInternal() {
  return MaterialApp(
    home: Scaffold(
      body: Center(
        child: Card(
          elevation: 20,
          color: Colors.transparent,
          shape: RoundedSuperellipseBorder(borderRadius: BorderRadius.circular(30)),
          shadowColor: Colors.black38,
          margin: EdgeInsets.zero,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                padding: EdgeInsets.fromLTRB(18, 14, 20, 14),
                constraints: BoxConstraints(maxWidth: 300, maxHeight: 220),
                decoration: BoxDecoration(
                  color: gray.withValues(alpha: .9),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  spacing: 11,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      color: green, 
                      size: 20,
                    ),
                    Flexible(
                      fit: FlexFit.loose,
                      child: Txt(
                        'Copiado para transferência',
                        maxLines: 4,
                        color: Colors.white, 
                        fontSize: 13, 
                        fontWeight: FontWeight.w700, 
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}