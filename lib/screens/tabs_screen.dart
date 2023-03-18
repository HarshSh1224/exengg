import 'package:exengg/screens/add_item_welcome_screen.dart';
import 'package:exengg/screens/chats_screen.dart';
import 'package:new_version/new_version.dart';
import '../screens/profile_screen.dart';
import 'package:flutter/material.dart';
import '../screens/favourites_screen.dart';
import '../widgets/side_drawer.dart';
import '../screens/categories_screen.dart';

class TabsScreen extends StatefulWidget {
  static const routeName = '/tabs-screen';
  final Function() toggleTheme;
  final Function(Color) changeBrandColor;
  TabsScreen(
    this.toggleTheme,
    this.changeBrandColor,
  );

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<Map<String, Object>> _pages = [];
  int _selectedPageIndex = 2;

  @override
  void initState() {
    final newVersion = NewVersion();
    newVersion.showAlertIfNecessary(context: context);

    _pages = [
      {
        'screen': AddItemWelcome(_scaffoldKey, widget.toggleTheme),
        'title': 'Add a new item'
      },
      {
        'screen': FavouritesScreen(
            scaffoldKey: _scaffoldKey, themeChanger: widget.toggleTheme),
        'title': ''
      },
      {
        'screen': CategoriesScreen(_scaffoldKey, widget.toggleTheme),
        'title': ''
      },
      {'screen': ChatsScreen(_scaffoldKey), 'title': ''},
      {
        'screen': ProfileScreen(widget.toggleTheme, widget.changeBrandColor),
        'title': ''
      },
    ];
    super.initState();
  }

  void _selectPage(int index) {
    setState(
      () {
        _selectedPageIndex = index;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // if (ModalRoute.of(context) != null)
    // _selectedPageIndex = ModalRoute?.of(c ontext)?.settings?.arguments as int;
    print('REBULDNIG TABS SCREEN');
    return Scaffold(
      key: _scaffoldKey,
      // extendBodyBehindAppBar: true,
      body: _pages[_selectedPageIndex]['screen'] as Widget,

      // bottomNavigationBar: BottomNavigationBar(
      //   onTap: _selectPage,
      //   // backgroundColor: Theme.of(context).primaryColor,
      //   // selectedItemColor: Theme.of(context).accentColor,
      //   // unselectedItemColor: Colors.white,
      //   currentIndex: _selectedPageIndex,
      //   items: [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.category),
      //       label: 'Categories',
      //       backgroundColor: Theme.of(context).primaryColor,
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.star),
      //       label: 'Favourites',
      //       backgroundColor: Theme.of(context).primaryColor,
      //     )
      //   ],
      // ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: SizedBox(
          height: 75,
          child: NavigationBar(
              animationDuration: Duration(milliseconds: 800),
              // labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
              selectedIndex: _selectedPageIndex,
              onDestinationSelected: _selectPage,
              destinations: [
                NavigationDestination(
                  icon: Icon(Icons.add_circle_outlined),
                  label: 'Add Items',
                ),
                NavigationDestination(
                  icon: Icon(Icons.favorite),
                  label: 'Favourites',
                ),
                NavigationDestination(
                  icon: Icon(Icons.home_filled),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.chat),
                  label: 'Chats',
                ),
                NavigationDestination(
                  icon: Icon(Icons.supervised_user_circle),
                  label: 'Profile',
                ),
              ]),
        ),
      ),
      drawer: Drawer(
        child: SideDrawer(),
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
