import 'package:exengg/main.dart';
import 'package:flutter/material.dart';

class ColorPickerDialog extends StatefulWidget {
  void Function(Color) _changeBrandColor;
  final brand;
  ColorPickerDialog(this._changeBrandColor, this.brand);

  @override
  State<ColorPickerDialog> createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<ColorPickerDialog> {
  Color brandColor = Color(0xFF2196F3);

  @override
  void initState() {
    brandColor = brand;
    super.initState();
  }

  // @override
  // void didChangeDependencies() {
  //   brandColor = widget.brand;
  //   super.didChangeDependencies();
  // }

  Widget _listTileBuilder(BuildContext context, String title, Color color) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: Colors.white,
          onTap: () {
            setState(() {
              print('SETSTATE COLOR PICKER');
              widget._changeBrandColor(color);
              brandColor = color;
            });
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 5),
            height: 122,
            child: Column(
              children: [
                // CircleAvatar(
                //   backgroundColor: color == brandColor
                //       ? Theme.of(context).colorScheme.onPrimaryContainer
                //       : color,
                //   radius: 25,
                //   child: color == brandColor
                //       ? CircleAvatar(
                //           radius: 20,
                //           backgroundColor: color,
                //         )
                //       : null,
                // ),
                Stack(
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: color == brandColor
                            ? Theme.of(context).colorScheme.onPrimaryContainer
                            : color,
                      ),
                    ),
                    if (color == brandColor)
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.center,
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor: color,
                          ),
                        ),
                      )
                  ],
                ),
                SizedBox(
                  height: 2,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                    color: color == brandColor
                        ? Theme.of(context).colorScheme.onPrimaryContainer
                        : color,
                  ),
                  height: 70,
                  width: 50,
                  // padding: EdgeInsets.only(bottom: 12),
                  alignment: Alignment.bottomCenter,
                  child: color != brandColor
                      ? null
                      : Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                            color: color,
                          ),
                          height: 65,
                          width: 40,
                        ),
                  // child: Transform.rotate(
                  //   angle: math.pi / 2,
                  //   child: Text(
                  //     title,
                  //     style: TextStyle(
                  //         fontFamily: 'MoonBold', fontSize: 15, color: Colors.white),
                  //   ),
                  // ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    // return ListTile(
    //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    //   onTap: () {
    //     _changeBrandColor(color);
    //     Navigator.of(context).pop();
    //   },
    //   leading:
    //       //  CircleAvatar(
    //       //   backgroundColor: color,
    //       // ),
    //       Icon(
    //     Icons.color_lens_outlined,
    //     color: color,
    //     size: 30,
    //   ),
    //   title: Text(
    //     title,
    //     style: TextStyle(color: color),
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    print('BUILDING COLOR PICKER');

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      contentPadding: EdgeInsets.only(top: 20),
      // backgroundColor: Color(0xff0D111A),
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      content: Stack(
        children: [
          Positioned(
            top: 0,
            right: 10,
            child: IconButton(
              padding: EdgeInsets.all(7),
              constraints: BoxConstraints(),
              style: IconButton.styleFrom(
                  backgroundColor: Colors.black.withOpacity(0.2)),
              onPressed: Navigator.of(context).pop,
              icon: Icon(
                Icons.close_rounded,
                size: 17,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Container(
            // color: Colors.red,
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(maxHeight: 210),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 23.0),
                  child: Text(
                    'Pick a color',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        fontFamily: 'Raleway',
                        fontSize: 30,
                        fontWeight: FontWeight.w800),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 23.0),
                  child: Text(
                    'Choose your accent color',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontFamily: 'MoonBold',
                      fontSize: 9,
                      // fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Spacer(),
                ClipRRect(
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(20)),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 17,
                        ),
                        _listTileBuilder(context, 'Blue', Color(0xFF2196F3)),
                        _listTileBuilder(context, 'Purple', Color(0xFF6750A4)),
                        _listTileBuilder(context, 'Teal', Color(0xFF009688)),
                        _listTileBuilder(context, 'Pink', Color(0xFFE91E63)),
                        _listTileBuilder(context, 'Yellow', Color(0xFFFFEB3B)),
                        _listTileBuilder(context, 'Green', Color(0xFF4CAF50)),
                        _listTileBuilder(context, 'Orange', Color(0xFFFF9800)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
