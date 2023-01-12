import 'package:flutter/material.dart';
import 'package:dart_ipify/dart_ipify.dart';

String? _ipv4;

void getIP() async {
  _ipv4 = await Ipify.ipv4();
  print(_ipv4);
}

void showGuidelinesDialog(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            title: Text(
              'Guidelines',
              style: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                        fontSize: 17,
                        color:
                            Theme.of(context).colorScheme.onPrimaryContainer),
                    children: [
                      TextSpan(
                        text: 'The following actions are ',
                      ),
                      TextSpan(
                          text: 'PROHIBITED ',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(
                        text:
                            'and may lead to permanent suspension of the user account and some may even attract legal action:\n\n• Spamming or entering irrelevent information.\n\n• Posting False or Fake Deals.\n\n• Posting graphic or inappropriate content.\n\n• Conducting scams or any other illegal activity.\n( Your IP : ',
                      ),
                      TextSpan(
                        text: _ipv4 == null ? 'connecting...' : _ipv4,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: ' )',
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: Navigator.of(context).pop,
                  child: Text(
                    'Close',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ))
            ],
          ));
}
