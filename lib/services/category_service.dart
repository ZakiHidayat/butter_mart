import 'package:butter_mart/models/category.dart';
import 'package:dio/dio.dart';

import '../config/api_config.dart';
import 'auth_service.dart';

class CategoryService {
  // ! Dibikin singleton biar mastiin yg dibikin program hanya 1 object yg dibuat dari class ini
  CategoryService._();

  static Future<List<Category>> getCategories() async {

      const url = '${ApiConfig.baseUrl}/${ApiConfig.categoryEndpoint}';

      final response = await dio.get(
          url,

      );
      final responseJson = response.data;
      final status = responseJson['status'];
      final message = responseJson['message'];

      if (response.statusCode == 200) {



        if (status == true) {
          final List dataApi = responseJson['data'];
          final List<Category> categories = [];
          for(final category in dataApi)
         {
           categories.add(Category.fromJson(category));

         }
          return categories;

        }else{
          throw Exception(message.toString());
        }
      } else{
        throw Exception(message.toString());
      }

  }


}