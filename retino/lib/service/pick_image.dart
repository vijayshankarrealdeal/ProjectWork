import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
class PickImage extends ChangeNotifier {
  File? image;
  bool load = false;
  bool predict = false;
  String me = '';
  bool sendData = false;

  final url =
      //  Platform.isAndroid
      //     ? "http://10.0.2.2:4000/upload"
      //     :
      "http://192.168.104.136:4000/upload";

  Map<String, Color> val = {
    'No DR': CupertinoColors.activeGreen,
    'Mild': CupertinoColors.activeBlue,
    'Moderate': CupertinoColors.systemYellow,
    'Severe': CupertinoColors.activeOrange,
    'Proliferative DR': CupertinoColors.destructiveRed
  };

  Future<void> getresult(File file) async {
    try {
      sendData = true;
      me = '';
      notifyListeners();
      final request = http.MultipartRequest("POST", Uri.parse(url));
      final headers = {"Content-type": "multipart/form-data"};
      request.files.add(http.MultipartFile(
          'image', file.readAsBytes().asStream(), file.lengthSync(),
          filename: file.path.split("/").last));
      request.headers.addAll(headers);
      final response = await request.send();
      final res = await http.Response.fromStream(response);
      final re = jsonDecode(res.body);
      me = re['result'];
      sendData = false;
      notifyListeners();
    } catch (e) {
      sendData = false;
      notifyListeners();
      print(e);
    }
  }

  Future<void> pickImage() async {
    final piker = await FilePicker.platform.pickFiles();
    if (piker != null) {
      image = File(piker.files.single.path!);
      load = true;
      notifyListeners();
    }
  }

  Future<void> removeImage() async {
    image = null;
    load = false;
    me = '';
    notifyListeners();
  }
}
