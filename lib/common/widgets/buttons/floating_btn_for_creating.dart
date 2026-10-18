import 'package:figma_squircle_updated/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/common/extensions/font_extension.dart';
import 'package:untitled/common/extensions/image_extension.dart';
import 'package:untitled/common/managers/ads/interstitial_manager.dart';
import 'package:untitled/common/managers/session_manager.dart';
import 'package:untitled/localization/languages.dart';
import 'package:untitled/models/posts_model.dart';
import 'package:untitled/models/reel_model.dart';
import 'package:untitled/models/registration.dart';
import 'package:untitled/screens/add_post_screen/add_post_screen.dart';
import 'package:untitled/screens/camera_screen/create_reel_screen.dart';
import 'package:untitled/screens/story_screen/create_story_screen/create_story_screen.dart';
import 'package:untitled/utilities/const.dart';

class FloatingBtnForCreating extends StatelessWidget {
  final Function(Post feed)? onPostBack;
  final Function()? onStoryBack;
  final Function(Reel reel)? onReelBack;

  const FloatingBtnForCreating({super.key, this.onPostBack, this.onStoryBack, this.onReelBack});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 18, bottom: 32),
        child: GestureDetector(
          onTap: _openSheet,
          child: Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              gradient: cGradientPrimary,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: cPrimary.withValues(alpha: 0.45),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Image.asset(
              MyImages.quill,
              width: 26,
              height: 26,
              color: cWhite,
            ),
          ),
        ),
      ),
    );
  }

  void _openSheet() {
    InterstitialManager.shared.loadAd();
    Get.bottomSheet(_CreatingChooseSheet(
      onPostTap: _createPost,
      onReelTap: _createReel,
      onStoryTap: _createStory,
    ));
  }

  void _createStory() {
    Get.bottomSheet(
            CreateStoryScreen(
              user: SessionManager.shared.getUser() ?? User(),
              shouldShowStory: false,
            ),
            isScrollControlled: true,
            ignoreSafeArea: false)
        .then((value) {
      InterstitialManager.shared.showAd();
      if (onStoryBack != null) {
        onStoryBack!();
      }
    });
  }

  void _createPost() {
    Get.to(() => AddPostScreen())?.then((value) {
      InterstitialManager.shared.showAd();
      if (value is Post) {
        if (onPostBack != null) {
          onPostBack!(value);
        }
      }
    });
  }

  void _createReel() {
    Get.to(() => CreateReelScreen())?.then((value) {
      InterstitialManager.shared.showAd();
      if (value is Reel) {
        if (onReelBack != null) {
          onReelBack!(value);
        }
      }
    });
  }
}

class _CreatingChooseSheet extends StatelessWidget {
  final Function() onPostTap;
  final Function() onStoryTap;
  final Function() onReelTap;

  const _CreatingChooseSheet({required this.onPostTap, required this.onStoryTap, required this.onReelTap});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Wrap(
        children: [
          ClipSmoothRect(
            radius: const SmoothBorderRadius.vertical(
              top: SmoothRadius(cornerRadius: 28, cornerSmoothing: cornerSmoothing),
            ),
            child: Container(
              color: cBlackSheetBG,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: SafeArea(
                child: Column(
                  children: [
                    // Drag Handle
                    Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16, top: 4),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          LKeys.upload.tr,
                          style: MyTextStyle.gilroyBold(color: cWhite, size: 20),
                        ),
                        InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: CircleAvatar(
                            radius: 16,
                            backgroundColor: cWhite.withValues(alpha: 0.1),
                            child: Image.asset(
                              MyImages.close,
                              height: 12,
                              width: 12,
                              color: cWhite,
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 16),
                    _card(
                      imageName: MyImages.feed,
                      title: LKeys.feed,
                      subtitle: "Bagikan postingan foto, teks, atau audio",
                      gradient: cGradientPrimary,
                      onTap: onPostTap,
                    ),
                    const SizedBox(height: 10),
                    _card(
                      imageName: MyImages.story,
                      title: LKeys.story,
                      subtitle: "Momen visual 24 jam untuk pengikut Anda",
                      gradient: cGradientReels,
                      onTap: onStoryTap,
                    ),
                    const SizedBox(height: 10),
                    _card(
                      imageName: MyImages.reels,
                      title: LKeys.reels,
                      subtitle: "Buat video pendek seru dan menarik",
                      gradient: cGradientSunset,
                      onTap: onReelTap,
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _card({
    required String imageName,
    required String title,
    required String subtitle,
    required LinearGradient gradient,
    required Function() onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Get.back();
          onTap();
        },
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08), width: 1),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: gradient,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: gradient.colors.first.withValues(alpha: 0.35),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Image.asset(
                  imageName,
                  width: 24,
                  height: 24,
                  color: cWhite,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title.tr,
                      style: MyTextStyle.gilroyBold(size: 16, color: cWhite),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: MyTextStyle.gilroyRegular(size: 12, color: cLightText),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: Colors.white38,
                size: 22,
              )
            ],
          ),
        ),
      ),
    );
  }
}
