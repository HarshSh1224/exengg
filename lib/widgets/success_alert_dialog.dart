import 'package:flutter/material.dart';
import 'package:animated_check/animated_check.dart';

class SuccessDialog extends StatefulWidget {
  const SuccessDialog({super.key});

  @override
  State<SuccessDialog> createState() => _SuccessDialogState();
}

class _SuccessDialogState extends State<SuccessDialog>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )
      ..forward()
      ..repeat(reverse: true);
    animation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOutBack));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
      content: Container(
        padding: EdgeInsets.only(
          top: 20,
        ),
        child: Stack(
          children: [
            Container(
              height: 280,
            ),
            Positioned.fill(
              top: 10,
              child: Align(
                alignment: Alignment.topCenter,
                child: CircleAvatar(
                  backgroundColor: Colors.green,
                  radius: 33,
                  child: CircleAvatar(
                      radius: 30,
                      backgroundColor:
                          Theme.of(context).colorScheme.surfaceVariant,
                      child: AnimatedCheck(
                        progress: animation,
                        size: 60,
                        color: Colors.green,
                      )),
                ),
              ),
            ),
            Positioned.fill(
              top: 110,
              child: Align(
                alignment: Alignment.topCenter,
                child: Text(
                  'SUCCESS',
                  style: TextStyle(
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.w700,
                    fontSize: 17,
                    // color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  // textAlign: TextAlign.center,
                ),
              ),
            ),
            Positioned.fill(
              top: 150,
              child: Align(
                alignment: Alignment.topCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 20,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      'Improtant Note:  ',
                      style: TextStyle(
                        fontFamily: 'Raleway',
                        // fontWeight: FontWeight.w700,
                        fontSize: 17,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                      // textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            Positioned.fill(
              top: 180,
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  constraints: BoxConstraints(maxWidth: 200),
                  child: Text(
                    'Make Sure to delete your product once it is sold. Otherwise, you may keep getting messages.',
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontFamily: 'Raleway',
                      // fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                    // textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: Text(
              'Okay',
              style: TextStyle(fontSize: 15),
            ))
      ],
    );
  }
}
