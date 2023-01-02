import 'package:exengg/screens/add_item_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:dart_ipify/dart_ipify.dart';
import '../widgets/method_show_dialog.dart';

class AddItemWelcome extends StatelessWidget {
  final _scaffoldKey;
  void Function() _toggleTheme;
  AddItemWelcome(this._scaffoldKey, this._toggleTheme);

  @override
  Widget build(BuildContext context) {
    getIP();
    final mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Text(''),
        actions: [
          IconButton(
            onPressed: _toggleTheme,
            icon: Icon(
              Icons.light_mode_outlined,
              size: 25,
            ),
          ),
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
        child: Container(
          // color: Colors.red,
          padding: EdgeInsets.only(
              right: 10.0,
              left: 10.0,
              bottom: (mediaQuery.height * 1 / 20),
              top: 100),
          child: Container(
            // color: Colors.red,
            height: double.infinity,
            width: double.infinity,
            constraints: BoxConstraints(
              maxHeight: mediaQuery.height - 120,
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.asset(
                      'assets/images/moon_bg.jpeg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      // color: Colors.red,
                      borderRadius: BorderRadius.circular(30),
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          // Theme.of(context).colorScheme.background.withOpacity(0.8),
                          // Theme.of(context).colorScheme.background.withOpacity(0),
                          Colors.black.withOpacity(0.8),
                          Colors.black.withOpacity(0),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 15.0,
                          spreadRadius: 15,
                          offset: Offset(7, 7),
                        ),
                      ]),
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 60,
                      ),
                      Text(
                        'Bring it\non the Air',
                        style: TextStyle(
                          fontFamily: 'Raleway',
                          fontSize: 45,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Want to sell your goodies? It\'s quite difficult to find some real good deals right!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Raleway',
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        'Sell or Exchange with ExEngg and find amazing deals superfast.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Raleway',
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(AddItemScreen.routeName, arguments: {
                            'toggle': _toggleTheme,
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 19, horizontal: 30),
                          child: Text(
                            'Sell / Exchange',
                            style: TextStyle(
                                fontSize: 19,
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                          foregroundColor:
                              Theme.of(context).colorScheme.primaryContainer,
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 50),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Expanded(
                                child: RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Please Read four pointer ',
                                    // textAlign: TextAlign.center,
                                  ),
                                  TextSpan(
                                      style: TextStyle(
                                        color: Colors.blue,
                                      ),
                                      text: 'Guidelines',
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          showGuidelinesDialog(context);
                                        }),
                                  TextSpan(
                                    text: ' before proceeding further',
                                    // textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ))
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
