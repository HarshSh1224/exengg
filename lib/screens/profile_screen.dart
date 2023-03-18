import 'package:exengg/screens/chats_screen.dart';
import 'package:exengg/screens/favourites_screen.dart';
import 'package:exengg/screens/feedback_form.dart';
import 'package:exengg/screens/my_products_screen.dart';
import 'package:exengg/widgets/color_picker_dialog.dart';
import 'package:exengg/widgets/edit_profile_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../providers/auth.dart';
import '../screens/auth_screen.dart';
// import 'package:flutter_material_pickers/flutter_material_pickers.dart';

class ProfileScreen extends StatefulWidget {
  void Function() _themeChanger;
  void Function(Color) _changeBrandColor;
  ProfileScreen(
    this._themeChanger,
    this._changeBrandColor,
  );

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  void _showColorPicker(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return ColorPickerDialog(widget._changeBrandColor);
        });
  }

  void _showFeatureUnavailable(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
            content: Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: Text(
                'This feature will be added soon. Please keep checking for updates.',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimaryContainer),
              ),
            ),
            actions: [
              TextButton(
                onPressed: Navigator.of(context).pop,
                child: Text('Okay'),
              ),
            ],
          );
        });
  }

  // bool _switchValue = false;

  // @override
  // void initState() {
  //   _switchValue = Theme.of(context).colorScheme.brightness == Brightness.dark
  //       ? true
  //       : false;

  //   super.initState();
  // }

  Widget _listItemBuilder(
      BuildContext context, String title, Icon icon, Function() onTap) {
    return Material(
        color: Colors.transparent,
        child: InkWell(
          child: ListTile(
            leading: icon,
            title: Text(
              title,
              style: TextStyle(
                fontFamily: 'Raleway',
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
            trailing: title == 'Dark Theme'
                ? Transform.scale(
                    scale: 0.9,
                    child: Switch(
                        activeColor: Theme.of(context).colorScheme.primary,
                        value: Theme.of(context).colorScheme.brightness ==
                                Brightness.dark
                            ? true
                            : false,
                        onChanged: (value) {
                          setState(() {
                            widget._themeChanger();
                          });
                        }),
                  )
                : Icon(Icons.arrow_forward_ios_rounded),
          ),
          splashColor: Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.circular(0),
          onTap: onTap,
        ));
  }

  @override
  Widget build(BuildContext context) {
    // Provider.of(context);
    return Scaffold(
        body: StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (_, snapshot) {
        print('BUILDING PROFILE SCREEN');
        return !snapshot.hasData
            ? AuthScreen()
            : RefreshIndicator(
                onRefresh: () async {
                  setState(() {});
                  return;
                },
                child: Consumer<Auth>(
                  builder: ((context, auth, child) => auth.isAuth == false
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(),
                              FutureBuilder(
                                  future: Future.delayed(Duration(seconds: 5)),
                                  builder: (_, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.done)
                                      return Padding(
                                          padding: const EdgeInsets.all(28.0),
                                          child: Text(
                                            // 'Try Restarting the app. There seems to be a problem with your account. Kindly contact admin or create a new user account.\nWe apologize for the inconvenience'),
                                            '',
                                          ));
                                    else
                                      return Text('');
                                  })
                            ],
                          ),
                        )
                      : SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                color: Theme.of(context)
                                    .colorScheme
                                    .surfaceVariant,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              1 /
                                              27,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (_) {
                                                    return AlertDialog(
                                                      backgroundColor:
                                                          Theme.of(context)
                                                              .colorScheme
                                                              .surfaceVariant,
                                                      title: Text(
                                                        'Are you sure?',
                                                        style: TextStyle(
                                                          color: Theme.of(
                                                                  context)
                                                              .colorScheme
                                                              .onSecondaryContainer,
                                                          fontFamily: 'Roboto',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20,
                                                        ),
                                                      ),
                                                      content: Text(
                                                        'Do you want to sign out of your account?',
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .onPrimaryContainer),
                                                      ),
                                                      actions: [
                                                        TextButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child: Text('No')),
                                                        TextButton(
                                                            onPressed: () {
                                                              Provider.of<Auth>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .logOut();
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child: Text('Yes')),
                                                      ],
                                                    );
                                                  });
                                            },
                                            icon: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 13.0),
                                              child: Icon(
                                                Icons.logout_rounded,
                                                size: 25,
                                              ),
                                            )),
                                        IconButton(
                                            onPressed: () {
                                              showModalBottomSheet(
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topLeft: Radius
                                                                .circular(20),
                                                            topRight:
                                                                Radius.circular(
                                                                    20)),
                                                  ),
                                                  isScrollControlled: true,
                                                  context: context,
                                                  builder: (_) {
                                                    return EditBottomSheet();
                                                  });
                                            },
                                            icon: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 13.0),
                                              child: Icon(
                                                Icons.edit,
                                                size: 25,
                                              ),
                                            )),
                                      ],
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              1 /
                                              25,
                                    ),

                                    Container(
                                      width: 168,
                                      height: 168,
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          child: auth.imageUrl == null
                                              ? Image.asset(
                                                  'assets/images/logo.jpg')
                                              : Image.network(
                                                  auth.imageUrl!,
                                                  fit: BoxFit.cover,
                                                )),
                                      decoration: BoxDecoration(
                                        color: Color(0xff333333),
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Color.fromARGB(255, 39, 39, 39),
                                            Color(0xff333333),
                                          ],
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color(0xff3f3f3f)
                                                .withOpacity(Theme.of(context)
                                                            .colorScheme
                                                            .brightness ==
                                                        Brightness.dark
                                                    ? 1
                                                    : 0.3),
                                            offset: Offset(-5.3, -5.3),
                                            blurRadius: 20,
                                            spreadRadius: 0.0,
                                          ),
                                          BoxShadow(
                                            color: Color(0xff272727)
                                                .withOpacity(Theme.of(context)
                                                            .colorScheme
                                                            .brightness ==
                                                        Brightness.dark
                                                    ? 1
                                                    : 0.3),
                                            offset: Offset(5.3, 5.3),
                                            blurRadius: 20,
                                            spreadRadius: 0.0,
                                          ),
                                        ],
                                      ),

                                      // decoration: BoxDecoration(
                                      //   color: Color(0xff333333),
                                      //   borderRadius: BorderRadius.circular(100),
                                      //   gradient: LinearGradient(
                                      //     begin: Alignment.topLeft,
                                      //     end: Alignment.bottomRight,
                                      //     colors: [
                                      //       Color(0xff222222),
                                      //       Theme.of(context)
                                      //           .colorScheme
                                      //           .surfaceVariant,
                                      //     ],
                                      //   ),
                                      //   boxShadow: [
                                      //     // BoxShadow(
                                      //     //   color: Theme.of(context)
                                      //     //       .colorScheme
                                      //     //       .onBackground
                                      //     //       .withOpacity(0.6),
                                      //     //   offset: Offset(-10.1, -10.1),
                                      //     //   blurRadius: 30,
                                      //     //   spreadRadius: 0.0,
                                      //     // ),
                                      //     BoxShadow(
                                      //       color: Color(0xff222222),
                                      //       // color: Theme.of(context)
                                      //       //     .colorScheme
                                      //       //     .background,
                                      //       // .withOpacity(0.6),
                                      //       offset: Offset(10.1, 10.1),
                                      //       blurRadius: 30,
                                      //       spreadRadius: 0.0,
                                      //     ),
                                      //   ],
                                      // ),
                                    ),

                                    // CircleAvatar(
                                    //     radius: 60,
                                    //     // child: ClipRRect(
                                    //     // borderRadius: BorderRadius.circular(60),
                                    //     backgroundImage: auth.imageUrl == null
                                    //         ? Image.asset(
                                    //                 'assets/images/logo.jpg')
                                    //             .image
                                    //         : Image.network(
                                    //             auth.imageUrl!,
                                    //             fit: BoxFit.fill,
                                    //           ).image),

                                    // ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    Text(
                                      auth.name ?? 'Loading...',
                                      style: TextStyle(
                                          fontFamily: 'BebasNeue',
                                          fontSize: 30),
                                    ),
                                    Text(
                                      auth.email ?? 'loading...',
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                  ],
                                ),
                              ),

                              Container(
                                // color: Colors.red,
                                // height: double.infinity,
                                decoration: BoxDecoration(
                                    color: Theme.of(context).canvasColor,
                                    boxShadow: [
                                      // BoxShadow(blurRadius: 8.0),
                                      // BoxShadow(
                                      //     color: Colors.white,
                                      //     offset: Offset(0, -16)),
                                      BoxShadow(
                                          blurRadius: 18.0,
                                          color: Colors.black.withOpacity(0.4),
                                          // spreadRadius: 0.1,
                                          offset: Offset(0, -1)),
                                      // BoxShadow(
                                      //     blurRadius: 8.0,
                                      //     color: Colors.black.withOpacity(0.4),
                                      //     offset: Offset(16, -5)),
                                      BoxShadow(
                                          color: Theme.of(context).canvasColor,
                                          offset: Offset(-16, 26)),
                                      BoxShadow(
                                          color: Theme.of(context).canvasColor,
                                          offset: Offset(16, 26)),
                                    ]),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 35),
                                      width: double.infinity,
                                      child: Text(
                                        'CONTENT',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontFamily: 'MoonBold',
                                            fontSize: 10,
                                            letterSpacing: 3,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .outline),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      // height: 60,
                                      width: double.infinity,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      child: Card(
                                        margin: EdgeInsets.zero,
                                        elevation: 7,
                                        child: Column(
                                          children: [
                                            _listItemBuilder(context, 'Chats',
                                                Icon(Icons.chat), () {
                                              Navigator.of(context).pushNamed(
                                                  ChatsScreen.routeName);
                                            }),
                                            Divider(
                                              indent: 8,
                                              endIndent: 8,
                                            ),
                                            _listItemBuilder(
                                                context,
                                                'Favourites',
                                                Icon(Icons.favorite_border),
                                                () {
                                              print('TAPPP');
                                              Navigator.of(context).pushNamed(
                                                  FavouritesScreen.routeName);
                                            }),
                                            Divider(
                                              indent: 8,
                                              endIndent: 8,
                                            ),
                                            _listItemBuilder(
                                                context,
                                                'Your Products',
                                                Icon(Icons.propane_outlined),
                                                () async {
                                              var page =
                                                  await Future.microtask(() {
                                                return MyProductsScreen(
                                                    widget._themeChanger);
                                              });
                                              var route = MaterialPageRoute(
                                                  builder: (_) => page);
                                              Navigator.push(context, route);
                                              // Navigator.of(context).pushNamed(
                                              //     MyProductsScreen.routeName);
                                            }),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 35),
                                      width: double.infinity,
                                      child: Text(
                                        'PREFERENCES',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontFamily: 'MoonBold',
                                            fontSize: 10,
                                            letterSpacing: 3,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .outline),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Container(
                                      // height: 60,
                                      width: double.infinity,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      child: Card(
                                        margin: EdgeInsets.zero,
                                        elevation: 7,
                                        child: Column(
                                          children: [
                                            _listItemBuilder(
                                                context,
                                                'Dark Theme',
                                                Icon(Icons.dark_mode_outlined),
                                                () {
                                              setState(() {
                                                widget._themeChanger();
                                              });
                                            }),
                                            Divider(
                                              indent: 8,
                                              endIndent: 8,
                                            ),
                                            _listItemBuilder(
                                                context,
                                                'Accent Color',
                                                Icon(
                                                  Icons.color_lens_outlined,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                ), () {
                                              _showColorPicker(context);
                                            }),
                                            Divider(
                                              indent: 8,
                                              endIndent: 8,
                                            ),
                                            _listItemBuilder(
                                              context,
                                              'Provide Feedback',
                                              Icon(Icons.feedback_outlined),
                                              () {
                                                Navigator.of(context).pushNamed(
                                                    FeedbackForm.routeName);
                                              },
                                            ),
                                            Divider(
                                              indent: 8,
                                              endIndent: 8,
                                            ),
                                            _listItemBuilder(
                                              context,
                                              'Edit Profile',
                                              Icon(
                                                  Icons.person_outline_rounded),
                                              () {
                                                showModalBottomSheet(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              topLeft: Radius
                                                                  .circular(20),
                                                              topRight: Radius
                                                                  .circular(
                                                                      20)),
                                                    ),
                                                    isScrollControlled: true,
                                                    context: context,
                                                    builder: (_) {
                                                      return EditBottomSheet();
                                                    });
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (_) {
                                              return AlertDialog(
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .surfaceVariant,
                                                title: Text(
                                                  'Are you sure?',
                                                  style: TextStyle(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onSecondaryContainer,
                                                    fontFamily: 'Roboto',
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20,
                                                  ),
                                                ),
                                                content: Text(
                                                  'Do you want to sign out of your account?',
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onPrimaryContainer),
                                                ),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text('No')),
                                                  TextButton(
                                                      onPressed: () {
                                                        Provider.of<Auth>(
                                                                context,
                                                                listen: false)
                                                            .logOut();
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text('Yes')),
                                                ],
                                              );
                                            });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12.0, horizontal: 40),
                                        child: Text(
                                          'LOG OUT',
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontFamily: 'Raleway',
                                              fontWeight: FontWeight.w700,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onBackground),
                                        ),
                                      ),
                                      style: ButtonStyle(
                                        // backgroundColor: Theme.of(context)
                                        //     .colorScheme
                                        //     .onPrimaryContainer,
                                        // foregroundColor: Theme.of(context)
                                        //     .colorScheme
                                        //     .primaryContainer,
                                        elevation: MaterialStateProperty
                                            .resolveWith<double>(
                                          (Set<MaterialState> states) {
                                            // if the button is pressed the elevation is 10.0, if not
                                            // it is 5.0
                                            if (states.contains(
                                                MaterialState.pressed))
                                              return 5.0;
                                            return 5.0;
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 50,
                                    )
                                  ],
                                ),
                              ),

                              // SizedBox(
                              //   height: 50,
                              // )
                            ],
                          ),
                        )),
                ),
              );
      },
    ));
  }
}
