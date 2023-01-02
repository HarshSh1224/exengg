import 'dart:math';

import 'package:exengg/widgets/socials_about_us.dart';
import 'package:flutter/material.dart';
import '../providers/about_data.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatefulWidget {
  static const routeName = '/about-us-page';
  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  PageController? pageController;
  double pageOffset = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController(viewportFraction: 0.7);
    pageController!.addListener(() {
      setState(() {
        pageOffset = pageController!.page!.toDouble();
      });
    });
    aboutInfo.shuffle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(slivers: <Widget>[
      SliverAppBar(
        expandedHeight: 200,
        pinned: true,
        backgroundColor: Color(0xff1f1f1f),
        flexibleSpace: FlexibleSpaceBar(
            centerTitle: true,
            title: Padding(
              padding: const EdgeInsets.only(top: 38.0),
              child: Text(
                'About Us',
                style: TextStyle(
                  fontFamily: 'BebasNeue',
                  fontSize: 30,
                  // color: Theme.of(context).colorScheme.onBackground
                  // fontWeight: FontWeight.bold,
                ),
              ),
            ),
            background: Image.asset(
              "assets/images/about/bg.jpg",
              fit: BoxFit.cover,
            )),
      ),
      SliverList(
        delegate: SliverChildListDelegate([
          AboutUsContent(
            pageController: pageController,
            pageOffset: pageOffset,
          ),
        ]),
      )
    ]));

    // Container(
    //   width: MediaQuery.of(context).size.width,
    //   decoration: BoxDecoration(
    //     image: DecorationImage(
    //       image: AssetImage("assets/bg.jpg"),
    //       fit: BoxFit.cover,
    //     ),
    //   ),
    //   //   child:
    //     Column(
    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //       children: [

    //       ],
    //     ),
    //   ),
    // );
  }
}

class AboutUsContent extends StatefulWidget {
  AboutUsContent({
    Key? key,
    required this.pageController,
    required this.pageOffset,
  }) : super(key: key);

  final PageController? pageController;
  final double pageOffset;

  @override
  State<AboutUsContent> createState() => _AboutUsContentState();
}

class _AboutUsContentState extends State<AboutUsContent> {
  double _showEmailDropHeight = 0;
  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 40,
        ),
        Divider(
          endIndent: 40,
          indent: 40,
        ),
        Padding(
          padding:
              const EdgeInsets.only(top: 20, bottom: 10, left: 18, right: 18),
          child: Text(
            'What is ExEngg?',
            style: TextStyle(
                fontFamily: 'MoonBold',
                fontSize: 20,
                letterSpacing: 2.0,
                color: Theme.of(context).colorScheme.outline),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
              left: 18.0, right: 18.0, top: 10, bottom: 15),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
                style: TextStyle(
                    fontFamily: 'Raleway',
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.onBackground),
                children: [
                  TextSpan(
                      text: 'ExEngg',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(
                      text:
                          ' has been created to facilitate an exchange platform where students, particularly Engineering students can exchange insturments, study materials, goodies and even ideas/opinions.'),
                ]),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Divider(
          endIndent: 40,
          indent: 40,
        ),
        SizedBox(
          height: 0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Text(
            'Meet The ExEngg team',
            style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
                fontSize: 20,
                fontFamily: 'Raleway',
                fontWeight: FontWeight.w700),
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 3 / 5,
          padding: EdgeInsets.only(bottom: 30),
          child: PageView.builder(
              itemCount: aboutInfo.length,
              controller: widget.pageController,
              itemBuilder: (context, i) {
                return Container(
                  // height: 600,
                  padding: EdgeInsets.only(right: 20),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.asset(
                          aboutInfo[i]['image'],
                          height: MediaQuery.of(context).size.height * 3 / 5,
                          width: MediaQuery.of(context).size.width * 4 / 5,
                          fit: BoxFit.cover,
                          alignment: Alignment(-widget.pageOffset.abs() + i, 0),
                        ),
                      ),
                      Positioned(
                        left: 20,
                        bottom: 20,
                        right: 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              aboutInfo[i]['name'],
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontFamily: 'BebasNeue'
                                  // fontStyle: FontStyle.italic,
                                  ),
                            ),
                            Text(
                              aboutInfo[i]['designation'],
                              style: TextStyle(
                                  color: Color(0xffff0080),
                                  fontSize: 12,
                                  fontFamily: 'MoonBold'
                                  // fontStyle: FontStyle.italic,
                                  ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              aboutInfo[i]['description'],
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontFamily: 'Raleway'
                                  // fontWeight: FontWeight.w
                                  // fontStyle: FontStyle.italic,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 5,
                        right: 5,
                        child: Socials(i),
                      )
                    ],
                  ),
                );
              }),
        ),
        SizedBox(
          height: 20,
        ),
        Divider(
          endIndent: 40,
          indent: 40,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 18, right: 18),
          child: Text(
            'Who We Are?',
            style: TextStyle(
                fontFamily: 'MoonBold',
                fontSize: 20,
                letterSpacing: 2.0,
                color: Theme.of(context).colorScheme.outline),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(
              left: 18.0, right: 18.0, top: 10, bottom: 15),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
                style: TextStyle(
                    fontFamily: 'Raleway',
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.onBackground),
                children: [
                  TextSpan(
                      text: 'We',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(
                      text:
                          ' are a group of Second year students currently enrolled in Software Engineering program at DTU. We aim to bring Technology to create a network and bring in the ease of connecting with your fellow mates!'),
                ]),
          ),
        ),
        Divider(
          endIndent: 40,
          indent: 40,
        ),
        SizedBox(
          height: 100,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 18, right: 18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'App Built on',
                style: TextStyle(
                    fontFamily: 'MoonBold',
                    fontSize: 10,
                    // letterSpacing: 2.0,
                    color: Theme.of(context).colorScheme.outline),
              ),
              SizedBox(
                width: 10,
              ),
              Image.asset(
                'assets/images/flutter.png',
                height: 30,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 50,
        )
      ],
    );
  }
}
