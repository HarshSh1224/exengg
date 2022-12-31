import 'dart:io';
import 'package:dart_ipify/dart_ipify.dart';
import 'package:exengg/widgets/category_dropdown_button.dart';
import 'package:exengg/widgets/image_picker.dart';
import 'package:exengg/widgets/side_drawer.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';
import './auth_screen.dart';
import '../providers/auth.dart';

class AddItemScreen extends StatefulWidget {
  static const routeName = '/add-item-screen';

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  bool _isLoading = false;
  bool _isUpdate = false;

  var formData = {
    'id': '',
    'categoryId': '',
    'imageUrl': '',
    'title': '',
    'description': '',
    'price': 0.0,
    'phone': '',
    'createDate': '',
    'creatorId': '',
    'creatorIP': ''
  };

  File? _productPic;

  void getDropdownData(String value) {
    print(value);
    if (value == 'Drafter')
      formData['categoryId'] = 'd1';
    else if (value == 'Lab Coat')
      formData['categoryId'] = 'd2';
    else
      formData['categoryId'] = 'd3';
  }

  void getProfilePic(File? profilePic) {
    _productPic = profilePic;
  }

  void _showTickDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        title: Text('Success',
            style: TextStyle(color: Color(0XFFffffff), fontSize: 20)),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Text(
                'Okay',
                style: TextStyle(color: Color(0XFFffffff)),
              )),
        ],
        content: Container(
          // height: 200,
          constraints: BoxConstraints(maxHeight: 270),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/check.gif',
                // height: 100,
                fit: BoxFit.cover,
              ),
              Text(
                _isUpdate
                    ? 'Update Successful'
                    : 'Your item has been successfully added! Now you can view it under the category you selected',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0XFFffffff),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submit() async {
    FocusScope.of(context).unfocus();
    if (!_isUpdate && _productPic == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text('Please pick an image'),
      )));
      return;
    }
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    setState(() {
      _isLoading = true;
    });
    try {
      if (Provider.of<Auth>(context, listen: false).isAuth == false) {
        throw HttpException('Error');
      }
      if (_isUpdate)
        await _updateDataToServer();
      else
        await _addDataToServer();
      _showTickDialog(context);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text('Error Occured!'))));
      Navigator.of(context).pop();
    }
    // print(formData);
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _addDataToServer() async {
    try {
      final authData = await FirebaseFirestore.instance
          .collection('/products/Mf68xktMsq1nObDvCb2F/products')
          .add(formData);
      final documentId = authData.id;

      final ref = await FirebaseStorage.instance
          .ref()
          .child('productImages')
          .child(documentId);
      await ref.putFile(_productPic!);
      final url = await ref.getDownloadURL();
      print(url);

      formData['imageUrl'] = url;
      formData['createDate'] = DateTime.now().toIso8601String();
      formData['creatorId'] =
          Provider.of<Auth>(context, listen: false).getUserId;
      formData['creatorIP'] = await Ipify.ipv4();

      await FirebaseFirestore.instance
          .collection('/products/Mf68xktMsq1nObDvCb2F/products')
          .doc(documentId)
          .set(formData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> _updateDataToServer() async {
    try {
      print('UPDATING PRODUCT');
      final documentId = formData['id'] as String;
      if (_productPic != null) {
        print('UPDATING IMAGE AS WELL');
        final ref = await FirebaseStorage.instance
            .ref()
            .child('productImages')
            .child(documentId);
        await ref.putFile(_productPic!);
        final url = await ref.getDownloadURL();
        print(url);

        formData['imageUrl'] = url;
      }
      // formData['createDate'] = DateTime.now().toIso8601String();
      // formData['creatorId'] =
      //     Provider.of<Auth>(context, listen: false).getUserId;
      // formData['creatorIP'] = await Ipify.ipv4();

      await FirebaseFirestore.instance
          .collection('/products/Mf68xktMsq1nObDvCb2F/products')
          .doc(documentId)
          .set(formData);

      print('UPDATE COMPLETE');
    } catch (error) {
      throw error;
    }
  }

  String _initialValueFromTitle(String title) {
    switch (title) {
      case 'Product Title':
        return formData['title'] as String;
      case 'Description':
        return formData['description'] as String;
      case 'Price':
        return formData['price'].toString();
      case 'Phone Number':
        return formData['phone'] as String;
      default:
        return '';
    }
  }

  Widget _textFormFieldBuilder(
    BuildContext context,
    String title,
    IconData icon,
    TextInputType keyboardType, [
    int? maxLines,
  ]) {
    return TextFormField(
      initialValue: _isUpdate ? _initialValueFromTitle(title) : null,
      maxLength: maxLines == null ? null : 200,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        alignLabelWithHint: true,
        labelText: title,
        labelStyle: TextStyle(
            color: Theme.of(context).colorScheme.onSecondaryContainer),
        border: OutlineInputBorder(),
        prefixIcon: maxLines == null
            ? Icon(icon,
                color: Theme.of(context).colorScheme.onSecondaryContainer)
            : Padding(
                padding: const EdgeInsets.only(bottom: 58),
                child: Icon(
                  icon,
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                ),
              ),
        prefixIconColor: Theme.of(context).colorScheme.onSecondaryContainer,
        // contentPadding: EdgeInsets.symmetric(vertical: ),
      ),
      validator: (value) {
        if (title == 'Product Title' && value!.length < 3) {
          return 'Title should be min 3 characters long';
        }
        if (title == 'Description' && value!.length < 10) {
          return 'Description should be min 10 characters long';
        }
        if (title == 'Price' && double.tryParse(value!) == null) {
          return 'Please enter a valid number';
        }
        if (title == 'Price' && double.parse(value!) < 0) {
          return 'Please enter a valid number';
        }
        if (title == 'Phone Number' && double.tryParse(value!) == null) {
          return 'Please enter a valid phone number';
        }
        if (title == 'Phone Number' && (value!.length != 10)) {
          return 'Phone number has to be 10 digit long';
        }
        return null;
      },
      onSaved: (value) {
        if (title == 'Product Title') formData['title'] = value!;
        if (title == 'Description') formData['description'] = value!;
        if (title == 'Price') formData['price'] = double.parse(value!);
        if (title == 'Phone Number') formData['phone'] = value!;
      },
    );
  }

  GlobalKey<dynamic>? _scaffoldKey = GlobalKey<ScaffoldState>();
  // AddItemScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final argumentsData =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    void Function() toggleTheme = argumentsData['toggle'];
    _isUpdate = argumentsData.containsKey('update') ? true : false;
    if (_isUpdate) {
      formData = {
        'id': argumentsData['update'].id,
        'categoryId': argumentsData['update'].categoryId,
        'imageUrl': argumentsData['update'].imageUrl,
        'title': argumentsData['update'].title,
        'description': argumentsData['update'].description,
        'price': argumentsData['update'].price,
        'phone': argumentsData['update'].phoneNumber,
        'createDate': argumentsData['update'].createDate.toIso8601String(),
        'creatorId': argumentsData['update'].creatorId,
        'creatorIP': argumentsData['update'].creatorIP,
      };
    }

    print(formData);

    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (_, snapshot) {
          return !snapshot.hasData
              ? AuthScreen()
              : !(Provider.of<Auth>(context, listen: false).isAuth)
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          FutureBuilder(
                              future: Future.delayed(Duration(seconds: 3)),
                              builder: (_, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done)
                                  return Padding(
                                    padding: const EdgeInsets.all(28.0),
                                    child: Text(''),
                                    // 'Try Restarting the app. There seems to be a problem with your account. Kindly contact admin or create a new user account.'),
                                  );
                                else
                                  return Text('');
                              })
                        ],
                      ),
                    )
                  : Scaffold(
                      drawer: Drawer(
                        child: SideDrawer(),
                        backgroundColor: Colors.transparent,
                      ),
                      key: _scaffoldKey,
                      body: NestedScrollView(
                          headerSliverBuilder: (context, innerBoxIsScrolled) =>
                              [
                                SliverAppBar(
                                  title: Text(
                                    _isUpdate ? 'Update Item' : 'Add an item',
                                    style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.bold),
                                  ),
                                  leading: IconButton(
                                    icon: Icon(Icons.menu,
                                        size: 35), // change this size and style
                                    onPressed: () => _scaffoldKey!.currentState
                                        ?.openDrawer(),
                                    // onPressed: (() => {}),
                                  ),
                                  elevation: 0,
                                  backgroundColor: Colors.black.withOpacity(0),
                                  actions: [
                                    IconButton(
                                      onPressed: toggleTheme,
                                      icon: Icon(
                                        Icons.light_mode_outlined,
                                        size: 25,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                          body:
                              // StreamBuilder<User?>(
                              //   stream: FirebaseAuth.instance.authStateChanges(),
                              //   builder: (_, snapshot) {
                              //     return !snapshot.hasData
                              //         ? AuthScreen()
                              Form(
                            key: _formKey,
                            child: SingleChildScrollView(
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 30),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 20,
                                    ),
                                    CategoryDropdownButton(
                                        getDropdownData,
                                        _isUpdate
                                            ? formData['categoryId']
                                            : null),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    ImagePickerWidget(
                                        getProfilePic, 10, _isUpdate),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    _textFormFieldBuilder(
                                        context,
                                        'Product Title',
                                        Icons.abc,
                                        TextInputType.text),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    _textFormFieldBuilder(
                                        context,
                                        'Description',
                                        Icons.description_rounded,
                                        TextInputType.multiline,
                                        3),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    _textFormFieldBuilder(
                                        context,
                                        'Price',
                                        Icons.currency_rupee,
                                        TextInputType.number),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    _textFormFieldBuilder(
                                        context,
                                        'Phone Number',
                                        Icons.phone,
                                        TextInputType.number),
                                    SizedBox(
                                      height: 40,
                                    ),
                                    Container(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: Theme.of(context)
                                              .colorScheme
                                              .onPrimary,
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .onPrimaryContainer,
                                        ),
                                        onPressed: _submit,
                                        child: Padding(
                                          padding: const EdgeInsets.all(18.0),
                                          child: _isLoading
                                              ? FittedBox(
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onPrimary,
                                                  ),
                                                )
                                              : Text(
                                                  _isUpdate
                                                      ? 'UPDATE ITEM'
                                                      : 'ADD ITEM',
                                                  style: TextStyle(
                                                    fontFamily: 'Raleway',
                                                    // color: Theme.of(context)
                                                    //     .colorScheme
                                                    //     .primary,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.info_outline,
                                          size: 15,
                                        ),
                                        SizedBox(
                                          width: 3,
                                        ),
                                        Text(
                                          'Double check information before submitting',
                                          style: TextStyle(fontSize: 11),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 60,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )));
        },
      ),
    );
  }
}
