import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:figma_squircle_updated/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:untitled/common/extensions/font_extension.dart';
import 'package:untitled/common/extensions/image_extension.dart';
import 'package:untitled/utilities/const.dart';

class MyCachedImage extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final double cornerRadius;

  const MyCachedImage({
    super.key,
    this.imageUrl,
    this.width,
    this.height,
    this.cornerRadius = 0,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty || !Uri.parse(imageUrl!.addBaseURL()).isAbsolute) {
      return placeHolder();
    }

    return ClipSmoothRect(
      radius: SmoothBorderRadius(
        cornerRadius: min(((width ?? 0) / 2), cornerRadius),
        cornerSmoothing: cornerSmoothing,
      ),
      child: CachedNetworkImage(
        cacheKey: imageUrl?.addBaseURL() ?? '',
        imageUrl: imageUrl?.addBaseURL() ?? '',
        width: width,
        height: height,
        fit: BoxFit.cover,
        memCacheWidth: (width != null && width! > 0) ? (width! * 2.5).toInt().clamp(100, 1440) : null,
        memCacheHeight: (height != null && height! > 0) ? (height! * 2.5).toInt().clamp(100, 2560) : null,
        fadeInDuration: const Duration(milliseconds: 150),
        fadeOutDuration: const Duration(milliseconds: 150),
        errorWidget: (context, url, error) {
          return placeHolder();
        },
        placeholder: (context, url) {
          return placeHolder();
        },
      ),
    );
  }

  Widget placeHolder() {
    return ClipSmoothRect(
      radius: SmoothBorderRadius(
        cornerRadius: min(((width ?? 0) / 2), cornerRadius),
        cornerSmoothing: cornerSmoothing,
      ),
      child: Image.asset(
        MyImages.placeHolderImage,
        width: width,
        height: height,
        fit: BoxFit.cover,
      ),
    );
  }
}

class MyCachedProfileImage extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final String? fullName;
  final double cornerRadius;

  const MyCachedProfileImage({
    super.key,
    this.imageUrl,
    this.width,
    this.height,
    this.fullName,
    this.cornerRadius = 0,
  });

  @override
  Widget build(BuildContext context) {
    // Check if the imageUrl is null, empty, or not a valid URL
    if (imageUrl == null || imageUrl!.isEmpty || !Uri.parse(imageUrl!.addBaseURL()).isAbsolute) {
      return placeHolder();
    }

    return ClipSmoothRect(
      radius: SmoothBorderRadius(
        cornerRadius: min(((width ?? 0) / 2), cornerRadius),
        cornerSmoothing: cornerSmoothing,
      ),
      child: CachedNetworkImage(
        memCacheWidth: (width != null && width! > 0) ? (width! * 2.5).toInt().clamp(80, 400) : 200,
        memCacheHeight: (height != null && height! > 0) ? (height! * 2.5).toInt().clamp(80, 400) : 200,
        fadeInDuration: const Duration(milliseconds: 150),
        fadeOutDuration: const Duration(milliseconds: 150),
        imageUrl: imageUrl?.addBaseURL() ?? '',
        width: width,
        height: height,
        fit: BoxFit.cover,
        placeholder: (context, url) => placeHolder(),
        errorWidget: (context, url, error) {
          return placeHolder();
        },
      ),
    );
  }

  Widget placeHolder() {
    final String initial = fullName == null || fullName!.trim().isEmpty ? "O" : fullName!.trim()[0].toUpperCase();
    final double fontSize = min(((width ?? 45) * 0.45), 28.0);
    return ClipSmoothRect(
      radius: SmoothBorderRadius(
        cornerRadius: min(((width ?? 0) / 2), cornerRadius),
        cornerSmoothing: cornerSmoothing,
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: getAvatarGradient(fullName ?? initial),
        ),
        height: height,
        width: width,
        alignment: Alignment.center,
        padding: const EdgeInsets.only(top: 1),
        child: Text(
          initial,
          style: MyTextStyle.gilroyBold(color: cWhite, size: fontSize),
        ),
      ),
    );
  }
}
