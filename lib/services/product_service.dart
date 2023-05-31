import 'dart:io';

import 'package:butter_mart/models/product.dart';
import 'package:dio/dio.dart';

import '../config/api_config.dart';
import 'auth_service.dart';

class ProductService {
  // ! Dibikin singleton biar mastiin yg dibikin program hanya 1 object yg dibuat dari class ini
  ProductService._();

  static Future<List<Product>> getProduct({String? categoryId = '0'}) async {
    const url = '${ApiConfig.baseUrl}/${ApiConfig.productEndpoint}';
    try {
      final response = await dio.get(
        url,
        queryParameters: {
          'category_id': categoryId,
        },
      );
      final responseJson = response.data;
      final status = responseJson['status'];
      final message = responseJson['message'];

      if (response.statusCode == 200) {
        if (status == true) {
          final List dataApi = responseJson['data'];
          final List<Product> products = [];
          for (final product in dataApi) {
            products.add(Product.fromJson(product));
          }
          return products;
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
}
