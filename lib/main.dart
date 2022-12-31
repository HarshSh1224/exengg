import 'package:exengg/screens/about_us_screen.dart';
import 'package:exengg/screens/add_item_screen.dart';
import 'package:exengg/screens/auth_screen.dart';
import 'package:exengg/screens/favourites_screen.dart';
import 'package:exengg/screens/my_products_screen.dart';
import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import '../providers/auth.dart';
import '../screens/tabs_screen.dart';
import '../screens/category_products_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

var themeBrightness = Brightness.dark;
Color brandColor = const Color(0XFF1F7DC6);

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void toggleTheme() {
    setState(() {
      themeBrightness = themeBrightness == Brightness.dark
          ? Brightness.light
          : Brightness.dark;
    });
  }

  void changeBrandColor(Color color) {
    setState(() {
      brandColor = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Products(),
        ),
        ChangeNotifierProvider(
          create: (_) => Auth(),
        )
      ],
      child: Consumer<Auth>(
        builder: ((context, auth, child) => DynamicColorBuilder(
              builder: (l, d) {
                auth.tryLogin();
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'ExEngg',
                  theme: ThemeData(
                    useMaterial3: true,
                    canvasColor: themeBrightness == Brightness.dark
                        ? Color(0XFF1f1f1f)
                        : null,
                    colorScheme: ColorScheme.fromSeed(
                      seedColor: brandColor,
                      brightness: themeBrightness,
                    ),
                  ),
                  home: TabsScreen(toggleTheme, changeBrandColor),
                  routes: {
                    CategoryProductsScreen.routeName: (context) =>
                        CategoryProductsScreen(toggleTheme),
                    AuthScreen.routeName: (context) => AuthScreen(),
                    AddItemScreen.routeName: (context) => AddItemScreen(),
                    AboutUsScreen.routeName: (context) => AboutUsScreen(),
                    TabsScreen.routeName: (context) =>
                        TabsScreen(toggleTheme, changeBrandColor),
                    MyProductsScreen.routeName: (context) =>
                        MyProductsScreen(toggleTheme),
                    FavouritesScreen.routeName: (context) =>
                        FavouritesScreen(themeChanger: toggleTheme),
                  },
                );
              },
            )),
      ),
    );
  }
}
