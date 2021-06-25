import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';


class ProductCategories with ChangeNotifier{
  List<Map<String,dynamic>> _productCategories = [];
  List<Map<String,dynamic>> _productByCategory = [];
  List<Map<String,dynamic>> _productForApproval = [];

  List<Map<String, dynamic>> get productByCategory => _productByCategory;
  List<Map<String, dynamic>> get productForApproval => _productForApproval;
  List<Map<String, dynamic>> get productCategories => _productCategories;

  final firestoreInstance = FirebaseFirestore.instance;
  Future<void> addCategory(String categoryName,Map<String,dynamic> categoryFields)async{
    print(categoryName);
    // await firestoreInstance.collection("categorieslist").doc(categoryName).set(data);
    await firestoreInstance.collection("categories").doc(categoryName).set(categoryFields);
  }
  Future<void> fetchCategory()async{
    List<Map<String,dynamic>> loadedCategories = [];

    // print(categoryName);
    final ref = await firestoreInstance.collection("categories").get();//.doc(categoryName).set(categoryFields);
    ref.docs.forEach((element) {
      Map<String,dynamic> loadedMap = {};
      loadedMap = element.data();//values.forEach((element) {element.toString();});
      loadedMap['firebasekey'] = element.id;

      // element.data().forEach((key, value) {
      //
      // });
      // print(loadedMap);
      loadedCategories.add(loadedMap);
    });
    _productCategories = loadedCategories;
  }
  // final firestoreInstance = FirebaseFirestore.instance;
  Future<void> addProduct(String productName,Map<String,dynamic> productFields)async{
    print(productName);
    await firestoreInstance.collection("products").doc(productName).collection(productName).add(productFields);
  }

  Future<void> fetchProductsByCategory(String category)async{
    List<Map<String,dynamic>> loadedProducts = [];
    print(category);
    // print(categoryName);
    final ref = await firestoreInstance.collection("products").doc(category).collection(category).get();//.doc(categoryName).set(categoryFields);
    ref.docs.forEach((element) {
      Map<String,DateTime> loadedDateTime = {};
      Map<String,dynamic> fetchedMap = element.data()['orderStatus'];
      if(fetchedMap!=null){
        fetchedMap.forEach((key, value) {
          loadedDateTime[key] = DateTime.parse(value);
        });
      }
      Map<String,dynamic> loadedMap = {};
      print(element.data()['isapproved']);
        if(element.data()['isapproved']==true) {
          loadedMap = element.data();
          loadedMap['firebasekey'] = element.id;
          // loadedMap["orderStatus"] = loadedDateTime;
          loadedProducts.add(loadedMap);
        print(loadedMap['firebasekey']);
      }
    });
    _productByCategory = loadedProducts;
    print(_productByCategory);
  }
  Future<void> fetchProductsForApproval(String category)async{
    List<Map<String,dynamic>> loadedProducts = [];
    // print(categoryName);
    final ref = await firestoreInstance.collection("products").doc(category).collection(category).get();//.doc(categoryName).set(categoryFields);
    ref.docs.forEach((element) {
      Map<String,dynamic> loadedMap = {};
      if(element.data()['isapproved']==false) {
        loadedMap = element.data(); //values.forEach((element) {element.toString();});
        loadedMap['firebasekey'] = element.id;
        loadedProducts.add(loadedMap);
      }
    });
    _productForApproval = loadedProducts;
    print(_productForApproval);
  }
  Future<void> approveProduct(String category,Map<String,dynamic> productMap)async{
    List<Map<String,dynamic>> loadedProducts = [];
    // print(categoryName);
    final ref = firestoreInstance.collection("products").doc(category).collection(category).doc(productMap['firebasekey']);
    await ref.update({
      'isapproved': true
    });
    //.doc(categoryName).set(categoryFields);
    // ref.docs.forEach((element) {
    //   Map<String,dynamic> loadedMap = {};
    //   if(element.data()['isapproved']==false) {
    //     loadedMap = element.data(); //values.forEach((element) {element.toString();});
    //     loadedMap['firebasekey'] = element.id;
    //     loadedProducts.add(loadedMap);
    //   }
    // });
    // _productForApproval = loadedProducts;
    // print(_productForApproval);
  }
  Future<void> updateStatus(String category,Map<String,dynamic> productMap, Map<String, String> status,String orderCurrentStatus)async{
    List<Map<String,dynamic>> loadedProducts = [];
    // print(categoryName);
    final ref = firestoreInstance.collection("products").doc(category).collection(category).doc(productMap['firebasekey']);//.collection("orderStatus");//.add({        status:DateTime.now().toIso8601String()
    // });
    print(status);
    print(category);
    print(productMap['firebasekey']);
    await ref.update({
      // "orderStatus":
      "orderCurrentStatus":orderCurrentStatus,
        "orderStatus":status//{status:DateTime.now().toIso8601String()}
    });
    //.doc(categoryName).set(categoryFields);
    // ref.docs.forEach((element) {
    //   Map<String,dynamic> loadedMap = {};
    //   if(element.data()['isapproved']==false) {
    //     loadedMap = element.data(); //values.forEach((element) {element.toString();});
    //     loadedMap['firebasekey'] = element.id;
    //     loadedProducts.add(loadedMap);
    //   }
    // });
    // _productForApproval = loadedProducts;
    // print(_productForApproval);
  }
  void findCategoryById()async{

  }

}