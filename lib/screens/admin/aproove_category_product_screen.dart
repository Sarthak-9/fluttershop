import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttershop/providers/admin/product_categories.dart';
import 'package:fluttershop/utils/main_appbar.dart';
import 'package:fluttershop/utils/main_drawer.dart';

import 'approve_product_field_detail_screen.dart';

class ApproveCategoryProductDetailScreen extends StatefulWidget {
  // const AddProductScreen({Key key}) : super(key: key);
  static const routeName = 'approve-category-product-detail-screen';
  // int categoryIndex;
  String categoryName;
  ApproveCategoryProductDetailScreen(this.categoryName);

  @override
  _ApproveCategoryProductDetailScreenState createState() => _ApproveCategoryProductDetailScreenState();
}

class _ApproveCategoryProductDetailScreenState extends State<ApproveCategoryProductDetailScreen> {
  final addProductKey = GlobalKey<FormState>();
  String _chosenCategory;
  String _categoryName='';
  FocusNode focusNode = FocusNode();
  final categoryNameController = TextEditingController();
  List<TextEditingController> categoryFieldsController = [];
  List<GlobalKey<FormState>> categoryFieldsKey = [];
  List<Widget> textFields = [];
  List<Map<String,dynamic>> _aprooveRequests = [];

  Map<String,dynamic> _categoryFields ={};
  Map<String,dynamic> _productDetails ={};

  bool isLoading = true;
  int index;
  String title;
  String categoryName ;

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      isLoading = true;
    });
    categoryName = widget.categoryName;
    super.initState();
  }
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    // index = ModalRoute.of(context).settings.arguments as int;
    fetch();
    super.didChangeDependencies();
  }
  void fetch()async{
    // print(index);
    await Provider
        .of<ProductCategories>(context,listen: false).fetchProductsForApproval(categoryName);
    _aprooveRequests = Provider
        .of<ProductCategories>(context,listen: false).productForApproval;
    // print(_categoryFields);
    // textFields.add(TextFormField(
    //   onSaved: (value){
    //     _productDetails['title'] = value;
    //   },
    //   decoration: InputDecoration(
    //       hintText: 'Product Title'//value.toString()
    //   ),
    // ));
    // title = _categoryFields['categoryname'].toString();
    // // _categoryFields.remove('title');
    // // _categoryFields.remove('categoryname');
    // _categoryFields.forEach((key, value) {
    //
    //   if(value=='date'){
    //     textFields.add(OutlinedButton(
    //       child: Text(key),
    //     ));
    //   }else{
    //     if(key != 'title'&&key!='categoryname'){
    //       textFields.add(
    //           ListTile(title: Text(key),trailing: Text(_productDetails[key]),));
    //     }
    //     }
    // });
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
              SizedBox(height: 20,),
              Text('Products ',style: TextStyle(
                  fontSize: 22
              ),),
              // ElevatedButton(onPressed: (), child: child)
              SizedBox(height: 10,),
              Divider(),
              SizedBox(height: 10,),
              Form(
                key: addProductKey,
                child: LimitedBox(
                  // height: MediaQuery.of(context).size.height*0.5,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (ctx,i)=>ListTile(
                      leading: Icon(Icons.send),
                      title: Text(_aprooveRequests[i]['title']),
                        onTap: ()=>Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ApproveProductFieldDetailScreen(i))//Navigator.pushNamed((context)=>AddProductScreen(0));//Navigator.of(context).pushNamed(AddProductScreen.routeName,arguments: i),
                    ),
                      // onTap: ()=>Navigator.of(context).pushNamed(ApproveProductFieldDetailScreen.routeName),
                      // trailing:i==textFields.length-1? IconButton(icon: Icon(Icons.close),onPressed: (){
                      //   setState(() {
                      //     textFields.removeAt(i);
                      //   }
                      //   );
                      // },):SizedBox(height: 2,width: 2,),
                    ),
                    itemCount: _aprooveRequests.length,
                  ),
                ),
              ),
              SizedBox(height: 20,),
              // ElevatedButton(onPressed: postProduct, child: Text('Post for approval')),
              SizedBox(height: 30,),
            ],
          ),
        ),
      ),
    );
  }
  void postProduct()async{
    addProductKey.currentState.save();
    _productDetails['categoryname']=title;
    _productDetails['isapproved']=false;
    await Provider
        .of<ProductCategories>(context,listen: false).addProduct(title, _productDetails);
  }
}
