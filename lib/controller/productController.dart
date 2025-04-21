import 'package:get/get.dart';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive/hive.dart';

import '../data/apiService.dart';
import '../models/productModel.dart';

class ProductController extends GetxController {
  var products = <Product>[].obs;
  var isLoading = false.obs;
  var isOffline = false.obs;
  var skip = 0;
  var hasMore = true.obs;

  @override
  void onInit() {
    super.onInit();
    initHive();
    loadProducts();
  }

  void initHive() async {
    await Hive.openBox('cacheBox');
  }

  void loadProducts({bool loadMore = false}) async {
    if (isLoading.value || !hasMore.value) return;

    isLoading.value = true;

    var connectivityResult = await Connectivity().checkConnectivity();
    isOffline.value = connectivityResult == ConnectivityResult.none;

    if (isOffline.value) {
      final box = Hive.box('cacheBox');
      final cachedData = box.get('products', defaultValue: []);
      products.assignAll(cachedData.cast<Product>());
      isLoading.value = false;
      return;
    }

    try {
      final result = await ApiService.fetchProducts(skip: skip);
      if (loadMore) {
        products.addAll(result);
      } else {
        products.assignAll(result);
      }
      skip += 10;

      if (result.length < 10) {
        hasMore.value = false;
      }

      // Save to Hive
      final box = Hive.box('cacheBox');
      box.put('products', products);
    } catch (e) {
      print('Error: $e');
    }

    isLoading.value = false;
  }

  //Filtering Based On Price Low to High
  void sortByPriceLowToHigh() {
    products.sort((a, b) => a.price.compareTo(b.price));
  }

  //Filtering Based on Price High to Low
  void sortByHighToLow() {
    products.sort((a, b) => b.price.compareTo(a.price));
  }


  //Filtering Based on Rating
  void sortByRating() {
    products.sort((a, b) => b.rating.compareTo(a.rating));
  }

  //Search Product
  void searchProduct(String keyword) {
    if (keyword.isEmpty) {
      loadProducts();
    } else {
      products.value = products
          .where((p) => p.title.toLowerCase().contains(keyword.toLowerCase()))
          .toList();
    }
  }
}
