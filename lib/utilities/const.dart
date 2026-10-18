import 'package:flutter/material.dart';

const String appName = "Omora";
const String baseURL = "https://omora.wakafcorner.id/";
const String itemBaseURL = baseURL;
const String apiURL = "${baseURL}api/";
const String termsURL = "${baseURL}termsOfUse";
const String privacyURL = "${baseURL}privacyPolicy";
const String helpURL = "${baseURL}omora";
const String notificationTopic = "omora"; // Do not change it

const String revenuecatAppleApiKey = '';
const String revenuecatAndroidApiKey = '';

const String agoraAppId = 'agora_app_id';
const String agoraCustomerId = 'agora_customer_id';
const String agoraCustomerSecret = 'agora_customer_secret';

class Limits {
  static int username = 30;
  static int roomDescCount = 120;
  static int bioCount = 120;
  static int interestCount = 5;
  static int pagination = 20;
  static int storyDuration = 3;

  static int sightEngineCropSec = 5;

  static double imageSize = 720;
  static int quality = 50;
}

const List<String> storyQuickReplyEmojis = ['😂', '😮', '😍', '😢', '👏', '🔥'];
const List<int> secondsForMakingReel = [15, 30];

extension O on String {
  String addBaseURL() {
    String url = trim();
    if (url.isEmpty) return url;

    // Normalisasi URL yang tersimpan dengan domain lama / localhost dari Laravel backend
    if (url.contains('localhost') ||
        url.contains('yourDomain.com') ||
        url.contains('yourdomain.com') ||
        url.contains('retrytech.site') ||
        url.contains('127.0.0.1')) {
      int uploadIndex = url.indexOf('/uploads');
      if (uploadIndex != -1) {
        url = url.substring(uploadIndex);
      } else {
        int storageIndex = url.indexOf('/storage');
        if (storageIndex != -1) {
          url = url.substring(storageIndex);
        }
      }
    }

    // Paksa HTTP menjadi HTTPS untuk domain omora
    if (url.startsWith('http://omora.wakafcorner.id')) {
      url = url.replaceFirst('http://', 'https://');
    }

    if (url.startsWith('http://') || url.startsWith('https://')) {
      return url;
    }

    if (url.startsWith('/')) {
      return itemBaseURL + url.substring(1);
    }
    return itemBaseURL + url;
  }
}

// Colors - Omora Official Play Store Cosmic Neon Palette (Matching ic_launcher-playstore.png)
const cLogoPink = Color(0xFFFE2EE2); // Neon Magenta / Pink
const cLogoCyan = Color(0xFF00D2FF); // Electric Cyan
const cLogoPurple = Color(0xFF8B5CF6); // Vivid Violet
const cPrimary = Color(0xFFFE2EE2); // Primary brand accent (Neon Pink from logo)
const cPrimaryDark = Color(0xFFD919BE); // Deep Magenta
const cPulsing = Color(0xFFF472B6);
const cHashtagColor = Color(0xFF8B5CF6);
const cSecondary = Color(0xFF00D2FF); // Electric Cyan Accent
const cAccentPink = Color(0xFFFE2EE2); // Neon Pink
const cAccentOrange = Color(0xFFF97316); // Bright Orange
const cAccentPurple = Color(0xFF8B5CF6); // Vivid Violet
const cAccentCyan = Color(0xFF00D2FF); // Electric Cyan
const cAccentYellow = Color(0xFFFBBF24); // Warm Amber

const cWhite = Colors.white;
const cBlack = Color(0xFF0A071B); // Cosmic Obsidian Deep Slate
const cBlackSheetBG = Color(0xFF140F2D); // Deep Cosmic Sheet
const cMainText = Color(0xFF0A071B);
const cLightText = Color(0xFF64748B);
const cLightIcon = Color(0xFF94A3B8);
const cDarkText = Color(0xFF334155);
const cLightBg = Color(0xFFF8FAFC);
const cDarkBG = Color(0xFF070514); // Exact Play Store Icon Cosmic Obsidian
const cBG = Color(0xFFF1F5F9);
const cGreen = Color(0xFF10B981);
const cDarkGreen = Color(0xFF064E3B);
const cBlueTick = Color(0xFF00D2FF);
const cRed = Color(0xFFEF4444);

