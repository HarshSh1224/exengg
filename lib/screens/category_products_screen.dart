import 'package:exengg/providers/auth.dart';
import 'package:exengg/providers/products.dart';
import 'package:flutter/material.dart';
import '../widgets/product_item.dart';
import '../widgets/side_drawer.dart';
import 'package:provider/provider.dart';

class CategoryProductsScreen extends StatelessWidget {
  Future<void> _onRefresh(BuildContext context) {
    return Provider.of<Products>(context, listen: false).fetchAndSetData();
  }

  static const routeName = '/category-products-screen';
  void Function() themeChanger;
  CategoryProductsScreen(this.themeChanger);
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final String categoryId =
        ModalRoute.of(context)!.settings.arguments as String;

    // print(categoryProducts[0].title);
    // print('object');

    return Scaffold(
      key: _scaffoldKey,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu, size: 40), // change this size and style
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        elevation: 0,
        backgroundColor: Colors.black.withOpacity(0),
        actions: [
          IconButton(
            onPressed: themeChanger,
            icon: Icon(
              Icons.light_mode_outlined,
              size: 25,
            ),
          ),
        ],
        title: const Text(
          '',
        ),
      ),
      body: FutureBuilder(
        future: _onRefresh(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          else
            return RefreshIndicator(
              onRefresh: () => _onRefresh(context),
              child: Consumer<Products>(
                builder: (context, products, ch) {
                  final productsData = products.items;
                  final categoryProducts = productsData.length == 0
                      ? []
                      : productsData
                          .where(
                            (element) => element.categoryId == categoryId,
                          )
                          .toList();
                  categoryProducts
                      .sort(((a, b) => b.createDate.compareTo(a.createDate)));

                  return categoryProducts.length == 0 ||
                          productsData.length == 0
                      ? Center(
                          child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.youtube_searched_for_rounded, size: 50),
                            Text('No items found'),
                          ],
                        ))
                      : Column(
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 55),
                            Text(
                              categoryId == 'd1'
                                  ? 'DRAFTERS'
                                  : (categoryId == 'd2'
                                      ? 'LAB COATS'
                                      : 'MISCELLANEOUS'),
                              style: TextStyle(
                                  fontFamily: 'BebasNeue',
                                  fontSize: 30,
                                  letterSpacing: 2.5),
                            ),
                            // SizedBox(
                            //   height: 10,
                            // ),
                            Expanded(
                              child: ListView.builder(
                                padding: EdgeInsets.all(0),
                                itemCount: categoryProducts.length,
                                itemBuilder: (_, index) {
                                  return ChangeNotifierProvider<Product>.value(
                                    value: categoryProducts[index],
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12.0, vertical: 8),
                                      child: ProductItem(
                                          categoryProducts[index],
                                          themeChanger),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                },
              ),
            );
        },
      ),
      drawer: Drawer(child: SideDrawer()),
    );
  }
}
