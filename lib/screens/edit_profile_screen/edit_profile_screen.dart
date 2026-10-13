import 'dart:io';

import 'package:figma_squircle_updated/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/common/extensions/font_extension.dart';
import 'package:untitled/common/managers/session_manager.dart';
import 'package:untitled/common/widgets/my_cached_image.dart';
import 'package:untitled/localization/languages.dart';
import 'package:untitled/screens/edit_profile_screen/edit_profile_controller.dart';
import 'package:untitled/screens/extra_views/buttons.dart';
import 'package:untitled/screens/extra_views/top_bar.dart';
import 'package:untitled/screens/interests_screen/interests_controller.dart';
import 'package:untitled/screens/interests_screen/interests_screen.dart';
import 'package:untitled/screens/profile_picture_screen/profile_picture_screen.dart';
import 'package:untitled/screens/rooms_you_own/create_room_screen/create_room_screen.dart';
import 'package:untitled/screens/username_screen/username_screen.dart';
import 'package:untitled/utilities/const.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    EditProfileController controller = Get.put(EditProfileController());
    return Scaffold(
      body: Column(
        children: [
          const TopBarForInView(title: LKeys.editProfile),
          GetBuilder(
              init: controller,
              builder: (controller) {
                return Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Banner & Profile Picture Stack
                          SizedBox(
                            height: 290,
                            child: Stack(
                              children: [
                                backGroundImage(controller: controller, boxSize: Get.width / 1.5, radius: 25),
                                GestureDetector(
                                  onTap: () {
                                    controller.pickBGImage();
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    height: 226,
                                    decoration: ShapeDecoration(
                                      gradient: LinearGradient(colors: [
                                        cBlack.withValues(alpha: 0.5),
                                        Colors.transparent,
                                      ], begin: Alignment.bottomCenter, end: Alignment.topCenter),
                                      shape: const SmoothRectangleBorder(borderRadius: SmoothBorderRadius.all(SmoothRadius(cornerRadius: 25, cornerSmoothing: cornerSmoothing))),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    decoration: ShapeDecoration(shape: const SmoothRectangleBorder(borderRadius: SmoothBorderRadius.all(SmoothRadius(cornerRadius: 25, cornerSmoothing: cornerSmoothing))), shadows: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.1),
                                        blurRadius: 5,
                                        offset: const Offset(0, 4),
                                      )
                                    ]),
                                    child: ProfileImagePicker(
                                      dotColor: Colors.transparent,
                                      imageURL: SessionManager.shared.getUser()?.profile,
                                      controller: controller,
                                      boxSize: 140,
                                      radius: 25,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // --- PILIH KARAKTER AVATAR SECTION ---
                          _buildAvatarPickerSection(controller),

                          const SizedBox(height: 15),

                          // --- NAMA LENGKAP SECTION ---
                          const CreateRoomHeading(title: LKeys.fullName),
                          MyTextField(controller: controller.fullNameController, placeHolder: "Nama Lengkap"),

                          const SizedBox(height: 10),

                          // --- JENIS KELAMIN SECTION ---
                          _buildGenderPickerSection(controller),

                          const SizedBox(height: 10),

                          // --- USERNAME SECTION ---
                          UserNameTextField(controller: controller),

                          const SizedBox(height: 10),

                          // --- BIO SECTION ---
                          GetBuilder(
                              init: controller,
                              id: 'bio',
                              builder: (controller) {
                                return Column(
                                  children: [
                                    CreateRoomHeading(
                                      title: LKeys.bio,
                                      bracketText: "(${controller.bioEditController.text.length}/${Limits.bioCount})",
                                    ),
                                    MyTextField(
                                      controller: controller.bioEditController,
                                      placeHolder: LKeys.writeSomethingAboutYourSelf.tr,
                                      isEditor: true,
                                      limit: Limits.bioCount,
                                    ),
                                  ],
                                );
                              }),

                          const SizedBox(height: 10),

                          // --- MINAT / INTERESTS SECTION ---
                          GetBuilder<EditProfileController>(
                              init: controller,
                              builder: (controller) {
                                return Column(
                                  children: [
                                    CreateRoomHeading(
                                      title: LKeys.interests,
                                      bracketText: "(${controller.selectedInterests.length}/${Limits.interestCount})",
                                    ),
                                    Wrap(
                                      crossAxisAlignment: WrapCrossAlignment.center,
                                      alignment: WrapAlignment.center,
                                      children: InterestsController.interests.map((e) {
                                        return InterestTag(
                                            interest: e.title ?? '',
                                            isContain: controller.selectedInterests.contains(e),
                                            onTap: () {
                                              controller.toggleInterest(e);
                                            });
                                      }).toList(),
                                    ),
                                  ],
                                );
                              }),

                          const SizedBox(height: 40),

                          // --- SUBMIT BUTTON ---
                          SafeArea(
                            top: false,
                            child: CommonButton(text: "Simpan Perubahan", onTap: controller.onSubmit),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                );
              }),
        ],
      ),
    );
  }

  /// Avatar Character Selector Section
  Widget _buildAvatarPickerSection(EditProfileController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CreateRoomHeading(
          title: "Karakter Avatar",
          bracketText: "(16 Pilihan Karakter)",
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 100,
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
                  margin: const EdgeInsets.only(right: 12, top: 4, bottom: 4),
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    color: isSelected ? cPrimary.withValues(alpha: 0.15) : cLightBg,
                    border: Border.all(
                      color: isSelected ? cPrimary : Colors.transparent,
                      width: isSelected ? 3.0 : 1.0,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: cPrimary.withValues(alpha: 0.35),
                              blurRadius: 10,
                              spreadRadius: 1,
                              offset: const Offset(0, 3),
                            )
                          ]
                        : [],
                  ),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(19),
                        child: Image.asset(
                          asset,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                      if (isSelected)
                        Positioned(
                          top: 6,
                          right: 6,
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            decoration: const BoxDecoration(
                              color: cPrimary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check_rounded,
                              color: cBlack,
                              size: 14,
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
  }

  /// Gender Selection Section
  Widget _buildGenderPickerSection(EditProfileController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CreateRoomHeading(title: "Jenis Kelamin"),
        GetBuilder<EditProfileController>(
          id: 'gender',
          init: controller,
          builder: (controller) {
            final genders = [
              {"title": "Laki-laki", "icon": "♂️"},
              {"title": "Perempuan", "icon": "♀️"},
            ];
            return Row(
              children: genders.map((g) {
                final isSelected = controller.selectedGender == g["title"];
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      controller.setGender(g["title"]!);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                      decoration: ShapeDecoration(
                        shape: const SmoothRectangleBorder(
                          borderRadius: SmoothBorderRadius.all(
                            SmoothRadius(cornerRadius: 18, cornerSmoothing: cornerSmoothing),
                          ),
                        ),
                        color: isSelected ? cPrimary : cLightBg,
                        shadows: isSelected ? kMyBoxShadow : [],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            g["icon"]!,
                            style: const TextStyle(fontSize: 18),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            g["title"]!,
                            style: MyTextStyle.gilroyBold(
                              color: isSelected ? cBlack : cLightText,
                              size: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget backGroundImage({required EditProfileController controller, double? boxSize, required double radius}) {
    var imageURL = SessionManager.shared.getUser()?.backgroundImage;
    return Padding(
        padding: const EdgeInsets.only(top: 6),
        child: GetBuilder(
          init: controller,
          builder: (controller) {
            var isEdit = imageURL != null || controller.backgroundImageFile != null;
            return ClipSmoothRect(
              radius: SmoothBorderRadius.all(SmoothRadius(cornerRadius: radius - 2, cornerSmoothing: cornerSmoothing)),
              child: Container(
                  width: double.infinity,
                  height: 220,
                  decoration: ShapeDecoration(
                    shape: SmoothRectangleBorder(borderRadius: SmoothBorderRadius.all(SmoothRadius(cornerRadius: radius, cornerSmoothing: cornerSmoothing))),
                    color: cLightBg,
                  ),
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Stack(
                        fit: StackFit.expand,
                        children: [
                          (imageURL != null && controller.backgroundImageFile == null) ? MyCachedImage(imageUrl: imageURL) : Container(),
                          controller.backgroundImageFile == null
                              ? Container()
                              : Image.file(
                                  File(controller.backgroundImageFile?.path ?? ''),
                                  fit: BoxFit.cover,
                                ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          backgroundColor: cBlack.withValues(alpha: 0.3),
                          radius: 20,
                          child: Icon(
                            isEdit ? Icons.mode_edit_sharp : Icons.add_circle,
                            color: cWhite,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  )),
            );
          },
        ));
  }
}
