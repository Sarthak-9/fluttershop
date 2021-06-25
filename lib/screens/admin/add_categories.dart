import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttershop/homepage.dart';
import 'package:fluttershop/providers/admin/product_categories.dart';
import 'package:provider/provider.dart';
import 'package:fluttershop/utils/main_appbar.dart';
import 'package:fluttershop/utils/main_drawer.dart';

class AddCategoriesScreen extends StatefulWidget {
  const AddCategoriesScreen({Key key}) : super(key: key);
  static const routeName = 'admin-add-category-screen';

  @override
  _AddCategoriesScreenState createState() => _AddCategoriesScreenState();
}

class _AddCategoriesScreenState extends State<AddCategoriesScreen> {
  final addCategoryKey = GlobalKey<FormState>();
  String _chosenCategory;
  String _categoryName = '';
  FocusNode focusNode = FocusNode();
  final categoryNameController = TextEditingController();
  List<TextEditingController> categoryFieldsController = [];
  List<GlobalKey<FormState>> categoryFieldsKey = [];
  List<Widget> textFields = [];
  Map<String, dynamic> _categoryFields = {};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(),
      drawer: MainDrawer(),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: SingleChildScrollView(
          child: Form(
            key: addCategoryKey,
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Add Category',
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
                TextFormField(
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(hintText: 'Category Name'),
                  focusNode: focusNode,
                  controller: categoryNameController,
                  onSaved: (value) {
                    // print(value);
                    // _categoryFields[value] = 'text';

                    _categoryFields['categoryname'] = value;
                    _categoryFields['title'] = 'text';
                    _categoryFields['image'] = 'imageurl';

                    _categoryName = value;
                    // print(_categoryName);
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter valid data';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Text('** Product title is the default added field'),
                // TextFormField(
                //   textCapitalization: TextCapitalization.words,
                //   decoration: InputDecoration(
                //       hintText: 'Product Title'
                //   ),
                //   // focusNode: focusNode,
                //   // controller: categoryNameController,
                //   onSaved: (value){
                //     print(value);
                //     // _categoryFields[value] = '';
                //     _categoryFields['title'] = 'text';
                //     // _categoryName = value;
                //     // print(_categoryName);
                //   },
                //   validator: (value) {
                //     if (value.isEmpty) {
                //       return 'Please enter valid data';
                //     }
                //     return null;
                //   },
                // ),
                SizedBox(
                  height: 20,
                ),
                DropdownButton<String>(
                  value: _chosenCategory,
                  underline: Container(
                    color: Colors.blue,
                  ),
                  style: TextStyle(color: Colors.teal),
                  items: <String>[
                    'Text',
                    'Number',
                    'Date',
                    // 'Sad',
                    // 'Depressed',
                    // 'Neutral',
                    // 'No Filters'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(color: Colors.black, fontSize: 18.0),
                      ),
                    );
                  }).toList(),
                  hint: Text(
                    "Add Field",
                    style: TextStyle(
                        color: Colors.teal,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                  onChanged: (String field) async {
                    String catField = field;
                    // var controllername = catField+categoryFieldsController.length.toString();
                    // final TextEditingController controllernam = TextEditingController();
                    // categoryFieldsController.add(controllername);
                    setState(() {
                      // _chosenValue = mood;
                      // isSorting = true;
                    });
                    switch (catField) {
                      case 'Text':
                        textFields.add(
                          TextFormField(
                            textCapitalization: TextCapitalization.words,
                            // keyboardType: TextInputType.text,
                            decoration: InputDecoration(hintText: 'Enter Text'),
                            onSaved: (value) {
                              bool existing =
                                  !_categoryFields.containsKey(value);
                              print(_categoryFields[value]);
                              if (existing) {
                                _categoryFields[value] = 'text';
                              }
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter valid data';
                              }
                              // bool existing = _categoryFields.containsKey(value);
                              // if (existing) {
                              //   return 'Choose unique field name';
                              // }
                              return null;
                            },
                          ),
                        );
                        break;
                      case 'Number':
                        textFields.add(
                          // leading: CircleAvatar(
                          //   child: Text('N'),
                          // ),
                          TextFormField(
                            textCapitalization: TextCapitalization.words,
                            // keyboardType: TextInputType.numberWithOptions(),
                            decoration:
                                InputDecoration(hintText: 'Enter Number'),
                            onSaved: (value) {
                              bool existing =
                                  !_categoryFields.containsKey(value);
                              if (existing) {
                                _categoryFields[value] = 'number';
                              }
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter valid data';
                              }
                              // bool existing = _categoryFields.containsKey(value);
                              // if (existing) {
                              //   return 'Choose unique field name';
                              // }
                              return null;
                            },
                            // autofocus: true,
                          ),
                        );
                        break;
                      case 'Date':
                        textFields.add(
                          // leading: CircleAvatar(
                          //   child: Text('D'),
                          // ),
                          TextFormField(
                            textCapitalization: TextCapitalization.words,
                            // keyboardType: TextInputType.numberWithOptions(),
                            decoration: InputDecoration(hintText: 'Enter Date'),
                            onSaved: (value) {
                              bool existing =
                                  !_categoryFields.containsKey(value);
                              if (existing) {
                                _categoryFields[value] = 'date';
                              }
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter valid data';
                              }
                              // bool existing = _categoryFields.containsKey(value);
                              // if (existing) {
                              //   return 'Choose unique field name';
                              // }
                              return null;
                            },
                            // autofocus: true,
                          ),
                        );
                        break;
                      default:
                        textFields.add(
                          // leading: CircleAvatar(
                          //   child: Text('T'),
                          // ),
                          TextFormField(
                            textCapitalization: TextCapitalization.words,
                            // keyboardType: TextInputType.numberWithOptions(),
                            decoration: InputDecoration(hintText: 'Enter Text'),
                            onSaved: (value) {
                              bool existing =
                                  !_categoryFields.containsKey(value);
                              if (existing) {
                                _categoryFields[value] = 'number';
                              }
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter valid data';
                              }
                              // bool existing = _categoryFields.containsKey(value);
                              // if (existing) {
                              //   return 'Choose unique field name';
                              // }
                              return null;
                            },
                          ),
                        );
                        break;
                    }
                    // textFields.add(TextFormField());
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                LimitedBox(
                  // height: 300,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (ctx, i) => ListTile(
                      // leading: CircleAvatar(
                      //   child: Text('T'),
                      // ),
                      title: textFields[i],
                      trailing: i == textFields.length - 1
                          ? IconButton(
                              icon: Icon(Icons.close),
                              onPressed: () {
                                setState(() {
                                  textFields.removeAt(i);
                                });
                              },
                            )
                          : SizedBox(
                              height: 2,
                              width: 2,
                            ),
                    ),
                    itemCount: textFields.length,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: postCategory, child: Text('Post Category')),
                SizedBox(
                  height: 20,
                ),
                // ],
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void postCategory() async {
    bool isValid = addCategoryKey.currentState.validate();
    if (!isValid) {
      return;
    }
    addCategoryKey.currentState.save();

    // print(_categoryFields);
    Provider.of<ProductCategories>(context, listen: false)
        .addCategory(categoryNameController.text, _categoryFields);
    Navigator.of(context).pushReplacementNamed(HomePage.routeName);
  }
}
