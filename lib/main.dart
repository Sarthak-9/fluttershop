import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttershop/providers/auth/user_data_provider.dart';
import 'package:fluttershop/screens/admin/approve_product_field_detail_screen.dart';
import 'package:fluttershop/screens/admin/aproove_category_product_screen.dart';
import 'package:fluttershop/screens/auth/signup_page.dart';
import 'package:fluttershop/screens/user/view_product_detail_screen.dart';

import 'package:provider/provider.dart';
import 'providers/admin/product_categories.dart';
import 'screens/admin/add_categories.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'homepage.dart';
import 'screens/admin/approve_product_category_screen.dart';
import 'screens/auth/login_page.dart';
import 'screens/seller/add_product_screen.dart';
import 'screens/seller/view_categories_screen.dart';
import 'screens/user/view_category_products_screen.dart';
bool signin = false;

Future<void> main()async {
  final storage = new FlutterSecureStorage();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  signin = await storage.read(key: "signedIn") == "true" ? true : false;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (ctx)=>ProductCategories()),
      ChangeNotifierProvider(create: (ctx)=>UserData()),

    ],
      child: MaterialApp(
        title: 'FlutterShop',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: const Color(0xFF305496),
          primarySwatch: Colors.blue,
        ),
        routes: {
          LoginPage.routename:(ctx)=>LoginPage(),
          SignUp.routename:(ctx)=>SignUp(),
          HomePage.routeName:(ctx)=>HomePage(),
          AddCategoriesScreen.routeName:(ctx)=>AddCategoriesScreen(),
          ViewCategoryScreen.routeName:(ctx)=>ViewCategoryScreen(),
          AddProductScreen.routeName:(ctx)=>AddProductScreen(0),
          ViewCategoryProducts.routeName:(ctx)=>ViewCategoryProducts(),
          ViewProductDetailSceeen.routeName:(ctx)=>ViewProductDetailSceeen(),
          ApproveProductCategoryScreen.routeName:(ctx)=>ApproveProductCategoryScreen(),
          ApproveCategoryProductDetailScreen.routeName:(ctx)=>ApproveCategoryProductDetailScreen(''),
          ApproveProductFieldDetailScreen.routeName:(ctx)=>ApproveProductFieldDetailScreen(0),
        },
        home: CheckLogin(),
      ),
    );
  }
}
class CheckLogin extends StatefulWidget {
  const CheckLogin({Key key}) : super(key: key);

  @override
  _CheckLoginState createState() => _CheckLoginState();
}
class _CheckLoginState extends State<CheckLogin> {
  bool isLoading = true;

  @override
  void initState() {
    setState(() {
      isLoading = true;
    });
    // TODO: implement initState
    Future.delayed(Duration.zero).then((value) => fetch());
    // fetch();
    super.initState();
  }
  void fetch() async {
    await Provider.of<UserData>(context, listen: false).fetchUser().then((value) => print('22'));
    // Future.delayed(Duration.zero).then((value) => print(1));
    setState(() {
      isLoading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return isLoading ? Container(
      alignment: Alignment.center,
      color: Colors.white,
      child: Image.asset("assets/images/logo.png"),):signin==true? HomePage() : LoginPage();//MyHomePage(tabNumber: 0,);
  }
}

