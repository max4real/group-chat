import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart';

Rx<String> socketId = ''.obs;

class ChatSocketServices {
  String socketEndPoint = "https://socket-test-gmic.onrender.com/chat";

  late Socket socket;

  Future<void> initSocket({Function? onFinished}) async {
    socket = io(
      socketEndPoint,
      OptionBuilder().setTransports(['websocket']).enableForceNew().build(),
    );
    socket.connect();
    socket.onConnectError((data) {
      print("CHAT SOCKET CONNECT ERROR");
    });
    socket.on('connect', (data) {
      print("CHAT SOCKET CONNECTED");
      if (onFinished != null) {
        onFinished();
      }
    });
    socket.on('disconnect', (data) => print("CHAT SOCKET DISCONNECTED"));
  }

  void disposeSocket() {
    socket.dispose();
    print("socket deipose");
  }
}
