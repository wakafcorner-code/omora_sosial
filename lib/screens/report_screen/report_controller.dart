import 'package:flutter/material.dart';
import 'package:untitled/common/api_service/post_service.dart';
import 'package:untitled/common/api_service/reel_service.dart';
import 'package:untitled/common/api_service/room_service.dart';
import 'package:untitled/common/api_service/user_service.dart';
import 'package:untitled/common/controller/base_controller.dart';
import 'package:untitled/common/managers/session_manager.dart';
import 'package:untitled/models/posts_model.dart';
import 'package:untitled/models/reel_model.dart';
import 'package:untitled/models/registration.dart';
import 'package:untitled/models/room_model.dart';
import 'package:untitled/models/setting_model.dart';

class ReportController extends BaseController {
  SettingCommon? selectedReason;
  TextEditingController reasonTextController = TextEditingController();

  List<SettingCommon> get reasons {
    var list = SessionManager.shared.getSettings()?.reportReasons ?? [];
    if (list.isEmpty) {
      return [
        SettingCommon(id: 1, title: "Spam / Konten Mengganggu"),
        SettingCommon(id: 2, title: "Pelecehan / Perundungan"),
        SettingCommon(id: 3, title: "Ujaran Kebencian / Diskriminasi"),
        SettingCommon(id: 4, title: "Konten Tidak Layak / Dewasa"),
        SettingCommon(id: 5, title: "Penipuan / Informasi Palsu"),
        SettingCommon(id: 6, title: "Lainnya"),
      ];
    }
    return list;
  }

  @override
  void onInit() {
    super.onInit();
    if (reasons.isNotEmpty) {
      selectedReason = reasons.first;
    }
  }

  void onReasonChange(SettingCommon? reason) {
    selectedReason = reason;
    update();
  }

  void submitReport(Room? room, Post? post, User? user, Reel? reel) {
    if (selectedReason == null && reasons.isNotEmpty) {
      selectedReason = reasons.first;
    }
    
    String descText = reasonTextController.text.trim();
    if (descText.isEmpty) {
      descText = selectedReason?.title ?? "Laporkan Konten";
    }

    FocusManager.instance.primaryFocus?.unfocus();
    startLoading();

    try {
      if (room != null) {
        RoomService.shared.reportRoom(room.id ?? 0, selectedReason?.title ?? '', descText);
      } else if (post != null) {
        PostService.shared.reportPost(post.id ?? 0, selectedReason?.title ?? '', descText);
      } else if (user != null) {
        UserService.shared.reportUser(user.id ?? 0, selectedReason?.title ?? '', descText);
      } else if (reel != null) {
        ReelService.shared.reportReel(reelId: reel.id ?? 0, reason: selectedReason?.title ?? '', desc: descText);
      }
    } finally {
      stopLoading();
    }
  }
}
