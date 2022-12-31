import 'package:flutter/material.dart';

class ColorPickerDialog extends StatelessWidget {
  void Function(Color) _changeBrandColor;
  ColorPickerDialog(this._changeBrandColor);

  Widget _listTileBuilder(BuildContext context, String title, Color color) {
    return ListTile(
      onTap: () {
        _changeBrandColor(color);
        Navigator.of(context).pop();
      },
      leading: Icon(
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
    return AlertDialog(
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _listTileBuilder(context, 'Blue', Color(0XFF2196F3)),
            _listTileBuilder(context, 'Purple', Color(0XFF6750A4)),
            _listTileBuilder(context, 'Teal', Color(0XFF009688)),
            _listTileBuilder(context, 'Green', Color(0XFF4CAF50)),
            _listTileBuilder(context, 'Yellow', Color(0XFFFFEB3B)),
            _listTileBuilder(context, 'Orange', Color(0XFFFF9800)),
            _listTileBuilder(context, 'Pink', Color(0XFFE91E63)),
          ],
        ),
      ),
    );
  }
}
