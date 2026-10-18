import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:untitled/common/api_service/notification_service.dart';
import 'package:untitled/common/api_service/user_service.dart';
import 'package:untitled/common/controller/base_controller.dart';
import 'package:untitled/common/managers/firebase_notification_manager.dart';
import 'package:untitled/common/managers/logger.dart';
import 'package:untitled/common/managers/session_manager.dart';
import 'package:untitled/common/managers/subscription_manager.dart';
import 'package:untitled/screens/block_by_admin_screen/block_by_admin_screen.dart';
import 'package:untitled/screens/interests_screen/interests_screen.dart';
import 'package:untitled/screens/login_screen/sign_in_with_email_screen.dart';
import 'package:untitled/screens/profile_picture_screen/profile_picture_screen.dart';
import 'package:untitled/screens/tabbar/tabbar_screen.dart';
import 'package:untitled/screens/username_screen/username_screen.dart';
import 'package:untitled/utilities/const.dart';

class LoginController extends BaseController {
  @override
  void onReady() {
    Loggers.info("TRYING NOTIFICATION");
    FirebaseNotificationManager.shared.init();

    super.onReady();
  }

  void emailLogin() {
    Get.bottomSheet(SignInWithEmailScreen(
      onSubmit: (fullName, identity) {
        registerUser(identity: identity, loginType: LoginType.email, fullName: fullName);
      },
    ), isScrollControlled: true, ignoreSafeArea: false);
  }

  void googleLogin() async {
    try {
      const String webClientId = '686870784106-0m7ba4r22c38lkt06i91o09qkr30b5pg.apps.googleusercontent.com';
      final GoogleSignIn googleSignIn = GoogleSignIn(
        serverClientId: webClientId,
        scopes: ['email'],
      );

      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        registerUser(
          fullName: googleSignInAccount.displayName,
          identity: googleSignInAccount.email,
          loginType: LoginType.google,
        );
      }
    } catch (exception) {
      stopLoading();
      Loggers.error("Google Sign In error: ${exception.toString()}");
      Get.snackbar(
        "Google Sign In Error",
        "Gagal login Google: ${exception.toString()}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void appleLogin() async {
    try {
      AuthorizationCredentialAppleID value = await SignInWithApple.getAppleIDCredential(scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName]);
      registerUser(fullName: '${value.givenName ?? 'John'} ${value.familyName ?? 'Deo'}', identity: value.userIdentifier ?? '', loginType: LoginType.apple);
    } on SignInWithAppleException catch (exception) {
      log("Something wrong ${exception.toString()}");
    }
  }

  void registerUser({String? fullName, required String identity, required LoginType loginType}) {
    startLoading();
    FirebaseNotificationManager.shared.getNotificationToken((token) {
      UserService.shared.registration(
          name: fullName,
          identity: identity,
          deviceToken: token,
          loginType: loginType,
          completion: (p0) {
            SessionManager.shared.setLogin(true);

            Widget w = InterestScreen();
            var user = p0.data;
            if (isPurchaseConfig) {
              Purchases.logIn('${user?.id ?? 0}');
            }
            if (user?.isPushNotifications == 1) {
              FirebaseNotificationManager.shared.subscribeToTopic(notificationTopic);
              NotificationService.shared.subscribeToAllMyRoom();
            }
            if (user?.isBlock == 1) {
              w = const BlockedByAdminScreen();
            } else if ((user?.interestIds == null || user?.interestIds?.trim().isEmpty == true) &&
                (user?.username == null || user?.username?.trim().isEmpty == true)) {
              w = InterestScreen();
            } else if (user?.username == null || user?.username?.trim().isEmpty == true) {
              w = const UserNameScreen();
            } else if (user?.profile == null || user?.profile?.trim().isEmpty == true) {
              w = const ProfilePictureScreen();
            } else {
              w = TabBarScreen();
            }
            Get.offAll(() => w);
            stopLoading();
          });
    });
  }
}

enum LoginType {
  google(0),
  apple(1),
  email(2);

  const LoginType(this.value);

  final int value;
}
