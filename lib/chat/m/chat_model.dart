class ChatModel {
  String deviceID;
  String message;
  DateTime dateTime;

  ChatModel({
    required this.deviceID,
    required this.message,
    required this.dateTime,
  });

  factory ChatModel.fromAPI({required Map<String, dynamic> data}) {
    return ChatModel(
      deviceID: data["deviceID"] ?? "",
      message: data["message"] ?? "",
      dateTime:
          DateTime.tryParse(data["dateTime"].toString()) ?? DateTime.now(),
    );
  }
}
