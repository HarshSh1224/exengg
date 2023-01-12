import 'package:exengg/main.dart';
import 'package:flutter/material.dart';

class ColorPickerDialog extends StatelessWidget {
  void Function(Color) _changeBrandColor;
  ColorPickerDialog(this._changeBrandColor);

  // @override
  // void didChangeDependencies() {
  //   brandColor = widget.brand;
  //   super.didChangeDependencies();
  // }

  Widget _listTileBuilder(BuildContext context, String title, Color color) {
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      onTap: () {
        _changeBrandColor(color);
        Navigator.of(context).pop();
      },
      leading:
          //  CircleAvatar(
          //   backgroundColor: color,
          // ),
          Icon(
        Icons.color_lens_outlined,
        color: color,
        size: 30,
      ),
      title: Text(
        title,
        style: TextStyle(color: color),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('BUILDING COLOR PICKER');

    return AlertDialog(
      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      // contentPadding: EdgeInsets.only(top: 20),
      // backgroundColor: Color(0xff0D111A),
      backgroundColor: Theme.of(context).canvasColor,
      content: SingleChildScrollView(
        child: Column(children: [
          _listTileBuilder(context, 'Blue', Color(0xFF2196F3)),
          _listTileBuilder(context, 'Purple', Color(0xFF6750A4)),
          _listTileBuilder(context, 'Teal', Color(0xFF009688)),
          _listTileBuilder(context, 'Pink', Color(0xFFE91E63)),
          _listTileBuilder(context, 'Yellow', Color(0xFFFFEB3B)),
          _listTileBuilder(context, 'Green', Color(0xFF4CAF50)),
          _listTileBuilder(context, 'Orange', Color(0xFFFF9800)),
        ]),
      ),
    );
  }
}
