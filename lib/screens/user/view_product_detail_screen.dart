import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:fluttershop/providers/admin/product_categories.dart';
import 'package:fluttershop/utils/main_appbar.dart';
import 'package:fluttershop/utils/main_drawer.dart';

class ViewProductDetailSceeen extends StatefulWidget {
  const ViewProductDetailSceeen({Key key}) : super(key: key);
  static const routeName = 'view-product-detail-screen';

  @override
  _ViewProductDetailSceeenState createState() =>
      _ViewProductDetailSceeenState();
}

class _ViewProductDetailSceeenState extends State<ViewProductDetailSceeen> {
  final addProductKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> productByCategory = [];
  String orderCurrentStatus = "None";
  String orderFutureStatus = "Place";

  String _chosenCategory;
  String _categoryName = '';
  FocusNode focusNode = FocusNode();
  Map<String, String> orderTrackingStatus = {};
  List<ListTile> orderTile = [];

  final categoryNameController = TextEditingController();
  List<TextEditingController> categoryFieldsController = [];
  List<GlobalKey<FormState>> categoryFieldsKey = [];
  List<Widget> textFields = [];
  // Map<String,dynamic> _categoryFields ={};
  Map<String, dynamic> _productDetails = {};
  String title;
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
    // orderStatus = _productDetails['orderStatus'];
    // index = ModalRoute.of(context).settings.arguments as int;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    index = ModalRoute.of(context).settings.arguments as int;
    fetch();
    super.didChangeDependencies();
  }

  void fetch() async {
    // print(index);
    // await Provider
    //     .of<ProductCategories>(context,listen: false).fetchProductsByCategory(categoryName);
    _productDetails = Provider.of<ProductCategories>(context, listen: false)
        .productByCategory[index];
    orderCurrentStatus = _productDetails["orderCurrentStatus"]??"None";
    Map<String,String> loadedDateTime = {};
    Map<String,dynamic> fetchedMap = _productDetails["orderStatus"]!=null?_productDetails["orderStatus"]:{};
    if(fetchedMap!=null){
      fetchedMap.forEach((key, value) {
        loadedDateTime[key] = value.toString();
      });
    }
    orderTrackingStatus = loadedDateTime;//_productDetails["orderStatus"]!=null?_productDetails["orderStatus"]:{};
    // orderStatus = (_productDetails["orderStatus"] as Map<String, dynamic>).map((key, value) => value.toString());

    print(orderCurrentStatus);
    orderFutureText();
    // print(_productDetails);
    textFields.add(Container(
      alignment: Alignment.center,
      child: Text(
        _productDetails['title'],
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    ));
    textFields.add(ListTile(
      title: Text(
        'Category',
      ),
      trailing: Text(
        _productDetails['categoryname'],
      ),
    ));
    title = _productDetails['title'].toString();
    // _productDetails.remove('categoryname');
    // _productDetails.remove('isapproved');
    // _productDetails.remove('title');
    _productDetails.forEach((key, value) {
      if (key != 'title' && key != 'isapproved' && key != 'categoryname'&&key!="orderStatus") {
        if (key == 'date') {
          textFields.add(Text(
            DateFormat('dd / MM / yyyy').format(_productDetails[key]),
          ));
        } else {
          textFields.add(ListTile(
            leading: Text(key),
            trailing: Text(_productDetails[key]),
          ));
          //
        }
      }
    });
    initOrder();

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
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Product Details ',
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
                        // height: MediaQuery.of(context).size.height * 0.5,
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (ctx, i) =>
                              // leading: CircleAvatar(
                              //   child: Text('T'),
                              // ),
                              textFields[i],
                          // trailing:i==textFields.length-1? IconButton(icon: Icon(Icons.close),onPressed: (){
                          //   setState(() {
                          //     textFields.removeAt(i);
                          //   }
                          //   );
                          // },):SizedBox(height: 2,width: 2,),

                          itemCount: textFields.length,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                        onPressed: updateStatus, child: Text(orderFutureStatus)),
                    SizedBox(
                      height: 20,
                    ),
                    Card(child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (ctx, i) => orderTile[i],
                      itemCount: orderTile.length,
                    ),),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  void updateStatus() {
    List<ListTile> orderTile = [];
    switch (orderFutureStatus) {
      case "Place":
        orderTrackingStatus["Placed"] = DateTime.now().toIso8601String();
        orderCurrentStatus = "Placed";
        orderFutureStatus = "Dispatch";
        break;
      case "Accept":
        orderTrackingStatus["Accept"] = DateTime.now().toIso8601String();
        orderCurrentStatus = "Accept";
        orderFutureStatus = "Dispatch";

        break;
      case "Dispatch":
        orderTrackingStatus["Dispatched"] = DateTime.now().toIso8601String();
        orderCurrentStatus = "Dispatched";
        orderFutureStatus = "Pick Up";

        break;
      case "Deliver":
        orderTrackingStatus["Delivered"] = DateTime.now().toIso8601String();
        orderCurrentStatus = "Delivered";
        orderFutureStatus = "Completed";
        break;

      case "Completed":
        // orderStatus["Delivered"] = DateTime.now().toIso8601String();
        orderCurrentStatus = "Completed";
        orderFutureStatus = "Completed";
        break;
    }
    setState(() {});
    Provider.of<ProductCategories>(context, listen: false).updateStatus(_productDetails['categoryname'], _productDetails, orderTrackingStatus,orderCurrentStatus);


  }

  Widget OrderStatus() {

    return LimitedBox(
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (ctx, i) => orderTile[i],
        itemCount: orderTile.length,
      ),
    );
    // return orderTile;
  }
  void updateOrder(){
    switch (orderCurrentStatus) {
      case "Placed":
        orderTile.add(ListTile(
          title: Text('Placed'),
          trailing: Text(orderTrackingStatus["Placed"]!=null?DateFormat('hh-mm-ss').format(DateTime.parse(orderTrackingStatus["Placed"])):''
          ),
        ));
        break;
      case "Dispatched":
      // orderTile.add(ListTile(
      //   title: Text('Placed'),
      // ));
        orderTile.add(ListTile(
          title: Text('Dispatched'),
          trailing: Text(orderTrackingStatus["Dispatched"]!=null?DateFormat('hh-mm-ss').format(DateTime.parse(orderTrackingStatus["Dispatched"])):''),

        ));
        break;
      case "Picked Up":
      // orderTile.add(ListTile(
      //   title: Text('Placed'),
      // ));
      // orderTile.add(ListTile(
      //   title: Text('Dispatched'),
      // ));
        orderTile.add(ListTile(
          title: Text('Picked Up'),
          trailing: Text(orderTrackingStatus["Picked Up"]!=null?DateFormat('hh-mm-ss').format(DateTime.parse(orderTrackingStatus["Picked Up"])):''),

        ));
        break;
      case "On The Way":
      // orderTile.add(ListTile(
      //   title: Text('Placed'),
      // ));
      // orderTile.add(ListTile(
      //   title: Text('Dispatched'),
      // ));
      // orderTile.add(ListTile(
      //   title: Text('Picked Up'),
      // ));
        orderTile.add(ListTile(
          title: Text('On The Way'),
          trailing: Text(orderTrackingStatus["On The Way"]!=null?DateFormat('hh-mm-ss').format(DateTime.parse(orderTrackingStatus["On The Way"])):''),

        ));
        break;
      case "Delivered":
      // orderTile.add(ListTile(
      //   title: Text('Placed'),
      // ));
      // orderTile.add(ListTile(
      //   title: Text('Dispatched'),
      // ));
      // orderTile.add(ListTile(
      //   title: Text('Picked Up'),
      // ));
      // orderTile.add(ListTile(
      //   title: Text('On The Way'),
      // ));
        orderTile.add(ListTile(
          title: Text('Delivered'),
          trailing: Text(orderTrackingStatus["Delivered"]!=null?DateFormat('hh-mm-ss').format(DateTime.parse(orderTrackingStatus["Delivered"])):''),

        ));
        break;


    }
    setState(() {

    });
  }
  void initOrder() {
    switch (orderCurrentStatus) {
      case "None":
        break;
      case "Placed":
        orderTile.add(ListTile(
          title: Text('Placed'),
          trailing: Text(orderTrackingStatus["Placed"]!=null?DateFormat('dd / mm -- hh-mm-ss').format(DateTime.parse(orderTrackingStatus["Placed"])):''
          ),
        ));
        break;
      case "Dispatched":
      orderTile.add(ListTile(
        title: Text('Placed'),
        trailing: Text(orderTrackingStatus["Placed"]!=null?DateFormat('dd / mm -- hh-mm-ss').format(DateTime.parse(orderTrackingStatus["Placed"])):''),

      ));
        orderTile.add(ListTile(
          title: Text('Dispatched'),
          trailing: Text(orderTrackingStatus["Dispatched"]!=null?DateFormat('hh-mm-ss').format(DateTime.parse(orderTrackingStatus["Dispatched"])):''),

        ));
        break;
      case "Picked Up":
      orderTile.add(ListTile(
        title: Text('Placed'),
        trailing: Text(orderTrackingStatus["Placed"]!=null?DateFormat('dd / MM -- hh-mm-ss').format(DateTime.parse(orderTrackingStatus["Dispatched"])):''),

      ));
      orderTile.add(ListTile(
        title: Text('Dispatched'),
        trailing: Text(orderTrackingStatus["Dispatched"]!=null?DateFormat('dd / MM -- hh-mm-ss').format(DateTime.parse(orderTrackingStatus["Dispatched"])):''),

      ));
        orderTile.add(ListTile(
          title: Text('Picked Up'),
          trailing: Text(orderTrackingStatus["Picked Up"]!=null?DateFormat('dd / MM -- hh-mm-ss').format(DateTime.parse(orderTrackingStatus["Picked Up"])):''),

        ));
        break;
      case "On The Way":
      orderTile.add(ListTile(
        title: Text('Placed'),
        trailing: Text(orderTrackingStatus["Placed"]!=null?DateFormat('hh-mm-ss').format(DateTime.parse(orderTrackingStatus["Dispatched"])):''),

      ));
      orderTile.add(ListTile(
        title: Text('Dispatched'),
        trailing: Text(orderTrackingStatus["Dispatched"]!=null?DateFormat('hh-mm-ss').format(DateTime.parse(orderTrackingStatus["Dispatched"])):''),

      ));
      orderTile.add(ListTile(
        title: Text('Picked Up'),
        trailing: Text(orderTrackingStatus["Picked Up"]!=null?DateFormat('hh-mm-ss').format(DateTime.parse(orderTrackingStatus["Dispatched"])):''),

      ));
        orderTile.add(ListTile(
          title: Text('On The Way'),
          trailing: Text(orderTrackingStatus["On The Way"]!=null?DateFormat('hh-mm-ss').format(DateTime.parse(orderTrackingStatus["On The Way"])):''),

        ));
        break;
      case "Delivered":
      orderTile.add(ListTile(
        title: Text('Placed'),
        trailing: Text(orderTrackingStatus["Placed"]!=null?DateFormat('hh-mm-ss').format(DateTime.parse(orderTrackingStatus["Dispatched"])):''),

      ));
      orderTile.add(ListTile(
        title: Text('Dispatched'),
        trailing: Text(orderTrackingStatus["Dispatched"]!=null?DateFormat('hh-mm-ss').format(DateTime.parse(orderTrackingStatus["Dispatched"])):''),

      ));
      orderTile.add(ListTile(
        title: Text('Picked Up'),
        trailing: Text(orderTrackingStatus["Picked Up"]!=null?DateFormat('hh-mm-ss').format(DateTime.parse(orderTrackingStatus["Dispatched"])):''),

      ));
      orderTile.add(ListTile(
        title: Text('On The Way'),
        trailing: Text(orderTrackingStatus["On The Way"]!=null?DateFormat('hh-mm-ss').format(DateTime.parse(orderTrackingStatus["Dispatched"])):''),

      ));
        orderTile.add(ListTile(
          title: Text('Delivered'),
          trailing: Text(orderTrackingStatus["Delivered"]!=null?DateFormat('hh-mm-ss').format(DateTime.parse(orderTrackingStatus["Delivered"])):''),

        ));
        break;
      default :
        break;
    }
    // return LimitedBox(
    //   child: ListView.builder(
    //     physics: NeverScrollableScrollPhysics(),
    //     shrinkWrap: true,
    //     itemBuilder: (ctx, i) => orderTile[i],
    //     itemCount: orderTile.length,
    //   ),
    // );
    // return orderTile;
  }
  void orderFutureText(){
    switch (orderCurrentStatus) {
      case "Placed":
        orderFutureStatus = "Dispatch";
        break;
      case "Dispatched":
        orderFutureStatus = "Pick Up";

        break;
      case "Picked Up":
        orderFutureStatus = "On The Way";

        break;
      case "On The Way":
        orderFutureStatus = "Deliver";

        break;
      case "Delivered":
        orderFutureStatus = "Completed";
        break;
    }

  }
}
