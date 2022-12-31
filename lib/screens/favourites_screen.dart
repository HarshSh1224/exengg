import 'package:exengg/providers/products.dart';
import 'package:exengg/widgets/product_item.dart';
import 'package:exengg/widgets/side_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavouritesScreen extends StatelessWidget {
  static const routeName = '/favourites-screen';
  GlobalKey<dynamic>? scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<dynamic>? _scaffoldKey2 = GlobalKey<ScaffoldState>();
  final Function()? themeChanger;
  FavouritesScreen({this.scaffoldKey, this.themeChanger}) {
    print('RECEIVED');
  }

  @override
  Widget build(BuildContext context) {
    final productsInfo = Provider.of<Products>(context, listen: false);

    Future<void> fetchData() async {
      await productsInfo.fetchAndSetData();
    }
    // favouriteProducts =

    return RefreshIndicator(
      onRefresh: () => fetchData(),
      child: Scaffold(
          drawer: Drawer(
            child: SideDrawer(),
            backgroundColor: Colors.transparent,
          ),
          key: _scaffoldKey2,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            scrolledUnderElevation: 0,
            surfaceTintColor: Colors.transparent,
            leading: IconButton(
              icon: Icon(Icons.menu, size: 40), // change this size and style
              onPressed: () {
                if (scaffoldKey != null)
                  scaffoldKey!.currentState?.openDrawer();
                else
                  _scaffoldKey2!.currentState?.openDrawer();
              },
              // onPressed: () {},
            ),
            elevation: 0,
            backgroundColor: Colors.black.withOpacity(0),
            actions: [
              IconButton(
                onPressed: themeChanger == null ? () {} : themeChanger,
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
              future: fetchData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return Consumer<Products>(
                    builder: ((context, products, child) {
                      List<Product> productsData = products.items;
                      List<Product> favouriteProducts = productsData
                          .where((element) => element.isFavourite == true)
                          .toList();

                      return favouriteProducts.length == 0 ||
                              productsData.length == 0
                          ? Center(
                              child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.youtube_searched_for_rounded,
                                    size: 50),
                                Text(
                                  'No items found.\nTry adding some!',
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ))
                          : Column(
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(height: 55),
                                Text(
                                  'FAVOURITES',
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
                                      itemCount: favouriteProducts.length,
                                      itemBuilder: (_, index) {
                                        return ChangeNotifierProvider<
                                                Product>.value(
                                            value: favouriteProducts[index],
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12.0,
                                                      vertical: 8),
                                              child: ProductItem(
                                                  favouriteProducts[index],
                                                  themeChanger!),
                                            ));
                                      }),
                                ),
                              ],
                            );
                    }),
                  );
                }
              })),
    );
  }
}
