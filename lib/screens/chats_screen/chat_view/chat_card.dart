import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:untitled/common/extensions/date_time_extension.dart';
import 'package:untitled/common/extensions/font_extension.dart';
import 'package:untitled/common/extensions/int_extension.dart';
import 'package:untitled/common/managers/context_menu_widget.dart';
import 'package:untitled/common/widgets/my_cached_image.dart';
import 'package:untitled/localization/languages.dart';
import 'package:untitled/models/chat.dart';
import 'package:untitled/screens/chats_screen/chats_screen_controller.dart';
import 'package:untitled/screens/chats_screen/chatting_screen/chatting_view.dart';
import 'package:untitled/screens/extra_views/back_button.dart';
import 'package:untitled/utilities/const.dart';

class ChatCard extends StatelessWidget {
  final ChatUserRoom chatUserRoom;
  final ChatsScreensController controller;

  const ChatCard({Key? key, required this.chatUserRoom, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 14),
      child: ContextMenuWidget(
        child: GestureDetector(
          onTap: () {
            Get.to(() => ChattingView(chatUserRoom: chatUserRoom));
          },
          child: Container(
            decoration: BoxDecoration(
              color: cWhite,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFF1F5F9), width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0F172A).withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(1.5),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: cGradientPrimary,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(1.0),
                    decoration: const BoxDecoration(
                      color: cWhite,
                      shape: BoxShape.circle,
                    ),
                    child: MyCachedProfileImage(
                      imageUrl: chatUserRoom.profileImage,
                      fullName: chatUserRoom.title,
                      width: 48,
                      height: 48,
                      cornerRadius: 48,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              chatUserRoom.title ?? '',
                              style: MyTextStyle.gilroyBold(size: 15, color: cBlack),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const VerifyIcon()
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        chatUserRoom.lastMsg ?? '',
                        style: MyTextStyle.gilroyRegular(size: 13, color: cLightText),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      chatUserRoom.time?.timeAgo() ?? '',
                      style: MyTextStyle.gilroyRegular(size: 11, color: const Color(0xFF94A3B8)),
                    ),
                    const SizedBox(height: 4),
                    if (chatUserRoom.newMsgCount != 0 && chatUserRoom.newMsgCount != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          gradient: cGradientSunset,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: cRed.withValues(alpha: 0.35),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          chatUserRoom.newMsgCount == -1 ? "" : chatUserRoom.newMsgCount!.makeToString(),
                          style: MyTextStyle.gilroyBold(size: 11, color: cWhite),
                        ),
                      )
                    else
                      const SizedBox(height: 18),
                  ],
                )
              ],
            ),
          ),
        ),
        menuProvider: (request) {
          return Menu(children: [
            MenuAction(
              title: chatUserRoom.newMsgCount == 0 ? LKeys.markAsUnread.tr : LKeys.markAsRead.tr,
              callback: () => controller.markToggle(chatUserRoom),
            ),
            MenuAction(
              title: LKeys.clearChat.tr,
              callback: () => controller.clearChat(chatUserRoom),
            ),
            MenuAction(
              title: LKeys.deleteChat.tr,
              callback: () => controller.deleteChat(chatUserRoom),
            ),
          ]);
        },
      ),
    );
  }
}
