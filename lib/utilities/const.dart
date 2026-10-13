import 'package:flutter/material.dart';

const String appName = "Omora";
const String baseURL = "https://omora.wakafcorner.id/";
const String itemBaseURL = baseURL;
const String apiURL = "${baseURL}api/";
const String termsURL = "${baseURL}termsOfUse";
const String privacyURL = "${baseURL}privacyPolicy";
const String helpURL = "http://www.yourHelpURL.com";
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

// Colors - Omora Vibrant Palette
const cPrimary = Color(0xFF10B981); // Vibrant Emerald Green
const cPulsing = Color(0xFF6EE7B7);
const cHashtagColor = Color(0xFF059669);
const cSecondary = Color(0xFF6366F1); // Indigo Accent
const cAccentPink = Color(0xFFEC4899); // Pink Neon Accent
const cAccentOrange = Color(0xFFF97316); // Bright Orange Accent
const cAccentPurple = Color(0xFF8B5CF6); // Purple Accent

const cWhite = Colors.white;
const cBlack = Color(0xFF0F172A); // Deep Slate
const cBlackSheetBG = Color(0xFF1E293B);
const cMainText = Color(0xFF0F172A);
const cLightText = Color(0xFF64748B);
const cLightIcon = Color(0xFF94A3B8);
const cDarkText = Color(0xFF334155);
const cLightBg = Color(0xFFF8FAFC);
const cDarkBG = Color(0xFF0F172A);
const cBG = Color(0xFFF1F5F9);
const cGreen = Color(0xFF10B981);
const cDarkGreen = Color(0xFF064E3B);
const cBlueTick = Color(0xFF0EA5E9);
const cRed = Color(0xFFEF4444);

const cAudioSpaceBG = Color(0xFF1E293B);
const cAudioSpaceDarkBG = Color(0xFF0F172A);
const cAudioSpaceLightBG = Color(0xFF334155);
const cAudioSpaceText = Color(0xFFE2E8F0);

const refreshIndicatorColor = cWhite;
const refreshIndicatorBgColor = cPrimary;

// Corner Radius-Smoothing
const cornerSmoothing = 1.0;
