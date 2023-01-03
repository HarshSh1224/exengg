import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/about_data.dart';

class Socials extends StatefulWidget {
  int i;
  Socials(this.i, {super.key});

  @override
  State<Socials> createState() => _SocialsState();
}

class _SocialsState extends State<Socials> {
  double _showEmailDropHeight = 0;
  bool _isCopied = false;

  void _toggleCopied() {
    setState(() {
      _isCopied = true;
    });
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _isCopied = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          // height: 35,
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
                spreadRadius: 1,
                color: Color.fromARGB(255, 44, 44, 44).withOpacity(0.7),
                offset: Offset(3, 0),
                blurRadius: 24),
          ]),
          child: IconButton(
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(),
            onPressed: () async {
              final Uri url = Uri.parse(aboutInfo[widget.i]['linkedin']);
              if (await canLaunchUrl(url)) {
                await launchUrl(url,
                    mode: LaunchMode.externalNonBrowserApplication);
              }
            },
            icon: Image.asset('assets/images/linkedin.png', height: 40),
          ),
        ),
        Container(
          height: 32,
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
                spreadRadius: 1,
                color: Color.fromARGB(255, 44, 44, 44).withOpacity(0.7),
                offset: Offset(3, 0),
                blurRadius: 24),
          ]),
          child: IconButton(
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(),
            onPressed: () {
              setState(() {
                _showEmailDropHeight = _showEmailDropHeight == 65 ? 0 : 65;
              });
            },
            icon: Image.asset('assets/images/at_the_rate.png'),
            // size: 30,
            // color: Color(0xffff0080),
          ),
        ),
        ClipPath(
          clipper: CustomClipPath(),
          child: AnimatedContainer(
            width: 200,
            duration: Duration(milliseconds: 200),
            padding: EdgeInsets.only(top: 25, left: 10, right: 10, bottom: 10),
            height: 65,
            // width: 210,
            constraints: BoxConstraints(maxWidth: 210),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
                topLeft: Radius.elliptical(120, 27),
              ),
              color: Color(0xff1f1f1f)
                  .withOpacity((min(_showEmailDropHeight / 65, 0.8))),
            ),
            margin: EdgeInsets.only(right: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    aboutInfo[widget.i]['email'],
                    style: TextStyle(
                        color: Color.fromARGB(255, 220, 220, 220).withOpacity(
                            (min(_showEmailDropHeight / 65, 0.8)))),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                  onPressed: () async {
                    await Clipboard.setData(
                        ClipboardData(text: aboutInfo[widget.i]['email']));
                    _toggleCopied();
                  },
                  icon: _isCopied
                      ? Icon(
                          Icons.done,
                          color: Colors.green,
                        )
                      : Icon(
                          Icons.copy,
                          size: 20,
                          color: Color.fromARGB(255, 220, 220, 220).withOpacity(
                            (min(_showEmailDropHeight / 65, 0.8)),
                          ),
                          //     Color.fromARGB(
                          //           255, 161, 161, 161).withOpacity(
                          // (min(_showEmailDropHeight / 65, 0.8)))
                        ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class CustomClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path0 = Path();
    path0.moveTo(0, 20);
    path0.lineTo(0, size.height);
    path0.lineTo(size.width, size.height);
    // path0.quadraticBezierTo(
    //     size.width * 0.6, size.height - 10, size.width, size.height - 65);
    // path0.lineTo(size.width, size.height);
    path0.lineTo(size.width, 0);
    path0.lineTo(size.width - 30, 20);
    // path0.quadraticBezierTo(size.width - 5, 12, size.width - 10, );
    path0.close();
    return path0;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
