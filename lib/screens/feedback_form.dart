import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exengg/providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FeedbackForm extends StatefulWidget {
  static const routeName = '/feedback-form';
  final Color _brandColor;
  const FeedbackForm(this._brandColor);

  @override
  State<FeedbackForm> createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<FeedbackForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  bool _isLoading = false;

  Map<String, String>? formData;

  @override
  initState() {
    formData = {
      'subject': '',
      'body': '',
      'uid': Provider.of<Auth>(context, listen: false).getUserId,
      'date': '',
    };
    super.initState();
  }

  void _sendEmail() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    String responseString = '';
    formData!['date'] = DateTime.now().toIso8601String();

    try {
      await FirebaseFirestore.instance
          .collection('user_messages')
          .add(formData!);
      responseString = 'Success. Thanks for feedback!';
    } catch (error) {
      responseString = 'An Error Occurred';
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(responseString),
    )));
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  String _whichImageToUse() {
    if (widget._brandColor == Color(0xFFE91E63))
      return 'assets/images/feedback/7.png';
    if (widget._brandColor == Color(0xFF2196F3))
      return 'assets/images/feedback/1.png';
    if (widget._brandColor == Color(0xFF009688))
      return 'assets/images/feedback/3.png';
    if (widget._brandColor == Color(0xFF4CAF50))
      return 'assets/images/feedback/4.png';
    if (widget._brandColor == Color(0xFFFFEB3B))
      return 'assets/images/feedback/5.png';
    if (widget._brandColor == Color(0xFFFF9800))
      return 'assets/images/feedback/6.png';
    else
      return 'assets/images/feedback/2.png';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              // color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          // backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
          // foregroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
          title: Text(
            'Feedback / Report a bug',
            style: TextStyle(
                fontSize: 18,
                fontFamily: 'Raleway',
                fontWeight: FontWeight.w700),
          )),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        // color: Color(0xffFFFBFF),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Help Us\nImprove',
                          style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                              fontFamily: 'Raleway',
                              fontWeight: FontWeight.w800,
                              fontSize: 25),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          width: 100,
                          child: Text(
                            'Send messages directly to the ExEngg team',
                            style: TextStyle(
                                fontSize: 10,
                                color: Theme.of(context).colorScheme.primary),
                          ),
                        )
                      ],
                    ),
                    Image.asset(
                      _whichImageToUse(),
                      height: 200,
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Card(
                  // color: Color(0xffEEE8F4).withOpacity(1),
                  elevation: 6,
                  child: TextFormField(
                    // autofillHints: ['Found a bug', 'Improve the profile page'],
                    style: TextStyle(
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w700,
                    ),
                    decoration: InputDecoration(
                        label: Text('Subject'),
                        labelStyle: const TextStyle(
                          fontFamily: 'MoonBold',
                        ),
                        // floatingLabelStyle: const TextStyle(
                        //     height: 4, color: Color.fromARGB(255, 160, 26, 179)),
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10)),
                        prefixIcon: Icon(
                          Icons.subject_rounded,
                          // color: ,
                        )),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Subject is required';
                      } else if (value.length > 100) {
                        return 'Subject can be maximum 100 characters long';
                      } else
                        return null;
                    },
                    onSaved: (value) {
                      formData?['subject'] = value!;
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Card(
                  // color: Color(0xffEEE8F4).withOpacity(1),
                  elevation: 6,
                  child: TextFormField(
                    style: TextStyle(
                      fontFamily: 'Raleway',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Body is required';
                      } else
                        return null;
                    },
                    onSaved: (value) {
                      formData?['body'] = value!;
                    },
                    maxLines: 5,
                    decoration: InputDecoration(
                        alignLabelWithHint: true,
                        label: Text('Write here'),
                        labelStyle: const TextStyle(
                          fontFamily: 'MoonBold',
                        ),
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10)),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(bottom: 110.0),
                          child: Icon(
                            Icons.edit,
                          ),
                        )),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Card(
                  // color: Color(0xffEEE8F4).withOpacity(1),
                  elevation: 6,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => _sendEmail(),
                        child: Container(
                          height: 60,
                          width: 120,
                          child: Center(
                            child: _isLoading
                                ? Center(child: CircularProgressIndicator())
                                : Text(
                                    'Submit',
                                    style: TextStyle(
                                      fontFamily: 'MoonBold',
                                      fontSize: 16,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
