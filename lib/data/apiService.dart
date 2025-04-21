import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/productModel.dart';

class ApiService {
  static const String baseUrl = 'https://dummyjson.com/products';

  static Future<List<Product>> fetchProducts({int skip = 0}) async {
    final response = await http.get(Uri.parse('$baseUrl?limit=10&skip=$skip'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List products = data['products'];
      return products.map((e) => Product.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }
}
