import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/common/extensions/image_extension.dart';
import 'package:untitled/screens/audio_space/audio_spaces_screen/audio_spaces_screen.dart';
import 'package:untitled/screens/extra_views/logo_tag.dart';
import 'package:untitled/screens/notification_screen/notification_screen.dart';
import 'package:untitled/screens/random_screen/random_screen.dart';
import 'package:untitled/screens/search_screen/search_screen.dart';
import 'package:untitled/utilities/const.dart';

class FeedScreenTopBar extends StatelessWidget {
  const FeedScreenTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: cWhite,
        border: Border(
          bottom: BorderSide(color: Color(0xFFF1F5F9), width: 1),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            const LogoTag(width: 105),
            const Spacer(),
            _iconButton(
              image: MyImages.random,
              bgColor: const Color(0xFFFDF2F8),
              iconColor: cLogoPink,
              imageSize: 16,
              onTap: () {
                Get.to(() => RandomScreen());
              },
            ),
            const SizedBox(width: 6),
            _iconButton(
              image: MyImages.audioRoom,
              bgColor: const Color(0xFFF5F3FF),
              iconColor: cLogoPurple,
              imageSize: 17,
              onTap: () {
                Get.to(() => const AudioSpacesScreen());
              },
            ),
            const SizedBox(width: 6),
            _iconButton(
              image: MyImages.search,
              bgColor: const Color(0xFFECFEFF),
              iconColor: const Color(0xFF0284C7),
              imageSize: 17,
              onTap: () {
                Get.to(() => const SearchScreen());
              },
            ),
            const SizedBox(width: 6),
            _iconButton(
              image: MyImages.bell,
              bgColor: const Color(0xFFEEF2FF),
              iconColor: const Color(0xFF6366F1),
              imageSize: 17,
              onTap: () {
                Get.to(() => const NotificationScreen());
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconButton({
    required String image,
    required Color bgColor,
    required Color iconColor,
    required VoidCallback onTap,
    double imageSize = 20,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Image.asset(
            image,
            width: imageSize,
            height: imageSize,
            color: iconColor,
          ),
        ),
      ),
    );
  }
}
