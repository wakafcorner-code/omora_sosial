import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/common/extensions/font_extension.dart';
import 'package:untitled/common/extensions/image_extension.dart';
import 'package:untitled/common/widgets/no_data_view.dart';
import 'package:untitled/localization/languages.dart';
import 'package:untitled/models/chat.dart';
import 'package:untitled/screens/chats_screen/chat_view/chat_card.dart';
import 'package:untitled/screens/chats_screen/chats_screen_controller.dart';
import 'package:untitled/screens/extra_views/logo_tag.dart';
import 'package:untitled/utilities/const.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ChatsScreensController controller = Get.find<ChatsScreensController>();
    return GetBuilder<ChatsScreensController>(
        init: controller,
        builder: (controller) {
          return Column(
            children: [
              top(controller),
              Expanded(
                child: Column(
                  children: [
                    const SizedBox(height: 15),
                    segmentController(controller),
                    const SizedBox(height: 15),
                    Expanded(
                      child: PageView(
                        controller: controller.controller,
                        onPageChanged: controller.onChangePage,
                        children: [
                          chatList(controller, 1),
                          chatList(controller, 2),
                          chatList(controller, 0),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        });
  }

  Widget chatList(ChatsScreensController controller, int type) {
    List<ChatUserRoom> chats = (type == 2) ? controller.filterRoomChats : controller.filterChats.where((element) => element.type == type).toList();

    return NoDataView(
      showShow: chats.isEmpty,
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 0),
        itemCount: chats.length,
        itemBuilder: (context, index) {
          var chatUserRoom = chats[index];
          return ChatCard(
            chatUserRoom: chatUserRoom,
            controller: controller,
          );
        },
      ),
    );
  }

  Widget segmentController(ChatsScreensController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          _segmentItem(LKeys.chats.tr, 0, controller, cPrimary),
          const SizedBox(width: 4),
          _segmentItem(LKeys.rooms.tr, 1, controller, cSecondary),
          const SizedBox(width: 4),
          _segmentItem(LKeys.requests.tr, 2, controller, cAccentPink),
        ],
      ),
    );
  }

  Widget _segmentItem(String text, int index, ChatsScreensController controller, Color activeColor) {
    final bool isSelected = controller.selectedPage == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.onChangeSegment(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            color: isSelected ? cWhite : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: const Color(0xFF0F172A).withValues(alpha: 0.06),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: isSelected
                ? MyTextStyle.gilroyBold(size: 13, color: activeColor)
                : MyTextStyle.gilroyMedium(size: 13, color: const Color(0xFF64748B)),
          ),
        ),
      ),
    );
  }

  Widget top(ChatsScreensController controller) {
    return Container(
      decoration: const BoxDecoration(
        color: cWhite,
        border: Border(
          bottom: BorderSide(color: Color(0xFFF1F5F9), width: 1),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            controller.isSearching
                ? Expanded(
                    child: Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
                      ),
                      alignment: Alignment.center,
                      child: TextField(
                        onChanged: controller.onChange,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          hintText: LKeys.searchHere.tr,
                          hintStyle: MyTextStyle.gilroyRegular(color: const Color(0xFF94A3B8)),
                          border: InputBorder.none,
                          counterText: '',
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        cursorColor: cPrimary,
                        style: MyTextStyle.gilroyRegular(color: cMainText),
                        controller: controller.textEditingController,
                        autofocus: true,
                      ),
                    ),
                  )
                : const Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: LogoTag(width: 95),
                    ),
                  ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () {
                controller.textEditingController.text = "";
                controller.isSearching = !controller.isSearching;
                controller.update();
                controller.onChange('');
              },
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: controller.isSearching ? const Color(0xFFF1F5F9) : const Color(0xFFECFDF5),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Image.asset(
                  controller.isSearching ? MyImages.close : MyImages.search,
                  width: 19,
                  height: 19,
                  color: controller.isSearching ? cLightText : cPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatSheetButton extends StatelessWidget {
  final String title;
  final Function() onTap;

  const ChatSheetButton({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(alignment: Alignment.center, width: double.infinity, color: cBlack, child: Text(title, style: MyTextStyle.gilroySemiBold(color: cWhite, size: 18))),
      onTap: () {
        Get.back();
        onTap();
      },
    );
  }
}
