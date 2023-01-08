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

  void _pickkImage() async {
    _xPickedImage = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: widget.borderRadius < 20 ? 30 : 10);

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
                color: widget.borderRadius == 54
                    ? Theme.of(context).colorScheme.onSurfaceVariant
                    : Theme.of(context).colorScheme.outline,
                // color: Colors.transparent
              ),
              borderRadius:
                  BorderRadius.circular(widget.borderRadius.toDouble()),
              color: widget.borderRadius == 54
                  ? Theme.of(context).colorScheme.surfaceVariant
                  : Theme.of(context).canvasColor,
            ),
          ),
          Positioned.fill(
              child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    splashColor: Colors.white.withOpacity(0.5),
                    borderRadius:
                        BorderRadius.circular(widget.borderRadius.toDouble()),
                    onTap: _pickkImage,
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
}
