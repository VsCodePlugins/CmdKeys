import 'dart:convert';

class ModelSessionDebug {
  String sessionID;
  int? index;
  String sessionName;
  String sessionType;
  String eventName;
  int sessionUnixTimestamp;

  ModelSessionDebug({
    required this.sessionID,
    required this.index,
    required this.sessionName,
    required this.sessionType,
    required this.eventName,
    required this.sessionUnixTimestamp,
  });

  String toJson() {
    return jsonEncode({
      'sessionID': sessionID,
      'index': index,
      'sessionName': sessionName,
      'sessionType': sessionType,
      'eventName': eventName,
      'sessionUnixTimestamp': sessionUnixTimestamp,
    });
  }

  static ModelSessionDebug fromJson(String json) {
    final Map<String, dynamic> data = jsonDecode(json);
    return ModelSessionDebug(
        sessionID: data["sessionID"],
        index: data["index"],
        sessionName: data["sessionName"],
        sessionType: data["sessionType"],
        eventName: data["eventName"],
        sessionUnixTimestamp: data["sessionUnixTimestamp"]);

  }
}
