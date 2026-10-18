import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/common/extensions/font_extension.dart';
import 'package:untitled/enums/reel_page_type.dart';
import 'package:untitled/localization/languages.dart';
import 'package:untitled/screens/dashboard_reels_screen/dashboard_reels_controller.dart';
import 'package:untitled/screens/reels_screen/reels_screen.dart';
import 'package:untitled/utilities/const.dart';

class DashboardReelsScreen extends StatelessWidget {
  const DashboardReelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    DashboardReelsController controller = Get.put(DashboardReelsController());
    Widget topTag(DashboardReelPageType type) {
      return Obx(
        () {
          final bool isSelected = type == controller.selectedPageType.value;
          return GestureDetector(
            onTap: () {
              controller.changeTheType(type);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white.withValues(alpha: 0.22) : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                type.title.tr,
                style: isSelected
                    ? MyTextStyle.gilroyBold(color: cWhite, size: 16)
                    : MyTextStyle.gilroyMedium(color: Colors.white70, size: 16),
              ),
            ),
          );
        },
      );
    }

    return Container(
      color: cBlack,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          PageView(
            controller: controller.pageController,
            onPageChanged: controller.onChangePage,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              ReelsScreen(
                reels: controller.reelsOfFollowings,
                position: 0.obs,
                pageType: ReelPageType.following,
                isLoading: controller.isLoading,
                onFetchMoreData: controller.fetchFollowingReels,
                onRefresh: controller.fetchReels,
                noReelDescription: LKeys.noReelsFromFollowings,
              ),
              ReelsScreen(
                reels: controller.reels,
                position: 0.obs,
                pageType: ReelPageType.home,
                isLoading: controller.isLoading,
                onFetchMoreData: controller.fetchReels,
                onRefresh: controller.refreshReels,
              )
            ],
          ),
          SafeArea(
            child: Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white.withValues(alpha: 0.15), width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  topTag(DashboardReelPageType.following),
                  const SizedBox(width: 4),
                  topTag(DashboardReelPageType.forYou),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
