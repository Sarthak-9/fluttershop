import 'package:flutter/material.dart';
import 'package:fluttershop/screens/seller/add_product_screen.dart';
import 'package:fluttershop/utils/main_appbar.dart';
import 'package:fluttershop/utils/main_drawer.dart';
import 'package:provider/provider.dart';
import 'package:fluttershop/providers/admin/product_categories.dart';

class ViewCategoryScreen extends StatefulWidget {
  const ViewCategoryScreen({Key key}) : super(key: key);
  static const routeName = 'view-category-screen';

  @override
  _ViewCategoryScreenState createState() => _ViewCategoryScreenState();
}

class _ViewCategoryScreenState extends State<ViewCategoryScreen> {
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
            height: MediaQuery.of(context).size.height,
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
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (ctx,i)=>Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.send),
                        title: Text(_categories[i]['categoryname'].toString()),
                        onTap: ()=>Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddProductScreen(i)))//Navigator.pushNamed((context)=>AddProductScreen(0));//Navigator.of(context).pushNamed(AddProductScreen.routeName,arguments: i),
                      ),
                      Divider()
                    ],
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
