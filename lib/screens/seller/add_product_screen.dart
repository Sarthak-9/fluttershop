import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttershop/homepage.dart';
import 'package:provider/provider.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:fluttershop/providers/admin/product_categories.dart';
import 'package:fluttershop/utils/main_appbar.dart';
import 'package:fluttershop/utils/main_drawer.dart';

class AddProductScreen extends StatefulWidget {
  // const AddProductScreen({Key key}) : super(key: key);
  static const routeName = 'add-product-screen';
  int categoryIndex;

  AddProductScreen(this.categoryIndex);

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  List<Asset> images = <Asset>[];
  String _error = 'No Error Dectect';
  final addProductKey = GlobalKey<FormState>();
  String _chosenCategory;
  String _categoryName = '';
  FocusNode focusNode = FocusNode();
  final categoryNameController = TextEditingController();
  List<TextEditingController> categoryFieldsController = [];
  List<GlobalKey<FormState>> categoryFieldsKey = [];
  List<Widget> textFields = [];
  Map<String, dynamic> _categoryFields = {};
  Map<String, dynamic> _productDetails = {};
  // bool _dateSelected = false;
  var key = GlobalKey();
  bool isLoading = true;
  int index;
  String title;
  final format = DateFormat("dd / MM / yyyy");

  @override
  void initState() {
    // TODO: implement initState
    index = widget.categoryIndex;
    setState(() {
      isLoading = true;
    });
    // index = ModalRoute.of(context).settings.arguments as int;
    fetch();
    super.initState();
  }

  // @override
  // void didChangeDependencies() {
  //   // TODO: implement didChangeDependencies
  //
  //   super.didChangeDependencies();
  // }
  void fetch() async {
    // await Provider
    //     .of<ProductCategories>(context,listen: false).fetchCategory();
    _categoryFields = Provider.of<ProductCategories>(context, listen: false)
        .productCategories[index];
    textFields.add(TextFormField(
      validator: (value){
        if(value==null||value.isEmpty){
          return 'Enter valid data';
        }
        return null;
      },
      textCapitalization: TextCapitalization.words,
      onSaved: (value) {
        _productDetails['title'] = value;
      },
      decoration: InputDecoration(hintText: 'Product Title' //value.toString()
          ),
    ));
    title = _categoryFields['categoryname'].toString();
    // _categoryFields.remove('title');
    // _categoryFields.remove('categoryname');
    _categoryFields.forEach((key, value) {
      if (key != 'title' && key != 'categoryname') {
        if (value == 'date') {
          textFields.add(
            Container(
              alignment: Alignment.center,
              // height: 90,
              // padding: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.grey, width: 2)),
              child: Column(
                children: [
                  Text(key),
                  DateTimeField(
                    textAlign: TextAlign.center,
                    format: format,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                    onShowPicker: (context, currentValue) async {
                            DateTime dateTime;
                            dateTime = await showDatePicker(
                          context: context,
                          firstDate: DateTime(1900),
                          initialDate: currentValue ?? DateTime.now(),
                          lastDate: DateTime(2100));
                      return dateTime;
                      } ,
                    validator: (value){
                      if(value==null){
                        return 'Enter valid data';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      var dt = DateFormat('dd / MM / yyyy').format(value);
                      _productDetails[key] = dt.toString();///.toIso8601String();
                      },
                  ),
                ],
              ),
            ),
          );
        } else {
          textFields.add(TextFormField(
            onSaved: (value) {
              _productDetails[key] = value;
            },
            validator: (value){
              if(value==null||value.isEmpty){
                return 'Enter valid data';
              }
              return null;
            },
            textCapitalization: TextCapitalization.words,
            keyboardType: value == 'text'
                ? TextInputType.text
                : TextInputType.numberWithOptions(),
            decoration: InputDecoration(hintText: key //value.toString()
                ),
          ));
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
        height: MediaQuery.of(context).size.height,
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Add ' + title,
                        style: TextStyle(fontSize: 22),
                      ),
                      // ElevatedButton(onPressed: (), child: child)
                      SizedBox(
                        height: 10,
                      ),
                      Divider(),
                      SizedBox(
                        height: 10,
                      ),


                      Form(
                        key: addProductKey,
                        child: LimitedBox(
                          // height: MediaQuery.of(context).size.height*0.5,
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, i) => ListTile(
                              // leading: CircleAvatar(
                              //   child: Text('T'),
                              // ),
                              title: textFields[i],
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
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                          onPressed: loadAssets,
                          child: Text('Choose Images')),
                      SizedBox(
                        height: 20,
                      ),
                      LimitedBox(
                          // height: 300,
                          child: buildGridView()),
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                          onPressed: postProduct,
                          child: Text('Post for Approval')),
                      SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
            ),
      ),
    );
  }
  Widget buildGridView() {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 3,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return Padding(
          padding: const EdgeInsets.all(2.0),
          child: AssetThumb(
            asset: asset,
            width: 300,
            height: 300,
          ),
        );
      }),
    );
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = <Asset>[];
    String error = 'No Error Detected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 5,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(
          takePhotoIcon: "chat",
          doneButtonTitle: "Fatto",
        ),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "FlutterShop",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }
    if (!mounted) return;

    setState(() {
      images = resultList;
      _error = error;
    });
  }


  void postProduct() async {
    bool isValid = addProductKey.currentState.validate();
    if(!isValid){
      return;
    }
    addProductKey.currentState.save();
    _productDetails['categoryname'] = title;
    _productDetails['isapproved'] = false;
    await Provider.of<ProductCategories>(context, listen: false)
        .addProduct(title, _productDetails);
    Navigator.of(context).pushReplacementNamed(HomePage.routeName);
  }
}
