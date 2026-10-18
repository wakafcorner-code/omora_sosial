import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/common/extensions/image_extension.dart';
import 'package:untitled/screens/splash_screen/splash_controller.dart';
import 'package:untitled/utilities/const.dart';


class SplashScreenView extends StatelessWidget {
  const SplashScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _ = Get.put(SplashController());
    return Scaffold(
      backgroundColor: cDarkBG,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Ambient Cosmic Radial Glow (Pink & Cyan)
          Positioned(
            top: Get.height * 0.26,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      cLogoPink.withValues(alpha: 0.25),
                      cLogoCyan.withValues(alpha: 0.12),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Center Brand Content
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Glowing Emblem Container
                Container(
                  width: 140,
                  height: 140,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: cLogoPink.withValues(alpha: 0.35),
                        blurRadius: 32,
                        spreadRadius: 2,
                        offset: const Offset(0, 6),
                      ),
                      BoxShadow(
                        color: cLogoCyan.withValues(alpha: 0.2),
                        blurRadius: 24,
                        spreadRadius: 1,
                        offset: const Offset(-4, -4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(70),
                    child: Image.asset(
                      MyImages.omoraEmblem,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Authentic 3D Gradient Wordmark
                Image.asset(
                  MyImages.omoraWordmark,
                  height: 38,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 12),
                Text(
                  "Connect • Share • Play",
                  style: TextStyle(
                    fontSize: 13,
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2.5,
                    color: Colors.white.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          // Bottom subtle brand indicator
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: SizedBox(
                width: 36,
                height: 3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: const LinearProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(cLogoPink),
                    backgroundColor: Color(0xFF1E1438),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
