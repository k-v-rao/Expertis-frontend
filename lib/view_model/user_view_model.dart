import 'dart:convert';

import 'package:beamer/beamer.dart';
import 'package:expertis/respository/user_repository.dart';
import 'package:expertis/routes/routes_name.dart';
import 'package:expertis/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:expertis/models/user_model.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserViewModel with ChangeNotifier {
  final _myRepo = UserRepository();
  UserModel user = UserModel();

  String email = "vignesh@xmail.com";
  String name = "Vignesh";
  String? phone;
  String? role;
  bool? verified;
  List<String>? shop;
  List<String>? appointments;
  String? createdAt;
  String? updatedAt;
  String userPic = "";
  String? id;
  String? token;
  String? message;

  bool _loading = false;
  bool get loading => _loading;
  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<bool> saveToken(String token) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.setString('token', token);
  }

  Future<bool> saveUser(UserModel user) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString('user', json.encode(user.toJson()));
    final String? userJson = sp.getString('user');
    // print("userJson: $userJson");
    notifyListeners();
    return true;
  }

  static Future<UserModel> getUser() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    final String? userJson = sp.getString('user');
    // print("userJson: $userJson");

    UserModel user = UserModel.fromJson(json.decode(userJson ?? '{}'));
    return user;
  }

  static Future<String> getUserToken() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    final String token = sp.getString('token') ?? 'dummy';
    // print("token: $token");
    return token.toString();
  }

  static Future<String> getUserId() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    final String? id = sp.getString('id');

    return id.toString();
  }

  Future<bool> logout() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.remove('token');
    await sp.remove('user');
    print('user logged out');
    // notifyListeners();
    return true;
  }

  Future<void> updateUser(
      bool isEditMode,
      Map<String, String> data,
      bool isFileSelected,
      Map<String, String> files,
      BuildContext context) async {
    setLoading(true);
    if (kDebugMode) {
      // print('data: $data');
      // print('files: $files');
    }
    _myRepo
        .updateProfileApi(isEditMode, data, isFileSelected, files)
        .then((value) {
      if (kDebugMode) {
        // print(value.toString());
      }
      final userViewModel = Provider.of<UserViewModel>(context, listen: false);
      userViewModel.saveUser(UserModel.fromJson(value['data']));
      setLoading(false);
      Utils.flushBarErrorMessage('Profile updated successfully', context);
      Beamer.of(context).beamToReplacementNamed(RoutesName.home);
    }).onError((error, stackTrace) {
      setLoading(false);
      Utils.flushBarErrorMessage(error.toString(), context);
      if (kDebugMode) {
        // print(error.toString());
      }
    });
  }
}
