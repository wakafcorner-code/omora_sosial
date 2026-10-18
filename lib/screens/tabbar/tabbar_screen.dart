import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:proste_indexed_stack/proste_indexed_stack.dart';
import 'package:untitled/common/extensions/font_extension.dart';
import 'package:untitled/common/extensions/image_extension.dart';
import 'package:untitled/common/managers/ads/banner_ad.dart';
import 'package:untitled/common/managers/session_manager.dart';
import 'package:untitled/common/widgets/functions.dart';
import 'package:untitled/localization/languages.dart';
import 'package:untitled/screens/chats_screen/chats_screen.dart';
import 'package:untitled/screens/chats_screen/chats_screen_controller.dart';
import 'package:untitled/screens/dashboard_reels_screen/dashboard_reels_screen.dart';
import 'package:untitled/screens/feed_screen/feed_screen.dart';
import 'package:untitled/screens/profile_screen/profile_screen.dart';
import 'package:untitled/screens/random_screen/random_screen.dart';
import 'package:untitled/screens/rooms_screen/rooms_screen.dart';
import 'package:untitled/screens/tabbar/tabbar_controller.dart';
import 'package:untitled/utilities/const.dart';

class TabBarScreen extends StatelessWidget {
  TabBarScreen({Key? key}) : super(key: key);
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final TabBarController controller = Get.put(TabBarController());
    final ChatsScreensController chatScreenController = Get.put(ChatsScreensController());
    Functions.changStatusBar(StatusBarStyle.black);
    return Scaffold(
      backgroundColor: cWhite,
      body: GetBuilder<TabBarController>(
        builder: (controller) {
          return Column(
            children: [
              Expanded(
                child: ProsteIndexedStack(
                  children: [
                    IndexedStackChild(child: FeedScreen(scrollController: scrollController)),
                    IndexedStackChild(child: RoomsScreen()),
                    IndexedStackChild(child: DashboardReelsScreen(), preload: true),
                    IndexedStackChild(child: ChatsScreen(), preload: true),
                    IndexedStackChild(child: ProfileScreen(isFromTabBar: true, userId: SessionManager.shared.getUserID()), preload: true),
                  ],
                  index: controller.selectedTab,
                ),
              ),
              if (controller.selectedTab != 2) BannerAdView(),
              Container(
                decoration: BoxDecoration(
                  color: controller.selectedTab == 2 ? cBlack : cWhite,
                  border: Border(
                    top: BorderSide(
                      color: controller.selectedTab == 2 ? Colors.white.withValues(alpha: 0.1) : const Color(0xFFF1F5F9),
                      width: 1.0,
                    ),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: controller.selectedTab == 2 ? Colors.black38 : const Color(0xFF0F172A).withValues(alpha: 0.06),
                      blurRadius: 18,
                      offset: const Offset(0, -3),
                    )
                  ],
                ),
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: SafeArea(
                  top: false,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      button(LKeys.feed, MyImages.quill, 0, controller),
                      button(LKeys.rooms, MyImages.meeting, 1, controller),
                      button(LKeys.reels, MyImages.reels, 2, controller),
                      GetBuilder(
                          init: chatScreenController,
                          builder: (chatScreenController) {
                            return button(LKeys.chats, MyImages.chat, 3, controller, isBudged: chatScreenController.isNewMessage);
                          }),
                      button(LKeys.profile, MyImages.profile, 4, controller),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        init: controller,
      ),
    );
  }

  Widget button(String title, String image, int index, TabBarController controller, {bool isBudged = false}) {
    final bool isDarkTab = controller.selectedTab == 2;
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (index == 0 && controller.selectedTab == 0) {
            HapticFeedback.mediumImpact();
            if (scrollController.offset == 0) {
              refreshIndicatorKey.currentState?.show();
            } else {
              scrollController.animateTo(0, duration: const Duration(milliseconds: 500), curve: Curves.linear);
            }
          }
          controller.selectIndex(index);
        },
        child: Container(
          color: Colors.transparent,
          child: TabBarButton(
            image: image,
            title: title,
            isSelected: controller.selectedTab == index,
            isBudged: isBudged,
            isDark: isDarkTab,
          ),
        ),
      ),
    );
  }

  Widget selectedWidget(TabBarController controller) {
    switch (controller.selectedTab) {
      case 0:
        return FeedScreen(scrollController: scrollController);
      case 1:
        return RoomsScreen();
      case 2:
        return RandomScreen();
      case 3:
        return ChatsScreen();
      case 4:
        return ProfileScreen(
          isFromTabBar: true,
          userId: SessionManager.shared.getUserID(),
        );
    }
    return Container();
  }
}

class TabBarButton extends StatelessWidget {
  final String title;
  final String image;
  final bool isSelected;
  final bool isBudged;
  final bool isDark;

  const TabBarButton({
    super.key,
    required this.title,
    required this.image,
    required this.isSelected,
    this.isBudged = false,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color activeColor = isDark ? cWhite : cPrimary;
    final Color inactiveColor = isDark ? Colors.white60 : const Color(0xFF94A3B8);
    final Color activePillBg = isDark ? Colors.white.withValues(alpha: 0.15) : cPrimary.withValues(alpha: 0.12);

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          decoration: BoxDecoration(
            color: isSelected ? activePillBg : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topRight,
            children: [
              Image.asset(
                image,
                width: 22,
                height: 22,
                color: isSelected ? activeColor : inactiveColor,
              ),
              if (isBudged)
                Positioned(
                  top: -3,
                  right: -5,
                  child: Container(
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                      gradient: cGradientSunset,
                      shape: BoxShape.circle,
                      border: Border.all(color: isDark ? cBlack : cWhite, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: cRed.withValues(alpha: 0.5),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                )
            ],
          ),
        ),
        const SizedBox(height: 3),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              title.tr,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: isSelected
                  ? MyTextStyle.gilroyBold(size: 11, color: activeColor)
                  : MyTextStyle.gilroyMedium(size: 11, color: inactiveColor),
            ),
          ),
        ),
      ],
    );
  }
}
