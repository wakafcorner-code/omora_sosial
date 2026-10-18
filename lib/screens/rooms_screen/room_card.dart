import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/common/extensions/font_extension.dart';
import 'package:untitled/common/extensions/int_extension.dart';
import 'package:untitled/common/widgets/my_cached_image.dart';
import 'package:untitled/localization/languages.dart';
import 'package:untitled/models/room_model.dart';
import 'package:untitled/screens/chats_screen/chatting_screen/chatting_view.dart';
import 'package:untitled/screens/rooms_screen/room_controller.dart';
import 'package:untitled/screens/rooms_screen/room_sheet.dart';
import 'package:untitled/utilities/const.dart';

class RoomCard extends StatelessWidget {
  final Room room;
  final bool isFromHome;

  const RoomCard({Key? key, required this.room, this.isFromHome = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = RoomController(room);
    return GetBuilder(
        tag: '${room.id}',
        init: controller,
        builder: (controller) {
          return GestureDetector(
            onTap: () {
              if (controller.room.getUserAccessType() == GroupUserAccessType.member || controller.room.getUserAccessType() == GroupUserAccessType.admin || controller.room.getUserAccessType() == GroupUserAccessType.coAdmin) {
                Get.to(() => ChattingView(room: controller.room))?.then(controller.onBack);
              } else {
                Get.bottomSheet(
                    RoomSheet(
                      controller: controller,
                      room: controller.room,
                    ),
                    isScrollControlled: true);
              }
            },
            child: isFromHome ? homeCard(controller) : simpleCard(controller),
          );
        });
  }

  Widget simpleCard(RoomController controller) {
    return Container(
      decoration: BoxDecoration(
        color: cWhite,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: cGradientPrimary,
                ),
                child: Container(
                  padding: const EdgeInsets.all(1.5),
                  decoration: const BoxDecoration(
                    color: cWhite,
                    shape: BoxShape.circle,
                  ),
                  child: MyCachedImage(
                    imageUrl: controller.room.photo,
                    width: 56,
                    height: 56,
                    cornerRadius: 56,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.room.title ?? '',
                      style: MyTextStyle.gilroyBold(size: 18, color: cBlack),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEF2FF),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.people_alt_rounded,
                            size: 14,
                            color: cSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            (controller.room.totalMember ?? 0).makeToString(),
                            style: MyTextStyle.gilroyBold(size: 12, color: cSecondary),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            LKeys.members.tr,
                            style: MyTextStyle.gilroyMedium(size: 12, color: cSecondary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFF94A3B8),
                size: 24,
              )
            ],
          ),
          if (controller.room.desc?.isNotEmpty == true) ...[
            const SizedBox(height: 10),
            Text(
              controller.room.desc ?? '',
              style: MyTextStyle.outfitRegular(color: cDarkText, size: 14),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: controller.room.getInterests().map((e) {
              return RoomCardInterestTagToShow(
                tag: e.title ?? '',
              );
            }).toList(),
          )
        ],
      ),
    );
  }

  Widget homeCard(RoomController controller) {
    final VibrantColorPair colorPair = getVibrantColorPair(controller.room.title ?? '');
    return AspectRatio(
      aspectRatio: .7,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Column(
            children: [
              SizedBox(
                height: 115,
                width: double.infinity,
                child: MyCachedImage(
                  imageUrl: controller.room.photo,
                  width: double.infinity,
                  height: 115,
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        cBlackSheetBG,
                        cDarkBG,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.room.title ?? '',
                            style: MyTextStyle.gilroyBold(color: cWhite, size: 15),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            controller.room.getInterestWithHashtag().toLowerCase(),
                            style: MyTextStyle.gilroySemiBold(color: colorPair.text, size: 12),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.people_alt_rounded,
                              size: 13,
                              color: cWhite,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              (controller.room.totalMember ?? 0).makeToString(),
                              style: MyTextStyle.gilroyBold(size: 12, color: cWhite),
                            ),
                            const SizedBox(width: 3),
                            Text(
                              LKeys.members.tr,
                              style: MyTextStyle.gilroyLight(size: 12, color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class RoomCardInterestTagToShow extends StatelessWidget {
  const RoomCardInterestTagToShow({super.key, required this.tag, this.color});
  final String tag;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final VibrantColorPair pair = getVibrantColorPair(tag);
    final Color effectiveBg = color != null ? color!.withValues(alpha: 0.12) : pair.bg;
    final Color effectiveText = color ?? pair.text;

    return Container(
      decoration: BoxDecoration(
        color: effectiveBg,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: effectiveText.withValues(alpha: 0.25), width: 1),
      ),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 11),
      margin: const EdgeInsets.only(right: 4, top: 3, bottom: 3),
      child: Text(
        tag.toUpperCase(),
        style: MyTextStyle.gilroyBold(size: 11, color: effectiveText).copyWith(letterSpacing: 0.5),
      ),
    );
  }
}
