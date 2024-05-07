import 'dart:convert';
import 'package:http/http.dart' as http;

mixin class CommandsRequest {
  Future<String> sendCommand(Map<String, String> command, String routeAddress) async {
    if (routeAddress == "") {
      throw Exception(
          "Not a route address, please set a route address in settings");
    }
        String commandJson = jsonEncode(command);
      final response = await http.post(Uri.parse(routeAddress), body: commandJson, );
      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Failed to emit request');
      }

  }
}
