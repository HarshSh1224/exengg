import 'dart:io';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exengg/providers/auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditBottomSheet extends StatefulWidget {
  EditBottomSheet({super.key});

  @override
  State<EditBottomSheet> createState() => _EditBottomSheetState();
}

class _EditBottomSheetState extends State<EditBottomSheet> {
  Auth? auth;
  @override
  void initState() {
    auth = Provider.of<Auth>(context, listen: false);
    super.initState();
  }

  bool _isLoading = false;

  File? _pickedImage;
  XFile? _xPickedImage;
  CroppedFile? _croppedImage;

  Future<void> _cropImage(filePath) async {
    _croppedImage = await ImageCropper().cropImage(
        sourcePath: filePath,
        maxWidth: 1080,
        maxHeight: 1080,
        aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0));
  }

  void _pickkImage() async {
    _xPickedImage = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 10);

    if (_xPickedImage == null) {
      _pickedImage = null;
      return;
    }

    await _cropImage(_xPickedImage!.path);

    setState(() {
      _pickedImage = _croppedImage != null ? File(_croppedImage!.path) : null;
      print('PICKED ${_xPickedImage?.path}');
    });
  }

  Map<String, String?> _formData = {
    'name': null,
    'imageUrl': null,
    'email': null
  };
  final GlobalKey<FormState> _formKey = GlobalKey();

  void _submit() async {
    print('SUBMITTING');
    FocusScope.of(context).unfocus();
    // if (_formData['image'] == null && _formData['name'] == null) {
    //   return;
    // }
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    print(_formData.toString() + _pickedImage.toString());

    setState(() {
      _isLoading = true;
    });
    try {
      if (auth!.isAuth == false) {
        throw HttpException('Error');
      }

      await _updateDataToServer();
      await auth!.tryLogin();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Padding(
              padding: const EdgeInsets.all(10.0), child: Text('Success'))));
      Navigator.of(context).pop();
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

  Future<void> _updateDataToServer() async {
    if (_formData['name'] == auth!.name && _pickedImage == null) {
      print('NO CHANGE');
      return;
    }
    var imageUrl = null;
    try {
      if (_pickedImage != null) {
        print('Changing image');
        final imgRef = await FirebaseStorage.instance
            .ref()
            .child('productImages')
            .child(auth!.userId!);
        await imgRef.putFile(_pickedImage!);
        print('Image changed');
        imageUrl = await imgRef.getDownloadURL();
        // print()
      }
      _formData['email'] = auth!.email;
      _formData['imageUrl'] = auth!.imageUrl;
      if (imageUrl != null) _formData['imageUrl'] = imageUrl;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(auth!.userId)
          .set(_formData);

      print('Set Success' + _formData.toString());
      auth!.name = _formData['name'];
      auth!.imageUrl = _formData['imageUrl'];
    } catch (error) {
      print('Error');
      throw error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
      child: Container(
        padding: MediaQuery.of(context).viewInsets,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          color: Theme.of(context).colorScheme.surfaceVariant,
          // color: Colors.transparent,
        ),
        // height: 220,
        child: Padding(
          padding: EdgeInsets.only(
            left: 30.0,
            right: 30.0,
            bottom: 30,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 7,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    width: 33,
                    height: 4,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Edit your profile',
                      style: TextStyle(
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                      ),
                    ),
                    _isLoading == true
                        ? Center(
                            child: SizedBox(
                              child: CircularProgressIndicator(),
                              height: 25,
                              width: 25,
                            ),
                          )
                        : IconButton(
                            onPressed: _submit,
                            icon: Icon(
                              Icons.done,
                              size: 30,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                            ),
                            constraints: BoxConstraints(),
                            padding: EdgeInsets.all(8),
                          ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 3,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: _pickkImage,
                          child: Card(
                              elevation: 6,
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              child: _pickedImage != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.file(
                                        _pickedImage!,
                                        height: 90,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.all(18.0),
                                      child: Column(
                                        children: [
                                          Icon(
                                            Icons.add_a_photo_rounded,
                                            size: 35,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimaryContainer,
                                          ),
                                          Text(
                                            'New Image',
                                            style: TextStyle(
                                                fontSize: 8,
                                                fontFamily: 'Raleway',
                                                fontWeight: FontWeight.w700,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onPrimaryContainer),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    )),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Change Display Name',
                            style: TextStyle(
                              fontFamily: 'Raleway',
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Container(
                            // width: double.infinity,
                            // width: 200,
                            child: Card(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              margin: EdgeInsets.zero,
                              // color: Color(0xffEEE8F4).withOpacity(1),
                              // elevation: 6,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(3)),
                              child: TextFormField(
                                initialValue: auth?.name,
                                // autofillHints: ['Found a bug', 'Improve the profile page'],
                                style: TextStyle(
                                  fontFamily: 'Raleway',
                                  fontWeight: FontWeight.w700,
                                ),
                                decoration: InputDecoration(
                                  label: Text(
                                    '',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  labelStyle: TextStyle(
                                      fontFamily: 'MoonBold',
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer),
                                  contentPadding: EdgeInsets.only(left: 12),
                                  // floatingLabelStyle: const TextStyle(
                                  //     height: 4, color: Color.fromARGB(255, 160, 26, 179)),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(10)),
                                  // prefixIcon: Icon(
                                  //   Icons.subject_rounded,
                                  //   // color: ,
                                  // ),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Name can\'t be empty';
                                  } else if (value.length > 50) {
                                    return 'Maximum 50 characters allowed';
                                  } else
                                    return null;
                                },
                                onSaved: (value) {
                                  _formData['name'] = value!;
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
