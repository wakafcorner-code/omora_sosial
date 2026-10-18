import 'package:flutter/material.dart';
import 'package:untitled/common/extensions/image_extension.dart';
import 'package:untitled/utilities/const.dart';

class LogoTag extends StatelessWidget {
  final bool? isWhite;
  final double? width;
  final bool showIcon;
  final bool iconOnly;

  const LogoTag({
    Key? key,
    this.isWhite = false,
    this.width = 100,
    this.showIcon = true,
    this.iconOnly = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double targetWidth = width ?? 100;

    if (iconOnly) {
      return Image.asset(
        MyImages.omoraEmblem,
        width: targetWidth,
        height: targetWidth,
        fit: BoxFit.contain,
      );
    }

    final double emblemHeight = (targetWidth * 0.30).clamp(26.0, 56.0);
    final double wordmarkHeight = (emblemHeight * 0.62).clamp(16.0, 34.0);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (showIcon) ...[
          Container(
            height: emblemHeight,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: cLogoPink.withValues(alpha: 0.3),
                  blurRadius: 12,
                  spreadRadius: 1,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(emblemHeight / 2),
              child: Image.asset(
                MyImages.omoraEmblem,
                height: emblemHeight,
                fit: BoxFit.contain,
              ),
            ),
          ),
          SizedBox(width: (emblemHeight * 0.25).clamp(6.0, 10.0)),
        ],
        Image.asset(
          MyImages.omoraWordmark,
          height: wordmarkHeight,
          fit: BoxFit.contain,
        ),
      ],
    );
  }
}
