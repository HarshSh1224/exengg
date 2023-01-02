import 'package:exengg/providers/auth.dart';
import 'package:exengg/screens/about_us_screen.dart';
import 'package:exengg/screens/favourites_screen.dart';
import 'package:exengg/screens/my_products_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SideDrawer extends StatelessWidget {
  const SideDrawer({super.key});

  Widget _listTileBuilder(
      BuildContext context, String title, Icon icon, Function() onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.white.withOpacity(0.2),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 40),
          title: Text(
            title,
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          leading: icon,
          // trailing: Icon(
          //   Icons.arrow_forward,
          //   color: Colors.white,
          // ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _auth = Provider.of<Auth>(context, listen: false);
    print('SIDE DRAWER');
    // return Container(
    return
        // Container(
        //   height: double.infinity,
        //   color: Color(0XFF031929),
        //   alignment: Alignment(-0.8, -1),
        //   child:
        Scaffold(
      backgroundColor: Color(0XFF031929).withOpacity(0.0),
      body: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(right: 0.2),
            color: Color(0XFF031929),
            width: double.infinity,
            height: double.infinity,
            child: Stack(
              children: [
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 240),
                  child: Image.asset(
                    'assets/images/nacho.png',
                    fit: BoxFit.fitWidth,
                    alignment: Alignment.topCenter,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: 320,
                    ),
                    _listTileBuilder(
                        context,
                        'Home',
                        Icon(
                          Icons.home,
                          color: Colors.white,
                          size: 25,
                        ), () {
                      // Navigator.popUntil(context, ModalRoute.withName('/tabs-screen'));
                      Navigator.of(context).popUntil(
                          (route) => route != ModalRoute.withName('/'));
                      Navigator.of(context)
                          .pushReplacementNamed('/tabs-screen');
                    }),
                    _listTileBuilder(
                        context,
                        'Favourites',
                        Icon(
                          Icons.favorite,
                          color: Colors.white,
                          size: 25,
                        ), () {
                      Navigator.of(context)
                          .pushNamed(FavouritesScreen.routeName);
                    }),
                    _listTileBuilder(
                        context,
                        'Your Products',
                        Icon(
                          Icons.propane,
                          color: Colors.white,
                          size: 25,
                        ), () {
                      Navigator.of(context)
                          .pushNamed(MyProductsScreen.routeName);
                    }),
                    Spacer(),
                    _listTileBuilder(
                        context,
                        'About Us',
                        Icon(
                          Icons.info,
                          color: Colors.white,
                          size: 25,
                        ), () {
                      Navigator.of(context).pushNamed(About.routeName);
                    }),
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
                // Positioned(
                //   top: 20,
                //   child: Material(
                //     color: Colors.transparent,
                //     child: InkWell(
                //       onTap: () {
                //         print('HOME TAP');
                //       },
                //       splashColor: Colors.white.withOpacity(0.2),
                //       child: ListTile(
                //         contentPadding: EdgeInsets.symmetric(horizontal: 40),
                //         title: Text(
                //           'Settings',
                //           style: TextStyle(color: Colors.white, fontSize: 16),
                //         ),
                //         leading: Icon(
                //           Icons.settings,
                //           color: Colors.white,
                //           size: 25,
                //         ),
                //         // trailing: Icon(
                //         //   Icons.arrow_forward,
                //         //   color: Colors.white,
                //         // ),
                //       ),
                //     ),
                //   ),
                // )
              ],
            ),
          ),
          ClipPath(
            clipper: CustomClipPath(),
            // borderRadius:
            //     BorderRadius.only(bottomRight: Radius.elliptical(400, 100)),
            child: Container(
              margin: EdgeInsets.zero,
              width: double.infinity,
              height: 300,
              color: Color(0XFF60A2B7),
              // decoration: BoxDecoration(
              //   borderRadius:
              //       // BorderRadius.horizontal(right: Radius.elliptical(300, 100)),
              // ),
              alignment: Alignment(0, -0.3),
              child: Column(
                children: [
                  SizedBox(
                    height: 70,
                  ),
                  CircleAvatar(
                    backgroundColor: Color(0XFFDADCE0),
                    backgroundImage: _auth.isAuth
                        ? Image.network(_auth.imageUrl!).image
                        : null,
                    child: _auth.isAuth
                        ? null
                        : Icon(
                            Icons.person,
                            size: 60,
                            color: Color(0XFF9AA0A6),
                          ),
                    radius: 56,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    _auth.isAuth ? _auth.getName : 'No User',
                    style: TextStyle(fontSize: 19, color: Colors.white),
                  ),
                  if (_auth.isAuth)
                    Text(
                      _auth.email!,
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
    // color: Color(0XFF031929),
    // child: Text('data'),
    // );
  }
}

class CustomClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path0 = Path();
    path0.moveTo(0, 0);
    path0.lineTo(0, size.height - 30);
    path0.quadraticBezierTo(
        size.width * 0.6, size.height - 10, size.width, size.height - 65);
    // path0.lineTo(size.width, size.height);
    path0.lineTo(size.width, 0);
    path0.close();
    return path0;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
