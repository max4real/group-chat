import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:group_chat/chat/c_dm.dart';
import 'package:group_chat/shared/chat_socket_service.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DataController extends GetxController {
  ChatSocketServices socketService = ChatSocketServices();

  Future<dynamic> emitmessage(String message, String deviceID) async {
    final completer = Completer<dynamic>();

    socketService.socket.emitWithAck(
      "message",
      {
        'data': {
          'deviceID': deviceID,
          'message': message,
          'dateTime': DateTime.now().toString(),
        },
      },
      ack: (data) {
        completer.complete(data);
      },
    );

    return completer.future;
  }

  void listenMessage() {
    socketService.socket.off("message");
    socketService.socket.on("message", (data) async {
      // print("Listen message -> $data");
      // print(data.toString());
      DMController dmController = Get.find();
      dmController.getText(data);
    });
  }

  Future<String?> getDeviceId() async {
    final deviceInfoPlugin = DeviceInfoPlugin();

    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
        return androidInfo.id; // Returns a unique hardware ID for Android
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
        return iosInfo.identifierForVendor; // Returns a unique ID for iOS
      }
    } catch (e) {
      print("Error getting device ID: $e");
      return null;
    }

    return null; // Default case if the platform is unsupported
  }
}

String formatDateTime(DateTime dateTime) {
  final formattedDate = DateFormat('h:mm a').format(dateTime); //dd-MM-yy
  return formattedDate;
}

// void emitmessage(String message) {
  //   socketService.socket.emitWithAck(
  //     "message",
  //     {
  //       'data': {
  //         'message': message,
  //         'dateTime': DateTime.now().toString(),
  //       },
  //     },
  //     ack: (data) async {
  //       print(data)
  //     },
  //   );
  // }