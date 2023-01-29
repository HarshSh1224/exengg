import 'package:exengg/providers/categories_data.dart';
import 'package:exengg/screens/category_products_screen.dart';
import 'package:exengg/widgets/side_drawer.dart';
import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../providers/auth.dart';

class CategoriesScreen extends StatelessWidget {
  static const routeName = '/categories-screen';
  final _scaffoldKey;
  final Function() toggleTheme;

  CategoriesScreen(this._scaffoldKey, this.toggleTheme);

  Widget dividerText(BuildContext context, String title) {
    return Container(
      padding: EdgeInsets.only(left: 15, top: 15, bottom: 4),
      width: double.infinity,
      child: Text(
        title,
        textAlign: TextAlign.left,
        style: TextStyle(
            fontFamily: 'MoonBold',
            fontSize: 10,
            letterSpacing: 2.3,
            color: Theme.of(context).colorScheme.outline),
      ),
    );
  }

  Widget _categoryItemBuilder(BuildContext ctx, int idx, String title,
      String subtitle, String imageUrl) {
    return Container(
      width: double.infinity,
      child: Card(
        elevation: 8,
        margin: EdgeInsets.all(12),
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(imageUrl),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(10),
                // border: Border.all(color: Colors.transparent, width: 1)
              ),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24.0, vertical: 28),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    stops: [0.2, 1],
                    colors:
                        Theme.of(ctx).colorScheme.brightness == Brightness.light
                            ? [
                                // Color.fromARGB(255, 51, 139, 255).withOpacity(0.9),
                                // Color.fromARGB(255, 51, 139, 255).withOpacity(0),
                                Colors.black.withOpacity(0.5),
                                Colors.black.withOpacity(0),
                              ]
                            : [
                                Colors.black.withOpacity(0.7),
                                Colors.black.withOpacity(0),
                              ],
                  ),
                ),
                height: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 30,
                        // letterSpacing: 1,
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 11,
                        fontFamily: 'Raleway',
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  splashColor: Colors.white.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(15),
                  onTap: () {
                    Navigator.of(ctx).pushNamed(
                        CategoryProductsScreen.routeName,
                        arguments: idx);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _isDark = true;

  @override
  Widget build(BuildContext context) {
    // final _scaffoldKey2 = new GlobalKey<ScaffoldState>();
    return Scaffold(
      // key: _scaffoldKey2,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Text(''),
        actions: [
          StatefulBuilder(builder: (context, setsState) {
            return IconButton(
              onPressed: () {
                setsState(() {
                  _isDark = !_isDark;
                  toggleTheme();
                });
              },
              icon: Icon(
                _isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                size: 25,
              ),
            );
          }),
        ],
        leading: IconButton(
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          // onPressed: () => print('DRAWER'),
          icon: Icon(
            Icons.menu,
            size: 35,
            // color: Theme.of(context).colorScheme.background,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(height: 55),
            Center(
              child: Text(
                'CATEGORIES',
                style: TextStyle(
                    fontFamily: 'BebasNeue', fontSize: 30, letterSpacing: 2.5),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            dividerText(context, 'Study Material'),
            _categoryItemBuilder(context, 0, categoriesData[0]['title'],
                'Buy/Exchange', categoriesData[0]['image']),
            // SizedBox(
            //   height: 10,
            // ),
            // Divider(),
            dividerText(context, 'Instruments / Accessories'),
            ...categoriesData.map((cat) {
              if (cat['index'] == 0 || cat['title'] == 'Miscellaneous')
                return Container();
              return _categoryItemBuilder(context, cat['index'], cat['title'],
                  'Buy/Exchange', cat['image']);
            }).toList(),
            // SizedBox(
            //   height: 10,
            // ),
            // Divider(),
            dividerText(context, 'Extras'),
            _categoryItemBuilder(
                context,
                categoriesData.length - 1,
                categoriesData[categoriesData.length - 1]['title'],
                'Buy/Exchange',
                categoriesData[categoriesData.length - 1]['image']),
            // _categoryItemBuilder(context, 'DRAFTER', 'Buy/Exchange',
            //     'assets/images/drafter_bg.png'),
            // _categoryItemBuilder(context, 'LABCOAT/APRON', 'Buy/Exchange',
            //     'assets/images/labcoat_bg.jpg'),
            // _categoryItemBuilder(context, 'Miscellaneous', 'Buy/Exchange',
            //     'assets/images/misc.png'),
          ],
        ),
      ),
      drawer: Drawer(child: SideDrawer()),
    );
  }
}
