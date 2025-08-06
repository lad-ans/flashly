import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class RichTxt extends StatelessWidget {
  const RichTxt({
    super.key, 
    this.fontWeight, 
    this.fontWeight1, 
    this.fontWeight2, 
    this.decoration, 
    this.decoration1, 
    this.decoration2, 
    required this.text1, 
    required this.text2, 
    this.fontFamily, 
    this.fontFamily1, 
    this.fontFamily2, 
    this.color, 
    this.color1, 
    this.color2, 
    this.fontSize, 
    this.fontSize1, 
    this.fontSize2, 
    this.textAlign, 
    this.onTap1, 
    this.onTap2, 
    this.textOverflow1, 
    this.textOverflow2,
  });

    final FontWeight? fontWeight;
    final FontWeight? fontWeight1;
    final FontWeight? fontWeight2;
    final TextDecoration? decoration;
    final TextDecoration? decoration1;
    final TextDecoration? decoration2;
    final String text1;
    final String text2;
    final String? fontFamily;
    final String? fontFamily1;
    final String? fontFamily2;
    final Color? color;
    final Color? color1;
    final Color? color2;
    final double? fontSize;
    final double? fontSize1;
    final double? fontSize2;
    final TextAlign? textAlign;
    final VoidCallback? onTap1;
    final VoidCallback? onTap2;
    final TextOverflow? textOverflow1;
    final TextOverflow? textOverflow2;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: text1,
            recognizer: TapGestureRecognizer()..onTap = onTap2,
            style: TextStyle(
              overflow: textOverflow1,
              color: color ?? color1 ?? Theme.of(context).colorScheme.onSurface,
              fontSize: fontSize ?? fontSize1 ?? 14,
              fontWeight: fontWeight ?? fontWeight1,
              fontFamily: fontFamily1 ?? fontFamily,
              decoration: decoration ?? decoration1,
            ),
          ),
          TextSpan(
            text: text2,
            recognizer: TapGestureRecognizer()..onTap = onTap2,
            style: TextStyle(
              overflow: textOverflow2,
              color: color ?? color2 ?? Theme.of(context).colorScheme.onSurface,
              fontSize: fontSize ?? fontSize2 ?? 14,
              fontWeight: fontWeight ?? fontWeight2,
              fontFamily: fontFamily2 ?? fontFamily,
              decoration: decoration ?? decoration2,
            ),
          ),
        ],
      ),
      textAlign: textAlign,
    );
  }
}