import 'package:exengg/providers/categories_data.dart';
import 'package:exengg/providers/products.dart';
import 'package:flutter/material.dart';
import '../widgets/product_item.dart';
import '../widgets/side_drawer.dart';
import 'package:provider/provider.dart';

class CategoryProductsScreen extends StatefulWidget {
  static const routeName = '/category-products-screen';
  final void Function() themeChanger;
  CategoryProductsScreen(this.themeChanger);

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

enum Exchange { only, all }

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  Future<void> _onRefresh(BuildContext context) {
    return Provider.of<Products>(context, listen: false).fetchAndSetData();
  }

  bool _showOnlyExchanges = false;
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final int index = ModalRoute.of(context)!.settings.arguments as int;
    final categoryId = categoriesData[index]['id'];

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
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        actions: [
          PopupMenuButton(
              color: Theme.of(context).colorScheme.surfaceVariant,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              onSelected: ((value) {
                if (value == Exchange.only) {
                  setState(() {
                    _showOnlyExchanges = true;
                  });
                } else {
                  setState(() {
                    _showOnlyExchanges = false;
                  });
                }
              }),
              itemBuilder: (_) {
                return [
                  PopupMenuItem(
                    child: Text(
                      'Show only Exchanges',
                      style: TextStyle(
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer),
                    ),
                    value: Exchange.only,
                  ),
                  PopupMenuItem(
                    child: Text(
                      'Show All',
                      style: TextStyle(
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer),
                    ),
                    value: Exchange.all,
                  ),
                  // PopupMenuItem(
                  //   child: PopupMenuButton(
                  //     child: Padding(
                  //         padding: EdgeInsets.all(20), child: Text("Nested Items")),
                  //     itemBuilder: (_) {
                  //       return [
                  //         PopupMenuItem(child: Text("Item2")),
                  //         PopupMenuItem(child: Text("Item3"))
                  //       ];
                  //     },
                  //   ),
                  //   value: Exchange.all,
                  // ),
                ];
              })
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
                      : (_showOnlyExchanges
                          ? productsData
                              .where(
                                (element) =>
                                    (element.categoryId == categoryId &&
                                        element.price < 0),
                              )
                              .toList()
                          : productsData
                              .where(
                                (element) => element.categoryId == categoryId,
                              )
                              .toList());
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
                              categoriesData[index]['title'],
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
                                          widget.themeChanger),
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
