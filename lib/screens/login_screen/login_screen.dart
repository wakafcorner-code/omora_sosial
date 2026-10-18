import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/common/extensions/font_extension.dart';
import 'package:untitled/common/extensions/image_extension.dart';
import 'package:untitled/common/managers/navigation.dart';
import 'package:untitled/common/managers/session_manager.dart';
import 'package:untitled/localization/languages.dart';
import 'package:untitled/screens/extra_views/top_bar.dart';
import 'package:untitled/screens/languages_screen/languages_screen.dart';
import 'package:untitled/screens/login_screen/login_button.dart';
import 'package:untitled/screens/login_screen/login_controller.dart';
import 'package:untitled/utilities/const.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(LoginController());
    return Scaffold(
      backgroundColor: cWhite,
      body: Stack(
        children: [
          // Ambient Colorful Background Glows
          Positioned(
            top: -60,
            right: -60,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    cPrimary.withValues(alpha: 0.15),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 60,
            left: -80,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    cSecondary.withValues(alpha: 0.12),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Spacer(),
                    // Modern Hero Brand Section
                    Container(
                      width: 92,
                      height: 92,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: cLogoPink.withValues(alpha: 0.35),
                            blurRadius: 28,
                            spreadRadius: 2,
                            offset: const Offset(0, 6),
                          ),
                          BoxShadow(
                            color: cLogoCyan.withValues(alpha: 0.2),
                            blurRadius: 20,
                            spreadRadius: 1,
                            offset: const Offset(-3, -3),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(46),
                        child: Image.asset(
                          MyImages.omoraEmblem,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Image.asset(
                      MyImages.omoraWordmark,
                      height: 32,
                      fit: BoxFit.contain,
                    ),
                    const Spacer(),
                    const TopBarForLogin(
                      titleStart: LKeys.signInTo,
                      titleEnd: LKeys.continue1,
                      alignment: MainAxisAlignment.center,
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Text(
                        LKeys.signInDesc.tr,
                        textAlign: TextAlign.center,
                        style: MyTextStyle.gilroyRegular(color: cLightText, size: 15),
                      ),
                    ),
                    const Spacer(),
                    Column(
                      children: [
                        LoginButton(
                          text: LKeys.signInWithGoogle,
                          assetName: MyImages.google,
                          onTap: () {
                            controller.googleLogin();
                          },
                        ),
                        LoginButton(
                          text: LKeys.signInWithEmail,
                          assetName: MyImages.email,
                          onTap: () {
                            controller.emailLogin();
                          },
                        ),
                        if (GetPlatform.isIOS)
                          LoginButton(
                            text: LKeys.signInWithApple,
                            assetName: MyImages.apple,
                            onTap: () {
                              controller.appleLogin();
                            },
                          )
                      ],
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        LKeys.bySelectingAgree.tr,
                        textAlign: TextAlign.center,
                        style: MyTextStyle.gilroyLight(color: cLightText, size: 13),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          LKeys.iAgreeTo.tr,
                          style: MyTextStyle.gilroyLight(color: cLightText, size: 13),
                        ),
                        const SizedBox(width: 5),
                        GestureDetector(
                          onTap: () {
                            Navigate.openURLSheet(title: LKeys.termsOfUse.tr, url: termsURL);
                          },
                          child: Text(
                            LKeys.termsOfUse.tr,
                            style: MyTextStyle.gilroyBold(color: cPrimary, size: 13),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          LKeys.and.tr,
                          style: MyTextStyle.gilroyLight(color: cLightText, size: 13),
                        ),
                        const SizedBox(width: 5),
                        GestureDetector(
                          onTap: () {
                            Navigate.openURLSheet(title: LKeys.privacyPolicy.tr, url: privacyURL);
                          },
                          child: Text(
                            LKeys.privacyPolicy.tr,
                            style: MyTextStyle.gilroyBold(color: cPrimary, size: 13),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                  ],
                ),
                Positioned(
                  top: 10,
                  right: 15,
                  child: GestureDetector(
                    onTap: () {
                      Get.to(() => const LanguagesScreen());
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(
                        color: cWhite,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF0F172A).withValues(alpha: 0.04),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.language, size: 17, color: cPrimary),
                          const SizedBox(width: 6),
                          Text(
                            SessionManager.shared.getLang().displayName,
                            style: MyTextStyle.gilroyBold(size: 13, color: cMainText),
                          ),
                          const Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: cLightText),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
