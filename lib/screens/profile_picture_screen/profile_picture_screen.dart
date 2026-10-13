import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:figma_squircle_updated/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/common/extensions/font_extension.dart';
import 'package:untitled/common/widgets/my_cached_image.dart';
import 'package:untitled/localization/languages.dart';
import 'package:untitled/screens/extra_views/buttons.dart';
import 'package:untitled/screens/extra_views/top_bar.dart';
import 'package:untitled/screens/profile_picture_screen/profile_picture_controller.dart';
import 'package:untitled/screens/rooms_you_own/create_room_screen/create_room_screen.dart';
import 'package:untitled/screens/tabbar/tabbar_screen.dart';
import 'package:untitled/utilities/const.dart';

class ProfilePictureScreen extends StatelessWidget {
  const ProfilePictureScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ProfilePictureController controller = Get.put(ProfilePictureController());

    return Scaffold(
      backgroundColor: cBG,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(
                    child: TopBarForOnBoarding(
                      titleStart: LKeys.selectYour,
                      titleEnd: LKeys.profilePicture,
                      desc: LKeys.setProfileDesc,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.offAll(() => TabBarScreen());
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: cWhite,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: cPrimary.withValues(alpha: 0.3)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          )
                        ],
                      ),
                      child: Text(
                        "Lewati",
                        style: MyTextStyle.gilroyBold(color: cPrimary, size: 14),
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              ProfileImagePicker(controller: controller),
              const Spacer(),

              // --- PILIH KARAKTER AVATAR ---
              GetBuilder<ProfilePictureController>(
                init: controller,
                builder: (controller) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CreateRoomHeading(
                        title: "Atau Pilih Karakter Avatar",
                        bracketText: "(16 Pilihan)",
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 90,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: controller.avatarAssets.length,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            final asset = controller.avatarAssets[index];
                            final isSelected = controller.selectedAvatarAsset == asset;

                            return GestureDetector(
                              onTap: () {
                                controller.selectAvatarAsset(asset);
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                margin: const EdgeInsets.only(right: 10, top: 4, bottom: 4),
                                width: 72,
                                height: 72,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: isSelected ? cPrimary.withValues(alpha: 0.15) : cWhite,
                                  border: Border.all(
                                    color: isSelected ? cPrimary : Colors.transparent,
                                    width: isSelected ? 3.0 : 1.0,
                                  ),
                                  boxShadow: isSelected
                                      ? [
                                          BoxShadow(
                                            color: cPrimary.withValues(alpha: 0.35),
                                            blurRadius: 8,
                                            spreadRadius: 1,
                                            offset: const Offset(0, 3),
                                          )
                                        ]
                                      : [
                                          BoxShadow(
                                            color: Colors.black.withValues(alpha: 0.04),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          )
                                        ],
                                ),
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(17),
                                      child: Image.asset(
                                        asset,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: double.infinity,
                                      ),
                                    ),
                                    if (isSelected)
                                      Positioned(
                                        top: 4,
                                        right: 4,
                                        child: Container(
                                          padding: const EdgeInsets.all(2),
                                          decoration: const BoxDecoration(
                                            color: cPrimary,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.check_rounded,
                                            color: cBlack,
                                            size: 12,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 20),
              CommonButton(
                  text: LKeys.continue1,
                  onTap: () {
                    controller.uploadImage();
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileImagePicker extends StatelessWidget {
  final String? imageURL;
  final double? boxSize;
  final ProfilePictureController controller;
  final double radius;
  final Color dotColor;
  final Function()? onTap;

  const ProfileImagePicker({Key? key, this.boxSize, required this.controller, this.radius = 60, this.onTap, this.imageURL, this.dotColor = cLightText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfilePictureController>(
      init: controller,
      builder: (controller) {
        var isEdit = imageURL != null || controller.file != null;
        double pickerSize = boxSize ?? (MediaQuery.of(context).size.width / 1.6);

        return GestureDetector(
          onTap: () {
            if (onTap != null) {
              onTap!();
            } else {
              controller.pickImage();
            }
          },
          child: DottedBorder(
              options: RoundedRectDottedBorderOptions(
                dashPattern: const [3, 2],
                color: dotColor,
                radius: Radius.circular(radius),
              ),
              child: ClipSmoothRect(
                radius: SmoothBorderRadius.all(SmoothRadius(cornerRadius: radius, cornerSmoothing: cornerSmoothing)),
                child: Container(
                    width: pickerSize,
                    height: pickerSize,
                    decoration: ShapeDecoration(
                      shape: SmoothRectangleBorder(borderRadius: SmoothBorderRadius.all(SmoothRadius(cornerRadius: radius, cornerSmoothing: cornerSmoothing))),
                      color: cLightBg,
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      alignment: Alignment.center,
                      children: [
                        (imageURL != null && controller.file == null)
                            ? MyCachedImage(
                                imageUrl: imageURL ?? '',
                              )
                            : Container(),
                        controller.imagePath == ""
                            ? Container()
                            : Image.file(
                                File(controller.imagePath),
                                fit: BoxFit.cover,
                              ),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            CircleAvatar(
                              backgroundColor: cBlack.withValues(alpha: 0.3),
                              radius: 20,
                              child: Icon(
                                isEdit ? Icons.mode_edit_sharp : Icons.add_a_photo_rounded,
                                color: cWhite,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )),
              )),
        );
      },
    );
  }
}
