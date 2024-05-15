import 'package:vsckeyboard/features/2_keyboard_setting/models/session_debug_model.dart';

mixin class SessionDebug {

  List<String> eventList = [
    "syncSessionsDebug",
    "onDidChangeActiveDebugSession",
    "onDidReceiveDebugSessionCustomEvent",
    "onDidTerminateDebugSession",
    "onDidStartDebugSession"
  ];
  Map<String, ModelSessionDebug> mapSessionDebug = {};
  List<ModelSessionDebug> listSessionModel = [];
  List<String> listSessionName = [];

   void getModelSessionDebug(String jsonData) {
    
    for (String eventName in eventList) {

      if (!jsonData.contains(eventName)) {
        continue;
      }
      
      ModelSessionDebug modelSD = ModelSessionDebug.fromJson(jsonData);

      if (eventName == "onDidTerminateDebugSession") {
        mapSessionDebug.remove(modelSD.sessionID);
        updateListDebugSessions();
        break;
      }
  
      // Add new Session
      if (mapSessionDebug[modelSD.sessionID] == null) {
        mapSessionDebug[modelSD.sessionID] = modelSD;
        updateListDebugSessions();
        break;
      }
        mapSessionDebug[modelSD.sessionID]?.sessionUnixTimestamp =
            modelSD.sessionUnixTimestamp;
        updateListDebugSessions();
        break;

    }
  }

  List<ModelSessionDebug> updateListDebugSessions() {
   listSessionModel = mapSessionDebug.values.toList();
    if (listSessionModel.length > 1) {
      listSessionModel.sort(
          (a, b) => b.sessionUnixTimestamp.compareTo(a.sessionUnixTimestamp));     
    }
    listSessionName = listSessionModel.map((e) => e.sessionName).toList();
    return listSessionModel;
  }
}
