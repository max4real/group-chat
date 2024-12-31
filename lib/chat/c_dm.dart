import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:group_chat/chat/m/chat_model.dart';
import 'package:group_chat/shared/data_controller.dart';

class DMController extends GetxController {
  ValueNotifier<List<ChatModel>> chatList = ValueNotifier([]);

  DataController dataController = Get.find();
  TextEditingController txtText = TextEditingController();
  ScrollController scrollController = ScrollController();
  String? deviceId;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    initLoad();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    dataController.socketService.disposeSocket();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    dataController.socketService.disposeSocket();
  }

  void initLoad() async {
    deviceId = await dataController.getDeviceId();

    dataController.socketService.initSocket(
      onFinished: () {
        dataController.listenMessage();
      },
    );
  }

  void sendText() async {
    if (txtText.text.isNotEmpty) {
      dynamic ackResponse = await dataController.emitmessage(
        txtText.text,
        deviceId == null ? "ID- null" : deviceId!,
      );
      if (ackResponse != null) {
        print("Ack Response: $ackResponse");
        ChatModel chatModel = ChatModel.fromAPI(data: ackResponse["data"]);
        List<ChatModel> temp = [...chatList.value];
        temp.add(chatModel);
        // temp.insert(0, chatModel);
        chatList.value = temp;
        txtText.clear();
        scrollToBottom();
      }
    }
  }

  void getText(dynamic data) {
    print("Listen From DM controller");
    print(data);

    // Parse if data is a JSON string
    if (data is String) {
      try {
        data = jsonDecode(data);
      } catch (e) {
        print("Failed to parse JSON: $e");
        return;
      }
    }

    // Validate structure
    if (data != null &&
        data is Map<String, dynamic> &&
        data.containsKey('data')) {
      final innerData = data['data'];
      if (innerData != null && innerData is Map<String, dynamic>) {
        ChatModel chatModel = ChatModel.fromAPI(data: innerData);
        List<ChatModel> temp = [...chatList.value];
        temp.add(chatModel);
        // temp.insert(0, chatModel);
        chatList.value = temp;
        scrollToBottom();
      } else {
        print("Inner data is not a valid Map");
      }
    } else {
      print("Invalid data format");
    }
  }

  bool checkDeviceID(String iD) {
    if (iD == deviceId) {
      return true;
    } else {
      return false;
    }
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.minScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
}
