import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class ImagePickerWidget extends StatefulWidget {
  final Function(File?) getProfilePic;
  int borderRadius;
  bool comingFromUpdate;
  ImagePickerWidget(
    this.getProfilePic, [
    this.borderRadius = 55,
    this.comingFromUpdate = false,
  ]);

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  File? _pickedImage;
  XFile? _xPickedImage;
  CroppedFile? _croppedImage;

  Future<void> _cropImage(filePath) async {
    _croppedImage = await ImageCropper().cropImage(
      sourcePath: filePath,
      maxWidth: 1080,
      maxHeight: 1080,
      aspectRatio: widget.borderRadius >= 55
          ? CropAspectRatio(ratioX: 1.0, ratioY: 1.0)
          : CropAspectRatio(ratioX: 4.0, ratioY: 3.0),
    );
  }

  void _pickkImage(ImageSource source) async {
    _xPickedImage = await ImagePicker().pickImage(
        source: source, imageQuality: widget.borderRadius < 20 ? 30 : 10);

    if (_xPickedImage == null) {
      _pickedImage = null;
      return;
    }

    await _cropImage(_xPickedImage!.path);

    setState(() {
      _pickedImage = _croppedImage != null ? File(_croppedImage!.path) : null;
      print('PICKED ${_xPickedImage?.path}');
    });
    widget.getProfilePic(_pickedImage);
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: Stack(
        children: [
          Container(
            height: widget.borderRadius == 54
                ? 90
                : (widget.borderRadius != 10 ? 110 : 210),
            width: widget.borderRadius == 54
                ? 90
                : (widget.borderRadius != 10 ? 110 : double.infinity),
            // child: Image.asset('assets/images/add_image.png'),
            child: _pickedImage != null
                ? Image.file(
                    _pickedImage!,
                    fit: BoxFit.cover,
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.add_a_photo,
                          size: widget.borderRadius == 54 ? 35 : 50,
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer
                          // color: Theme.of(context).colorScheme.onSecondaryContainer,
                          ),
                      Text(
                        widget.borderRadius == 54
                            ? 'Add new image'
                            : (widget.borderRadius < 50
                                ? 'Add an Image'
                                : 'Add image'),
                        style: TextStyle(
                            fontSize: widget.borderRadius == 54 ? 8 : 9,
                            fontFamily: 'Raleway',
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer),
                        textAlign: TextAlign.center,
                      ),
                      if (widget.borderRadius < 50 && widget.comingFromUpdate)
                        Text(
                          'Leave this empty if you dont want\nto update your existing image',
                          style: TextStyle(
                            // fontf
                            fontSize: 9,
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                          ),
                          textAlign: TextAlign.center,
                        ),
                    ],
                  ),
            decoration: BoxDecoration(
              border: Border.all(
                width: _pickedImage == null ? 1 : 0,
                color: Theme.of(context).colorScheme.outline,
                // color: Colors.transparent
              ),
              borderRadius:
                  BorderRadius.circular(widget.borderRadius.toDouble()),
              color: Theme.of(context).canvasColor,
            ),
          ),
          Positioned.fill(
              child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    splashColor: Colors.white.withOpacity(0.5),
                    borderRadius:
                        BorderRadius.circular(widget.borderRadius.toDouble()),
                    onTap: () async {
                      int sourceChoice = -1;
                      await showModalBottomSheet(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20)),
                          ),
                          context: context,
                          builder: (_) {
                            return Container(
                              height: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20)),
                                color: Theme.of(context)
                                    .colorScheme
                                    .surfaceVariant,
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 30),
                              child: Column(
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
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                      ),
                                      width: 33,
                                      height: 4,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 25,
                                  ),
                                  Text(
                                    'Pick image from:',
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSecondaryContainer,
                                        fontSize: 17,
                                        fontFamily: 'Raleway',
                                        fontWeight: FontWeight.w800),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    children: [
                                      Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                              onTap: () {
                                                sourceChoice = 0;
                                                Navigator.of(context).pop();
                                              },
                                              child: imageSourceChoiceBuilder(
                                                  context, 0))),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                              onTap: () {
                                                sourceChoice = 1;
                                                Navigator.of(context).pop();
                                              },
                                              child: imageSourceChoiceBuilder(
                                                  context, 1)))
                                    ],
                                  )
                                ],
                              ),
                            );
                          });
                      if (sourceChoice != -1)
                        _pickkImage(sourceChoice == 0
                            ? ImageSource.camera
                            : ImageSource.gallery);
                    },
                  ))),
          if (_pickedImage != null && widget.borderRadius < 20)
            Positioned(
              child: CircleAvatar(
                backgroundColor: Colors.black.withOpacity(0.3),
                child: IconButton(
                  icon: Icon(Icons.close),
                  color: Colors.white,
                  onPressed: () {
                    setState(() {
                      _pickedImage = null;
                      _xPickedImage = null;
                      widget.getProfilePic(null);
                    });
                  },
                ),
              ),
              top: 15,
              right: 15,
            ),
        ],
      ),
      borderRadius: BorderRadius.circular(widget.borderRadius.toDouble()),
    );
  }

  Container imageSourceChoiceBuilder(BuildContext context, int choice) {
    return Container(
      decoration: BoxDecoration(
          // color: Theme.of(context)
          //     .colorScheme
          //     .onSurfaceVariant,
          border: Border.all(color: Theme.of(context).colorScheme.primary),
          borderRadius: BorderRadius.circular(10)),
      height: 80,
      width: 80,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            choice == 0 ? Icons.camera_alt : Icons.photo_library,
            size: 40,
            color: Theme.of(context).colorScheme.primary,
          ),
          Text(
            choice == 0 ? 'Camera' : 'Gallery',
            style: TextStyle(
                fontFamily: 'Raleway',
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.primary,
                fontSize: 10),
          ),
        ],
      ),
    );
  }
}