// Modern Gradient Palettes - Extracted from Official Omora Play Store Logo
const LinearGradient cGradientPrimary = LinearGradient(
  colors: [Color(0xFF00D2FF), Color(0xFF8B5CF6), Color(0xFFFE2EE2)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

const LinearGradient cGradientLogo = LinearGradient(
  colors: [Color(0xFF00D2FF), Color(0xFFFE2EE2)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

const LinearGradient cGradientStory = LinearGradient(
  colors: [
    Color(0xFFF59E0B),
    Color(0xFFEC4899),
    Color(0xFF8B5CF6),
    Color(0xFF06B6D4),
  ],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

const LinearGradient cGradientStorySeen = LinearGradient(
  colors: [Color(0xFFE2E8F0), Color(0xFFCBD5E1)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

const LinearGradient cGradientReels = LinearGradient(
  colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

const LinearGradient cGradientSunset = LinearGradient(
  colors: [Color(0xFFF97316), Color(0xFFEF4444)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

const LinearGradient cGradientSky = LinearGradient(
  colors: [Color(0xFF0EA5E9), Color(0xFF6366F1)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

const LinearGradient cGradientPurple = LinearGradient(
  colors: [Color(0xFF9333EA), Color(0xFFC084FC)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

const List<LinearGradient> cAvatarGradients = [
  LinearGradient(colors: [Color(0xFF10B981), Color(0xFF06B6D4)], begin: Alignment.topLeft, end: Alignment.bottomRight),
  LinearGradient(colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)], begin: Alignment.topLeft, end: Alignment.bottomRight),
  LinearGradient(colors: [Color(0xFFEC4899), Color(0xFFF43F5E)], begin: Alignment.topLeft, end: Alignment.bottomRight),
  LinearGradient(colors: [Color(0xFFF97316), Color(0xFFF59E0B)], begin: Alignment.topLeft, end: Alignment.bottomRight),
  LinearGradient(colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)], begin: Alignment.topLeft, end: Alignment.bottomRight),
  LinearGradient(colors: [Color(0xFF0EA5E9), Color(0xFF6366F1)], begin: Alignment.topLeft, end: Alignment.bottomRight),
  LinearGradient(colors: [Color(0xFF14B8A6), Color(0xFF3B82F6)], begin: Alignment.topLeft, end: Alignment.bottomRight),
  LinearGradient(colors: [Color(0xFFF43F5E), Color(0xFFFB923C)], begin: Alignment.topLeft, end: Alignment.bottomRight),
];

// Vibrant Color Pairs for Chips, Badges, and Interest Tags
class VibrantColorPair {
  final Color bg;
  final Color text;
  final LinearGradient gradient;

  const VibrantColorPair({required this.bg, required this.text, required this.gradient});
}

const List<VibrantColorPair> cVibrantColorPairs = [
  VibrantColorPair(
    bg: Color(0xFFECFDF5),
    text: Color(0xFF059669),
    gradient: cGradientPrimary,
  ),
  VibrantColorPair(
    bg: Color(0xFFEEF2FF),
    text: Color(0xFF4F46E5),
    gradient: cGradientSky,
  ),
  VibrantColorPair(
    bg: Color(0xFFFDF2F8),
    text: Color(0xFFDB2777),
    gradient: cGradientReels,
  ),
  VibrantColorPair(
    bg: Color(0xFFFFF7ED),
    text: Color(0xFFEA580C),
    gradient: cGradientSunset,
  ),
  VibrantColorPair(
    bg: Color(0xFFF0FDF4),
    text: Color(0xFF16A34A),
    gradient: cGradientPrimary,
  ),
  VibrantColorPair(
    bg: Color(0xFFFAF5FF),
    text: Color(0xFF9333EA),
    gradient: cGradientPurple,
  ),
  VibrantColorPair(
    bg: Color(0xFFF0F9FF),
    text: Color(0xFF0284C7),
    gradient: cGradientSky,
  ),
];

VibrantColorPair getVibrantColorPair(String seed) {
  if (seed.isEmpty) return cVibrantColorPairs[0];
  final int hash = seed.codeUnits.fold(0, (prev, curr) => prev + curr);
  return cVibrantColorPairs[hash % cVibrantColorPairs.length];
}

LinearGradient getAvatarGradient(String seed) {
  if (seed.isEmpty) return cAvatarGradients[0];
  final int hash = seed.codeUnits.fold(0, (prev, curr) => prev + curr);
  return cAvatarGradients[hash % cAvatarGradients.length];
}

const cAudioSpaceBG = Color(0xFF1E293B);
const cAudioSpaceDarkBG = Color(0xFF0F172A);
const cAudioSpaceLightBG = Color(0xFF334155);
const cAudioSpaceText = Color(0xFFE2E8F0);

const refreshIndicatorColor = cWhite;
const refreshIndicatorBgColor = cPrimary;

// Corner Radius-Smoothing
const cornerSmoothing = 1.0;
