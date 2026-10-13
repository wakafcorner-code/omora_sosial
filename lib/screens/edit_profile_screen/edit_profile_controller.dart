import 'dart:io';

import 'package:detectable_text_field/detectable_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled/common/api_service/user_service.dart';
import 'package:untitled/common/controller/base_controller.dart';
import 'package:untitled/common/extensions/font_extension.dart';
import 'package:untitled/common/managers/session_manager.dart';
import 'package:untitled/localization/languages.dart';
import 'package:untitled/models/registration.dart';
import 'package:untitled/utilities/const.dart';

import '../profile_picture_screen/profile_picture_controller.dart';

class EditProfileController extends ProfilePictureController {
  TextEditingController fullNameController = TextEditingController();
  DetectableTextEditingController bioEditController = DetectableTextEditingController(
    detectedStyle: MyTextStyle.gilroyRegular(color: cPrimary).copyWith(height: 1.2),
    regExp: detectionRegExp(atSign: false, url: true, hashtag: false)!,
  );
  XFile? backgroundImageFile;

  // Selection state
  String selectedGender = "Laki-laki";

  @override
  void onInit() {
    fetchOldValues();
    bioEditController.addListener(() {
      update(['bio']);
    });
    super.onInit();
  }

  void setGender(String gender) {
    selectedGender = gender;
    update(['gender']);
  }

  void pickBGImage({ImageSource source = ImageSource.gallery}) async {
    try {
      XFile? image = await picker.pickImage(source: source);
      if (image != null) {
        backgroundImageFile = image;
        update();
      }
    } catch (e) {
      showSnackBar("Gambar tidak valid");
    }
  }

  void fetchOldValues() {
    var user = SessionManager.shared.getUser();
    if (user != null) {
      textController.text = user.username ?? '';
      fullNameController.text = user.fullName ?? '';
      bioEditController.text = user.bio ?? '';
      if (user.gender != null && user.gender!.isNotEmpty) {
        selectedGender = user.gender!;
      }
      selectedInterests = user.getInterests();
    }
  }

  void onSubmit() {
    if (fullNameController.text.trim().isEmpty) {
      showSnackBar(LKeys.pleaseEnterFullName.tr, type: SnackBarType.error);
      return;
    }
    startLoading();
    checkForUsername(completion: (isAvailable) {
      stopLoading();
      if (!isAvailable) {
        showSnackBar(LKeys.thisUsernameIsNotAvailable.tr, type: SnackBarType.error);
      } else {
        startLoading();
        UserService.shared.editProfile(
          profileImage: file,
          bgImage: backgroundImageFile,
          fullName: fullNameController.text.trim(),
          username: textController.text.trim(),
          bio: bioEditController.text.trim(),
          gender: selectedGender,
          interests: selectedInterests,
          completion: (p0) {
            stopLoading();
            Get.back();
            showSnackBar(LKeys.profileUpdatedSuccessfully.tr, type: SnackBarType.success);
          },
        );
      }
    });
  }
}
