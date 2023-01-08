import 'package:exengg/screens/about_us_screen.dart';
import 'package:exengg/screens/about_us_screen.dart';
import 'package:exengg/screens/add_item_screen.dart';
import 'package:exengg/screens/auth_screen.dart';
import 'package:exengg/screens/favourites_screen.dart';
import 'package:exengg/screens/feedback_form.dart';
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
  await getThemeFromDevice();
  runApp(const MyApp());
}

var themeBrightness = Brightness.dark;
Color brandColor = const Color(0XFF1F7DC6);

Color get brand {
  return brandColor;
}

Future<void> getThemeFromDevice() async {
  final getStorage = await GetStorage();
  getStorage.writeIfNull('brightness', 'dark');

  if (getStorage.read('brightness') == 'dark') {
    // print('READING INSTANCE DARK');
    themeBrightness = Brightness.dark;
  } else {
    // print('READING INSTANCE LIGHT');
    themeBrightness = Brightness.light;
  }

  getStorage.writeIfNull('brandColor', 'Color(0xFF1F7DC6)');
  String colorString = getStorage.read('brandColor');
  // print('READ COLOR = $colorString');
  String valueString = colorString.split('(0x')[1].split(')')[0];
  int color = int.parse(valueString, radix: 16);
  brandColor = Color(color);
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void toggleTheme() async {
    setState(() {
      themeBrightness = themeBrightness == Brightness.dark
          ? Brightness.light
          : Brightness.dark;
    });
    final getStorage = await GetStorage();
    getStorage.write(
        'brightness', themeBrightness == Brightness.dark ? 'dark' : 'light');
    // print('WRITING BRIGHTNESS INSTANCE');
  }

  void changeBrandColor(Color color) async {
    setState(() {
      brandColor = color;
      // print(color.value.toString());
    });
    final getStorage = await GetStorage();
    getStorage.write('brandColor', color.toString());
    // print('WRITING BRANDCOLOR INSTANCE');
  }

  @override
  Widget build(BuildContext context) {
    print('Building Main');
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Products(),
        ),
        ChangeNotifierProvider(
          create: (_) => Auth(),
        ),
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
                  home: TabsScreen(toggleTheme, changeBrandColor, brand),
                  routes: {
                    CategoryProductsScreen.routeName: (context) =>
                        CategoryProductsScreen(toggleTheme),
                    AuthScreen.routeName: (context) => AuthScreen(),
                    AddItemScreen.routeName: (context) => AddItemScreen(),
                    TabsScreen.routeName: (context) =>
                        TabsScreen(toggleTheme, changeBrandColor, brand),
                    MyProductsScreen.routeName: (context) =>
                        MyProductsScreen(toggleTheme),
                    FavouritesScreen.routeName: (context) =>
                        FavouritesScreen(themeChanger: toggleTheme),
                    About.routeName: (context) => About(),
                    FeedbackForm.routeName: (context) =>
                        FeedbackForm(brandColor),
                  },
                );
              },
            )),
      ),
    );
  }
}
