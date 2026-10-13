import 'package:flutter/material.dart';
import 'package:untitled/common/extensions/image_extension.dart';
import 'package:untitled/utilities/const.dart';

class LogoTag extends StatelessWidget {
  final bool? isWhite;
  final double? width;

  const LogoTag({Key? key, this.isWhite = false, this.width = 100}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      isWhite == true ? MyImages.logoWhite : MyImages.logoBlack,
      height: (width ?? 100) * 0.22,
      width: width,
      errorBuilder: (context, error, stackTrace) {
        return ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [cPrimary, cSecondary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds),
          child: Text(
            appName,
            style: TextStyle(
              fontSize: (width ?? 100) * 0.28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
        );
      },
    );
  }
}
