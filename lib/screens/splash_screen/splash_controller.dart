import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:untitled/common/api_service/common_service.dart';
import 'package:untitled/common/api_service/user_service.dart';
import 'package:untitled/common/controller/base_controller.dart';
import 'package:untitled/common/managers/session_manager.dart';
import 'package:untitled/screens/block_by_admin_screen/block_by_admin_screen.dart';
import 'package:untitled/screens/interests_screen/interests_screen.dart';
import 'package:untitled/screens/maintenance_screen/maintenance_screen.dart';
import 'package:untitled/screens/on_boarding_screen/on_boarding_screen.dart';
import 'package:untitled/screens/profile_picture_screen/profile_picture_screen.dart';
import 'package:untitled/screens/tabbar/tabbar_screen.dart';
import 'package:untitled/screens/update_screen/update_app_screen.dart';
import 'package:untitled/screens/username_screen/username_screen.dart';

class SplashController extends BaseController {
  bool _hasNavigated = false;

  @override
  void onInit() {
    super.onInit();
    fetchSettings();
  }

  void _navigateToNextScreen() async {
    if (_hasNavigated) return;
    _hasNavigated = true;
    try {
      var view = await gotoView();
      Get.offAll(() => view);
    } catch (e) {
      if (SessionManager.shared.isLogin()) {
        Get.offAll(() => TabBarScreen());
      } else {
        Get.offAll(() => const OnBoardingScreen());
      }
    }
  }

  void fetchUser(Function() completion) {
    if (SessionManager.shared.getUser()?.id != null) {
      UserService.shared.fetchMyProfile(
        userID: SessionManager.shared.getUser()?.id ?? 0,
        completion: (user) {
          if (user != null) {
            SessionManager.shared.setUser(user);
          }
          completion();
        },
      );
    } else {
      completion();
    }
  }

  void fetchSettings() {
    // Safety fallback: ensure splash screen doesn't hang forever
    Timer(const Duration(seconds: 3), () {
      _navigateToNextScreen();
    });

    try {
      fetchUser(() {
        CommonService.shared.fetchGlobalSettings((p0) {
          _navigateToNextScreen();
        });
      });
    } catch (e) {
      _navigateToNextScreen();
    }
  }

  Future<Widget> gotoView() async {
    try {
      final settings = SessionManager.shared.getSettings();
      if (settings?.isMaintenanceMode == 1) {
        return MaintenanceScreen();
      }

      if (settings?.isForceAppUpdate == 1) {
        try {
          var packageInfo = await PackageInfo.fromPlatform();
          String version = packageInfo.version;

          if ((Platform.isAndroid && version != settings?.androidAppVersion) || (Platform.isIOS && version != settings?.iosAppVersion)) {
            return UpdateAppScreen();
          }
        } catch (_) {}
      }

      if (SessionManager.shared.isLogin()) {
        var user = SessionManager.shared.getUser();
        if (user?.isBlock == 1) {
          return const BlockedByAdminScreen();
        } else if ((user?.interestIds == null || user?.interestIds?.trim().isEmpty == true) &&
            (user?.username == null || user?.username?.trim().isEmpty == true)) {
          return InterestScreen();
        } else if (user?.username == null || user?.username?.trim().isEmpty == true) {
          return const UserNameScreen();
        } else if (user?.profile == null || user?.profile?.trim().isEmpty == true) {
          return const ProfilePictureScreen();
        } else {
          return TabBarScreen();
        }
      }
      return const OnBoardingScreen();
    } catch (e) {
      return const OnBoardingScreen();
    }
  }
}
