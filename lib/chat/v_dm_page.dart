import 'package:flutter/material.dart';
import 'package:group_chat/chat/c_dm.dart';
import 'package:get/get.dart';
import 'package:group_chat/chat/m/chat_model.dart';
import 'package:group_chat/shared/data_controller.dart';

class DMPage extends StatelessWidget {
  const DMPage({super.key});

  @override
  Widget build(BuildContext context) {
    DMController controller = Get.put(DMController());
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Group Chat",
          style: const TextStyle(fontSize: 17, color: Colors.white),
        ),
        backgroundColor: Colors.blueGrey,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: ValueListenableBuilder(
                  valueListenable: controller.chatList,
                  builder: (context, chatList, child) {
                    List<ChatModel> reverseList = chatList.reversed.toList();
                    return ListView.builder(
                      itemCount: reverseList.length,
                      controller: controller.scrollController,
                      reverse: true,
                      itemBuilder: (context, index) {
                        MainAxisAlignment alignment = MainAxisAlignment.end;
                        Color color = Colors.black;
                        bool xTime = false;

                        if (controller
                            .checkDeviceID(reverseList[index].deviceID)) {
                          alignment = MainAxisAlignment.end;
                          color = Colors.blueGrey;
                          xTime = true;
                        } else {
                          alignment = MainAxisAlignment.start;
                          color = Colors.grey;
                          xTime = false;
                        }
                        final each = reverseList[index];
                        return Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Row(
                            mainAxisAlignment: alignment,
                            spacing: 10,
                            children: [
                              if (xTime)
                                Text(
                                  formatDateTime(each.dateTime),
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    color: Colors.black,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              Flexible(
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: color,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    each.message,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                              if (!xTime)
                                Text(
                                  formatDateTime(each.dateTime),
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    color: Colors.black,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.txtText,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      maxLines: 3,
                      minLines: 1,
                      onTapOutside: (event) {},
                      decoration: InputDecoration(
                        hintText: "Type a message",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 15.0),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.send,
                      color: Colors.blueGrey,
                    ),
                    onPressed: () {
                      controller.sendText();
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
