import 'dart:convert';
import 'package:http/http.dart' as http;

mixin class HttpRequest {
  Future<String> sendCommandHttp(dynamic command, String routeAddress) async {
    if (routeAddress == "") {
      throw Exception(
          "Not a route address, please set a route address in settings");
    }
    final dynamic response;

    if (command.runtimeType == String) {
      response = await http.post(
        Uri.parse(routeAddress),
        body: command,
      );
    } else {
      late String commandStr;
      try {
        commandStr = jsonEncode(command);
      } catch (e) {
        rethrow;
      }
      response = await http.post(
        Uri.parse(routeAddress),
        body: commandStr,
      );
    }
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to emit request');
    }
  }
}
