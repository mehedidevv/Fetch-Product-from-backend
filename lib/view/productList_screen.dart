import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qtech_solution/res/appImage/appImage.dart';
import 'package:qtech_solution/view/widget/productTile.dart';
import '../controller/productController.dart';

class ProductListScreen extends StatelessWidget {
  final controller = Get.put(ProductController());

  ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // screen width nibo
    double width = MediaQuery.of(context).size.width;

    // mobile = 2 column, tablet = 3 column, desktop = 4 column
    int crossAxisCount = 2;
    if (width > 600) {
      crossAxisCount = 3;
    }
    if (width > 900) {
      crossAxisCount = 4;
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,

      // AppBar
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.grey,
                width: 2,
              ),
            ),
            
            child: TextField(
              onChanged: controller.searchProduct,
              decoration: const InputDecoration(
                hintText: 'Search products...',
                prefixIcon: Icon(Icons.search),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              ),
            ),
          ),
        ),
        backgroundColor: Colors.white,
        
        actions: [
          GestureDetector(
            onTap: (){
              _showFilterOptions(context);
            },
            child: SizedBox(
              height: 60,
              width: 60,
              child: Image.asset(AppImages.searchIcon),
            ),
          )
          // IconButton(
          //   icon: const Icon(Icons.filter_list_alt),
          //   onPressed: () {
          //     // Show a bottom sheet or dialog for sorting
          //     _showFilterOptions(context);
          //   },
          // ),
        ],
      ),




      //Appbar
      // appBar: AppBar(
      //   title: const Text("Products"),
      //   actions: [
      //     IconButton(
      //         icon: const Icon(Icons.price_change),
      //         onPressed: () => controller.sortByPriceLowToHigh()),
      //     IconButton(
      //         icon: const Icon(Icons.star),
      //         onPressed: () => controller.sortByRating())
      //   ],
      //   bottom: PreferredSize(
      //     preferredSize: const Size.fromHeight(50),
      //     child: Padding(
      //       padding: const EdgeInsets.all(8.0),
      //
      //       //Text Field For Searching
      //       child: TextField(
      //         onChanged: controller.searchProduct,
      //         decoration: const InputDecoration(
      //           hintText: "Search product...",
      //           border: OutlineInputBorder(),
      //           prefixIcon: Icon(Icons.search),
      //         ),
      //       ),
      //     ),
      //   ),
      // ),

      
      body: Obx(() {
        if (controller.isLoading.value && controller.products.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return NotificationListener<ScrollNotification>(
          onNotification: (scrollInfo) {
            if (!controller.isLoading.value &&
                scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
                controller.hasMore.value) {
              controller.loadProducts(loadMore: true);
            }
            return false;
          },
          child: RefreshIndicator(
            onRefresh: () async {
              controller.skip = 0;
              controller.hasMore.value = true;
              controller.loadProducts();
            },
            child: GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.68,
              ),
              itemCount: controller.products.length,
              itemBuilder: (context, index) {
                
                return ProductTile(product: controller.products[index]);
              },
            ),
          ),
        );
      }),
    );
  }
}



//Alert Dialog For Filtering
void _showFilterOptions(BuildContext context) {
  final controller = Get.put(ProductController());
  showModalBottomSheet(
    context: context,
    builder: (_) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(

            title: const Text("Price -  Low to High"),
            onTap: () {
              Get.back();
              controller.sortByPriceLowToHigh();
            },
          ),
          ListTile(

            title: const Text("Price High to Low"),
            onTap: () {
              Get.back();
              controller.sortByHighToLow();
            },
          ),

          ListTile(

            title: const Text("Rating"),
            onTap: () {
              Get.back();
              controller.sortByRating();
            },
          ),
        ],
      );
    },
  );
}
