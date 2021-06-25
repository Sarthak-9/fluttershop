import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttershop/homepage.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:fluttershop/providers/admin/product_categories.dart';
import 'package:fluttershop/utils/main_appbar.dart';
import 'package:fluttershop/utils/main_drawer.dart';

class ApproveProductFieldDetailScreen extends StatefulWidget {
  // const AddProductScreen({Key key}) : super(key: key);
  static const routeName = 'approve-product-field-detail-screen';
  int categoryIndex;
  // String categoryName;
  ApproveProductFieldDetailScreen(this.categoryIndex);

  @override
  _ApproveProductFieldDetailScreenState createState() => _ApproveProductFieldDetailScreenState();
}

class _ApproveProductFieldDetailScreenState extends State<ApproveProductFieldDetailScreen> {
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
    index = widget.categoryIndex;
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
    // await Provider
    //     .of<ProductCategories>(context,listen: false).fetchProductsForApproval(categoryName);
    _productDetails = Provider
        .of<ProductCategories>(context,listen: false).productForApproval[index];
    // print(_categoryFields);

    textFields.add(Container(
      alignment: Alignment.center,
      child: Text(
          _productDetails['title'].toString(),style: TextStyle(
        fontSize: 22,fontWeight: FontWeight.bold,
      ),
      ),
    ));
    title = _productDetails['categoryname'].toString();
    // _categoryFields.remove('title');
    // _categoryFields.remove('categoryname');
    _productDetails.forEach((key, value) {
      if(value=='date'){
        textFields.add(
            ListTile(title: Text(key),trailing: Text(DateFormat('dd / MM / yyyy').format(_productDetails[key]),),)
      );
      }else{
        if(key != 'title'&&key!='categoryname'&&key!='isapproved'&&key!='firebasekey'){
          textFields.add(
              ListTile(title: Text(key),trailing: Text(_productDetails[key].toString()),));
        }
        }
    });
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
              Text('Approve Product ',style: TextStyle(
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
                      // leading: CircleAvatar(
                      //   child: Text('T'),
                      // ),
                      title: textFields[i],
                      // title: Text(_aprooveRequests[i]['title']),
                      // trailing:i==textFields.length-1? IconButton(icon: Icon(Icons.close),onPressed: (){
                      //   setState(() {
                      //     textFields.removeAt(i);
                      //   }
                      //   );
                      // },):SizedBox(height: 2,width: 2,),
                    ),
                    itemCount: textFields.length,
                  ),
                ),
              ),
              SizedBox(height: 20,),
              ElevatedButton(onPressed: postProduct, child: Text('Approve Product')),
              SizedBox(height: 20,),
            ],
          ),
        ),
      ),
    );
  }
  void postProduct()async{
    // addProductKey.currentState.save();
    // _productDetails['categoryname']=title;
    // _productDetails['isapproved']=false;
    await Provider
        .of<ProductCategories>(context,listen: false).approveProduct(title, _productDetails);
    Navigator.of(context).pushReplacementNamed(HomePage.routeName);

  }
}
