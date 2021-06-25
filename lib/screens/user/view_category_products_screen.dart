import 'package:flutter/material.dart';
import 'package:fluttershop/screens/user/view_product_detail_screen.dart';
import 'package:provider/provider.dart';
import 'package:fluttershop/providers/admin/product_categories.dart';
import 'package:fluttershop/utils/main_appbar.dart';
import 'package:fluttershop/utils/main_drawer.dart';

class ViewCategoryProducts extends StatefulWidget {
  const ViewCategoryProducts({Key key}) : super(key: key);
  static const routeName = 'view-category-product-screen';

  @override
  _ViewCategoryProductsState createState() => _ViewCategoryProductsState();
}

class _ViewCategoryProductsState extends State<ViewCategoryProducts> {
  final addProductKey = GlobalKey<FormState>();
  List<Map<String,dynamic>> productByCategory = [];

  String _chosenCategory;
  String _categoryName='';
  FocusNode focusNode = FocusNode();
  final categoryNameController = TextEditingController();
  List<TextEditingController> categoryFieldsController = [];
  List<GlobalKey<FormState>> categoryFieldsKey = [];
  List<Widget> textFields = [];
  Map<String,dynamic> _categoryFields ={};
  Map<String,dynamic> _productDetails ={};

  bool isLoading = true;
  int index;
  String categoryName;

  @override
  void initState() {
    // TODO: implement initState
    // index = widget.categoryIndex;
    setState(() {
      isLoading = true;
    });
    // index = ModalRoute.of(context).settings.arguments as int;
    super.initState();
  }
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    categoryName = ModalRoute.of(context).settings.arguments as String;
    fetch();

    super.didChangeDependencies();
  }
  void fetch()async{
    await Provider
        .of<ProductCategories>(context,listen: false).fetchProductsByCategory(categoryName);
    productByCategory = Provider
        .of<ProductCategories>(context,listen: false).productByCategory;
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
        // height: MediaQuery.of(context).size.height,
        child:isLoading?Center(child: CircularProgressIndicator(),): SingleChildScrollView(
          child: Column(
            children: [
              // Icon(Icons.verified_user)
              SizedBox(height: 20,),
              Text('Products',style: TextStyle(
                  fontSize: 22
              ),),
              // ElevatedButton(onPressed: (), child: child)
              SizedBox(height: 10,),
              Divider(),
              // SizedBox(height: 10,),
              LimitedBox(
                // height: 500,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (ctx,i)=>Column(
                  children: [
                    ListTile(
                        leading: Icon(Icons.send),
                        title: Text(productByCategory[i]['title'].toString()),
                        onTap: ()=>Navigator.of(context).pushNamed(ViewProductDetailSceeen.routeName,arguments: i)//Navigator.pushNamed((context)=>AddProductScreen(0));//Navigator.of(context).pushNamed(AddProductScreen.routeName,arguments: i),
                    ),
                    Divider()
                  ],
                ),
                  itemCount: productByCategory.length,

                ),
              ),
              SizedBox(
                height: 30,
              )
            ],
          ),
        ),
      ),
    );
  }
}
