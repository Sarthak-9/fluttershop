import 'package:flutter/material.dart';
import 'package:fluttershop/providers/auth/user_data_provider.dart';
import 'package:fluttershop/screens/admin/approve_product_category_screen.dart';
import 'package:fluttershop/screens/auth/login_page.dart';
import 'package:fluttershop/screens/seller/view_categories_screen.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../homepage.dart';
import '../screens/admin/add_categories.dart';


class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    var currentUser = Provider.of<UserData>(context, listen: false).userData;
    int userRole = currentUser.userRole;
    return Drawer(
      child: Container(
        // decoration: BoxDecoration(),
        // color: const Color(0xFF305496),
        padding: EdgeInsets.only(top: statusBarHeight),
        child: SingleChildScrollView(
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                currentAccountPicture: CircleAvatar(
                  backgroundImage:
                  // currentUser.profilePhotoLink != null
                  //     ? NetworkImage(currentUser.profilePhotoLink)
                  //     :
              AssetImage('assets/images/userimage.png'),
                ),
                accountName: Text(currentUser.userName),
                accountEmail: Text(currentUser.userEmail),
                // onDetailsPressed: () =>Navigator.of(context).pushNamed(UserProfilePage.routename),

                // decoration: BoxDecoration(
                //     gradient: LinearGradient(
                //       colors: [
                //         Colors.green, Colors.lightGreen
                //       ],
                //     )
                // ),
              ),
              ListTile(
                leading: Icon(Icons.home_rounded),
                title: Text("Home"),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HomePage()));
                },
              ),
              // Divider(),
              if(userRole==1)
              ListTile(
                leading: Icon(Icons.apps_rounded),
                title: Text("Add Category"),
                onTap: () => Navigator.of(context)
                    .pushNamed(AddCategoriesScreen.routeName),
              ),
              // Divider(),
              if(userRole==1||userRole==2)
              ListTile(
                leading: Icon(Icons.account_circle_rounded),
                title: Text("Add Product"),
                onTap: () => Navigator.of(context)
                    .pushNamed(ViewCategoryScreen.routeName),
                // onTap: () =>Navigator.of(context).pushNamed(UserProfilePage.routename),
              ),
              if(userRole==1)
              ListTile(
                leading: Icon(Icons.settings),//ApproveProductCategoryScreen
                title: Text("Approve Product"),
                onTap: () => Navigator.of(context)
                    .pushNamed(ApproveProductCategoryScreen.routeName),              ),
              ListTile(
                leading: Icon(Icons.email_rounded),
                title: Text("Help and Feedback"),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.arrow_forward_ios_rounded),
                title: Text("Logout"),
                onTap: ()=>logoutUser(context),
              ),
              AboutListTile(
                icon: Icon(Icons.info_outline, color: Colors.black),
                applicationLegalese:
                'This Application is designed for business.',
                applicationVersion: '0.0.0.1',
                child: Text('About'),
              )
            ],
          ),
        ),
      ),
    );
  }}
  Future<void> logoutUser(BuildContext context) async {
    bool _logOut = false;
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Logging out'),
        content: Text('Are you sure you want to logout ?'),
        actions: <Widget>[
          TextButton(
            child: Text('No'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
          TextButton(
            child: Text('Yes'),
            onPressed: () {
              _logOut = true;
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
    if (_logOut) {
      FirebaseAuth _auth = FirebaseAuth.instance;
      await _auth.signOut();
      final storage = new FlutterSecureStorage();
      await storage.write(key: "signedIn", value: "false");
      Navigator.of(context)
          .pushNamedAndRemoveUntil(LoginPage.routename, (route) => false);
    }

}
