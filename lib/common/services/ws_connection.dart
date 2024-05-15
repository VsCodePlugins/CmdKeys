import 'dart:convert';
import 'dart:io';
import 'package:web_socket_client/web_socket_client.dart' as websocket_client;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

mixin class WsConnection {
  websocket_client.WebSocket? wsSocket;
  websocket_client.ConnectionState? connectionState;
  final timeout = const Duration(seconds: 5);
  final backoff = const websocket_client.ConstantBackoff(Duration(seconds: 2));

  void connectToWebsocket(String routeAddress, Function notifyListeners) {
    // assert(
    //     routeAddress.contains("ws"), "the address must be a websocket route");
    final uri = Uri.parse(routeAddress);
    wsSocket = websocket_client.WebSocket(uri, backoff: backoff);
    startListenerStateWs(notifyListeners);
  }

  void identifyDeviceToServer(websocket_client.ConnectionState state) async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String deviceName = "NA";

    if (state is! websocket_client.Connected &&
        state is! websocket_client.Reconnected) {
      return;
    }
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceName = "Android ${androidInfo.model}";
    }
    if (Platform.isIOS) {
      // iOS-specific code
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceName = iosInfo.utsname.machine;
      deviceName = "Ios $deviceName";
    }
    if (kIsWeb) {
      WebBrowserInfo webBrowserInfo = await deviceInfo.webBrowserInfo;
      deviceName = webBrowserInfo.userAgent ?? "NA";
      deviceName = "WebBrowser $deviceName";
    }
    if (Platform.isLinux) {
      LinuxDeviceInfo linuxInfo = await deviceInfo.linuxInfo;
      deviceName = linuxInfo.prettyName;
      deviceName = "Linux $deviceName";
    }

    if (Platform.isWindows) {
      WindowsDeviceInfo windowsInfo = await deviceInfo.windowsInfo;
      deviceName = windowsInfo.userName;
      deviceName = "Windows $deviceName";
    }
    if (Platform.isMacOS) {
      MacOsDeviceInfo macInfo = await deviceInfo.macOsInfo;
      deviceName = macInfo.computerName;
      deviceName = "MacOs $deviceName";
    }

    Map<String, dynamic> data = {
      'clientDevice': deviceName,
      'startConnection': true
    };
    sendCommandWs(command: data);
  }

  void onMessageWebsocket({required Function(String) functionCallback,required Function() notifyListeners})async {
    wsSocket?.messages.listen((message) async {
              functionCallback(message.toString());
              notifyListeners();
     },);
  }

  void startListenerStateWs(Function notifyListeners) {
    wsSocket?.connection.listen((state) async {
      connectionState = state;
      identifyDeviceToServer(state);
      notifyListeners();
    });
  }

  void disconnectWebsocket() {
    wsSocket?.close(1000, 'CLOSE_NORMAL');
    connectionState = wsSocket?.connection.state;
    wsSocket = null;
    connectionState = null;
  }

  sendCommandWs({ required dynamic command}) {
    if (command.runtimeType == String) {
      wsSocket!.send(command);
    } else {
      late String commandStr;
      try {
         commandStr = jsonEncode(command);
      } catch (e) {
        rethrow;
      }
      wsSocket!.send(commandStr);
    }
  }
}
