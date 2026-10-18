import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/common/extensions/font_extension.dart';
import 'package:untitled/common/managers/ads/interstitial_manager.dart';
import 'package:untitled/common/widgets/my_cached_image.dart';
import 'package:untitled/localization/languages.dart';
import 'package:untitled/screens/feed_screen/feed_stories_controller.dart';
import 'package:untitled/screens/story_screen/create_story_screen/create_story_screen.dart';
import 'package:untitled/screens/story_screen/story_screen.dart';
import 'package:untitled/utilities/const.dart';

class FeedStoryScreen extends StatelessWidget {
  final FeedStoriesController controller;

  const FeedStoryScreen({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: cWhite,
      height: 110,
      padding: const EdgeInsets.symmetric(vertical: 8),
      alignment: Alignment.centerLeft,
      child: GetBuilder(
          init: controller,
          builder: (controller) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              primary: true,
              child: Row(
                children: [
                  myCard(controller),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.storyUsers.length,
                    itemBuilder: (context, index) {
                      var storyUser = controller.storyUsers[index];
                      final bool isSeen = storyUser.isAllStoryShown();
                      return GestureDetector(
                        onTap: () {
                          Get.bottomSheet(StoryScreen(users: controller.storyUsers, index: index), isScrollControlled: true, ignoreSafeArea: false).then((value) {
                            controller.fetchStories();
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          width: 82,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(2.5),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: isSeen ? cGradientStorySeen : cGradientStory,
                                  boxShadow: isSeen
                                      ? null
                                      : [
                                          BoxShadow(
                                            color: cAccentPink.withValues(alpha: 0.3),
                                            blurRadius: 8,
                                            spreadRadius: 1,
                                          ),
                                        ],
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(2.0),
                                  decoration: const BoxDecoration(
                                    color: cWhite,
                                    shape: BoxShape.circle,
                                  ),
                                  child: MyCachedProfileImage(
                                    imageUrl: storyUser.profile,
                                    fullName: storyUser.fullName,
                                    width: 56,
                                    height: 56,
                                    cornerRadius: 56,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              SizedBox(
                                width: 74,
                                child: Text(
                                  storyUser.username ?? '',
                                  style: MyTextStyle.gilroySemiBold(size: 12, color: cMainText),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          }),
    );
  }

  Widget myCard(FeedStoriesController controller) {
    var isAnyStory = controller.myUser.stories?.isNotEmpty ?? false;
    final bool isSeen = controller.myUser.isAllStoryShown();
    return GestureDetector(
      onTap: () {
        InterstitialManager.shared.loadAd();
        Get.bottomSheet(CreateStoryScreen(user: controller.myUser), isScrollControlled: true, ignoreSafeArea: false).then((value) {
          controller.fetchMyStories();
          InterstitialManager.shared.showAd();
        });
      },
      child: Container(
        width: 82,
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              clipBehavior: Clip.none,
              children: [
                Container(
                  padding: const EdgeInsets.all(2.5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: isAnyStory ? (isSeen ? cGradientStorySeen : cGradientStory) : null,
                    border: isAnyStory
                        ? null
                        : Border.all(
                            color: const Color(0xFFE2E8F0),
                            width: 1.5,
                          ),
                  ),
                  child: Container(
                    padding: isAnyStory ? const EdgeInsets.all(2.0) : EdgeInsets.zero,
                    decoration: const BoxDecoration(
                      color: cWhite,
                      shape: BoxShape.circle,
                    ),
                    child: MyCachedProfileImage(
                      imageUrl: controller.myUser.profile,
                      fullName: controller.myUser.fullName,
                      width: 56,
                      height: 56,
                      cornerRadius: 56,
                    ),
                  ),
                ),
                Positioned(
                  bottom: -1,
                  right: -1,
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      gradient: cGradientPrimary,
                      shape: BoxShape.circle,
                      border: Border.all(color: cWhite, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: cPrimary.withValues(alpha: 0.45),
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.add_rounded,
                      color: cWhite,
                      size: 15,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 6),
            Text(
              LKeys.you.tr,
              style: MyTextStyle.gilroySemiBold(size: 12, color: cMainText),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
