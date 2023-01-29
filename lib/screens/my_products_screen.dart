import 'package:exengg/providers/products.dart';
import 'package:exengg/screens/auth_screen.dart';
import 'package:exengg/widgets/product_item.dart';
import 'package:exengg/widgets/side_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';

class MyProductsScreen extends StatefulWidget {
  static const routeName = '/my-products-screen';
  void Function() themeChanger;
  MyProductsScreen(this.themeChanger);

  @override
  State<MyProductsScreen> createState() => _MyProductsScreenState();
}

class _MyProductsScreenState extends State<MyProductsScreen> {
  GlobalKey<dynamic>? _scaffoldKey2 = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final productsInfo = Provider.of<Products>(context, listen: false);

    Future<void> fetchData() async {
      await productsInfo.fetchAndSetData();
    }
    // productsData =

    return RefreshIndicator(
      onRefresh: () => fetchData(),
      child: Scaffold(
          body: StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (_, snapshot) {
                return !snapshot.hasData
                    ? AuthScreen()
                    : !(Provider.of<Auth>(context, listen: false).isAuth)
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(),
                                FutureBuilder(
                                    future:
                                        Future.delayed(Duration(seconds: 3)),
                                    builder: (_, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.done)
                                        return Padding(
                                          padding: const EdgeInsets.all(28.0),
                                          child: Text(''),
                                          // 'Try Restarting the app. There seems to be a problem with your account. Kindly contact admin or create a new user account.'),
                                        );
                                      else
                                        return Text('');
                                    })
                              ],
                            ),
                          )
                        : Scaffold(
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
                                icon: Icon(Icons.menu,
                                    size: 35), // change this size and style
                                onPressed: () {
                                  _scaffoldKey2!.currentState?.openDrawer();
                                },
                                // onPressed: () {},
                              ),
                              elevation: 0,
                              backgroundColor: Colors.black.withOpacity(0),
                              actions: [
                                IconButton(
                                  onPressed: widget.themeChanger == null
                                      ? () {}
                                      : widget.themeChanger,
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
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  } else {
                                    return Consumer<Products>(
                                      builder: ((context, products, child) {
                                        List<Product> productsData = products
                                            .items
                                            .where((element) =>
                                                element.creatorId ==
                                                Provider.of<Auth>(context,
                                                        listen: false)
                                                    .getUserId)
                                            .toList();
                                        // List<Product> productsData = productsData
                                        //     .where((element) => element.isFavourite == true)
                                        //     .toList();

                                        return productsData.length == 0
                                            ? Center(
                                                child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                      Icons
                                                          .youtube_searched_for_rounded,
                                                      size: 50),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            18.0),
                                                    child: Text(
                                                        'You haven\'t added any item. Try adding one by going to the Add Items page!'),
                                                  ),
                                                ],
                                              ))
                                            : Column(
                                                // crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  SizedBox(height: 55),
                                                  Text(
                                                    'YOUR PRODUCTS',
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
                                                        padding:
                                                            EdgeInsets.all(0),
                                                        itemCount:
                                                            productsData.length,
                                                        itemBuilder:
                                                            (_, index) {
                                                          return ChangeNotifierProvider<
                                                                  Product>.value(
                                                              value:
                                                                  productsData[
                                                                      index],
                                                              child: Padding(
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        12.0,
                                                                    vertical:
                                                                        8),
                                                                child: ProductItem(
                                                                    productsData[
                                                                        index],
                                                                    widget
                                                                        .themeChanger,
                                                                    true),
                                                              ));
                                                        }),
                                                  ),
                                                ],
                                              );
                                      }),
                                    );
                                  }
                                }));
              })),
    );
  }
}
