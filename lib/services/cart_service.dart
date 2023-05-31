import 'dart:developer';
import 'dart:io';
import 'package:butter_mart/locals/secure_storage.dart';
import 'package:butter_mart/models/cart.dart';
import 'package:dio/dio.dart';
import '../config/api_config.dart';
import 'auth_service.dart';

class CartService {
  // ! Dibikin singleton biar mastiin yg dibikin program hanya 1 object yg dibuat dari class ini
  CartService._();

  static Future<List<Cart>> getCarts() async {
    const url = '${ApiConfig.baseUrl}/${ApiConfig.cartEndpoint}';
    try {
       final token = await SecureStorage.getToken();
      log('$token');
      final headers = {HttpHeaders.authorizationHeader: 'Bearer $token'};
      final response = await dio.get(
        url,
        options: Options(headers: headers)
      );
      final responseJson = response.data;
      final status = responseJson['status'];
      final message = responseJson['message'];

      if (response.statusCode == 200) {
        if (status == true) {
          final List dataApi = responseJson['data'];
          final List<Cart> carts = [];
          for (final cart in dataApi) {
            carts.add(Cart.fromJson(cart));
          }
          return carts;
        } else {
          throw Exception(message.toString());
        }
      } else {
        throw Exception(message.toString());
      }
    } on SocketException catch (e) {
      rethrow;
    } on DioError catch (e) {
      rethrow;
    }
  }

  static Future<bool> createProductCart({
    required String productId,
    required String quantity,
  })async{
    const url = '${ApiConfig.baseUrl}/${ApiConfig.cartEndpoint}';
    try {
      final data= FormData.fromMap({
  'product_id': productId,
  'quantity': quantity
});   
  final token = await SecureStorage.getToken();
      log('$token');
      final headers = {HttpHeaders.authorizationHeader: 'Bearer $token'};
      final response = await dio.post(url,data: data, options: Options(headers: headers));
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
    } on DioError catch (e) {
      return false;
    } catch(e){
      return false;
    }
 
  }

  static Future<bool> updateCart({
    required String productId,
    required String quantity,
    required String cartId
  })async{
    final url = '${ApiConfig.baseUrl}/${ApiConfig.cartEndpoint}/$cartId';
    try {
      final data= FormData.fromMap({
  'product_id': productId,
  'quantity': quantity
});   
  final token = await SecureStorage.getToken();
      log('$token');
      final headers = {HttpHeaders.authorizationHeader: 'Bearer $token'};
      final response = await dio.post(url,data: data, options: Options(headers: headers));
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
    } on DioError catch (e) {
      return false;
    } catch(e){
      return false;
    }
 
  }

   static Future<bool> deleteCart({
  
    required String cartId
  })async{
    final url = '${ApiConfig.baseUrl}/${ApiConfig.cartEndpoint}/$cartId';
    try {
    
  final token = await SecureStorage.getToken();
      log('$token');
      final headers = {HttpHeaders.authorizationHeader: 'Bearer $token'};
      final response = await dio.delete(url, options: Options(headers: headers));
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
    } on DioError catch (e) {
      return false;
    } catch(e){
      return false;
    }
 
  }
}
