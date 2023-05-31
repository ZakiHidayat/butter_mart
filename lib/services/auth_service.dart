import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';

import '../config/api_config.dart';
import '../locals/secure_storage.dart';
import '../models/user.dart';

final dio = Dio();

class AuthService {
  // ! Dibikin singleton biar mastiin yg dibikin program hanya 1 object yg dibuat dari class ini
  AuthService._();

  static Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      const url = '${ApiConfig.baseUrl}/${ApiConfig.loginEndpoint}';
      final data = {
        'email': email,
        'password': password,
      };
      final response = await dio.post(url, data: data);

      if (response.statusCode == 200) {
        final responseJson = response.data;
        final status = responseJson['status'];
        log(status.toString());
        if (status == true) {
          final token = responseJson['access_token'];
          log('$token');
          log('${responseJson['data']}');
          final user = User.fromJson(responseJson['data']);
          // log('${user.toJson()}');
          // ! Cache User dan token
          await SecureStorage.cacheToken(token: token);
          await SecureStorage.cacheUser(user: user);
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } on DioError catch (e) {
      throw e;
    }
  }

  static Future<Response<dynamic>> register({
    required String name,
    required String email,
    required String no_telp,
    required String alamat,
    required String password,
    required String confirm_password,
  }) async {
    const url = '${ApiConfig.baseUrl}/${ApiConfig.registerEndpoint}';
    final data = {
      'name': name,
      'email': email,
      'no_telp': no_telp,
      'alamat': alamat,
      'password': password,
      'confirm_password': confirm_password
    };
    final response = await dio.post(
      url,
      data: data,
    );

    if (response.statusCode == 200) {
      final responseJson = response.data;
      final status = responseJson['status'];
      if (status == true) {
        final token = responseJson['access_token'];
        final user = User.fromJson(responseJson['data']);
        // ! Cache User dan token
        await SecureStorage.cacheToken(token: token);
        await SecureStorage.cacheUser(user: user);
      }
    }
    return response;
  }

  static Future<bool> logout() async {
    try {
      const url = '${ApiConfig.baseUrl}/${ApiConfig.logoutEndpoint}';
      final token = await SecureStorage.getToken();
      log('$token');
      final headers = {HttpHeaders.authorizationHeader: 'Bearer $token'};
      final response = await dio.post(url, options: Options(headers: headers));
      if (response.statusCode == 200) {
        final responseJson = response.data;
        final status = responseJson['status'];
        if (status == true) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      log('Error $e');
      return false;
    }
  }
}
