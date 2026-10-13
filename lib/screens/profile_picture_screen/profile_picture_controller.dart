import 'dart:io';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:untitled/common/api_service/user_service.dart';
import 'package:untitled/common/managers/logger.dart';
import 'package:untitled/screens/tabbar/tabbar_screen.dart';
import 'package:untitled/screens/username_screen/username_controller.dart';
import 'package:untitled/utilities/const.dart';

class ProfilePictureController extends UsernameController {
  final ImagePicker picker = ImagePicker();
  String imagePath = "";
  XFile? file;
  String? selectedAvatarAsset;

  final List<String> avatarAssets = List.generate(
    16,
    (index) => 'assets/images/avatar_${index + 1}.png',
  );

  void selectAvatarAsset(String assetPath) async {
    try {
      selectedAvatarAsset = assetPath;
      final byteData = await rootBundle.load(assetPath);
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/${assetPath.split('/').last}');
      await tempFile.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
      file = XFile(tempFile.path);
      imagePath = tempFile.path;
      update();
    } catch (e) {
      Loggers.error("Gagal memilih avatar: $e");
    }
  }

  void pickImage({ImageSource source = ImageSource.gallery}) async {
    try {
      XFile? image = await picker.pickImage(
        source: source,
        maxHeight: Limits.imageSize,
        maxWidth: Limits.imageSize,
        imageQuality: Limits.quality,
      );
      if (image != null) {
        selectedAvatarAsset = null;
        file = image;
        imagePath = image.path;
        update();
      }
    } catch (e) {
      showSnackBar("Gagal memilih gambar");
    }
  }

  void uploadImage() {
    if (file == null) {
      Get.offAll(() => TabBarScreen());
      return;
    }
    startLoading();
    UserService.shared.editProfile(
      profileImage: file,
      completion: (p0) {
        stopLoading();
        Get.offAll(() => TabBarScreen());
      },
    );
  }
}
