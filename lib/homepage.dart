import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttershop/screens/user/view_category_products_screen.dart';
import 'package:provider/provider.dart';
import 'package:fluttershop/utils/main_appbar.dart';
import 'package:fluttershop/utils/main_drawer.dart';

import 'providers/admin/product_categories.dart';
import 'screens/seller/add_product_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);
  static const routeName = 'home-page';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override

  List<Map<String,dynamic>> _categories = [];
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      isLoading = true;
    });
    fetch();
    super.initState();
  }
  void fetch()async{
    await Provider
        .of<ProductCategories>(context,listen: false).fetchCategory();
    _categories = Provider
        .of<ProductCategories>(context,listen: false).productCategories;
    setState(() {
      isLoading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(),
      drawer: MainDrawer(),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: isLoading?Center(child: CircularProgressIndicator(),):SingleChildScrollView(
          child: Container(
            // height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                SizedBox(height: 20,),
                Text('Categories',style: TextStyle(
                    fontSize: 22
                ),),
                // ElevatedButton(onPressed: (), child: child)
                SizedBox(height: 10,),
                Divider(),
                // SizedBox(height: 10,),
                LimitedBox(
                  child: GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    // scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2),
                    itemBuilder: (ctx,i)=>GestureDetector(
                      onTap: ()=>Navigator.of(context).pushNamed(ViewCategoryProducts.routeName,arguments:_categories[i]['categoryname'].toString()),//Navigator.pushNamed((context)=>AddProductScreen(0));//Navigator.of(context).pushNamed(AddProductScreen.routeName,arguments: i),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0,horizontal: 4.0),
                        child: Card(
                          shadowColor: Theme.of(context).primaryColor,
                          elevation: 5.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Container(
                            // padding: EdgeInsets.symmetric(vertical: 8.0),
                            height: 80,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: Theme.of(context).primaryColor, width: 2)),
                            // leading: Icon(Icons.send),
                              child: Text(_categories[i]['categoryname'].toString()),
                          ),
                        ),
                      ),
                    ),
                    itemCount: _categories.length,
                  ),
                ),
                SizedBox(height: 30,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
