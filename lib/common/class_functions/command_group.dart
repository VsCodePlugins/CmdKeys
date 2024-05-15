import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CommandsGroup {
  String ?id;
  final String name;
  late int created;
  final int? updated;

  CommandsGroup(
      {
       this.id,
      required this.name,
      this.updated,
      }){
        id ??= DateTime.now().millisecondsSinceEpoch.toString();
        created = DateTime.now().millisecondsSinceEpoch ~/ 1000; ;
      }


  String toJsonString() {
    return jsonEncode({
           'id': id,
            'name':name,
            'created': created,
            'updated': updated
    });
  }

  static CommandsGroup fromJson(String jsonString) {
    Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    return CommandsGroup(
      id: jsonMap['id'],
      name: jsonMap['name'],
      updated: jsonMap['updated'],
    );
  }

  Future<void> saveToSharedPreferences(String keyGroupBase) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String jsonString = toJsonString();
    await sharedPreferences.setString("${keyGroupBase}_$name", jsonString);
  }


}