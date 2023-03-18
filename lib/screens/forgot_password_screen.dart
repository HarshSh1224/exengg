import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatelessWidget {
  static const routeName = '/forgot-password-screen';
  ForgotPasswordScreen({super.key});
  bool _isLoading = false;
  TextEditingController emailController = TextEditingController();
  GlobalKey<FormState> _formkey = GlobalKey();

  void _submit(context, setState) async {
    FocusScope.of(context).unfocus();
    if (!_formkey.currentState!.validate()) {
      return;
    }
    print(emailController.text);

    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text);
    } on FirebaseAuthException catch (error) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Text(error.message!),
      )));
      return;
    }

    setState(() {
      _isLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Text('Email has been sent.'),
    )));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  CircleAvatar(
                    child: ClipRRect(
                      child: Image.asset(
                        Theme.of(context).colorScheme.brightness ==
                                Brightness.dark
                            ? 'assets/images/logo.png'
                            : 'assets/images/logo_light.png',
                        fit: BoxFit.fitWidth,
                      ),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    backgroundColor: Colors.transparent,
                    radius: 50,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Row(
                    children: [
                      Text(
                        'Enter your registered email',
                        style: TextStyle(
                          fontFamily: 'MoonBold',
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text(
                        'A reset password link will be sent to this email',
                        style: TextStyle(
                          fontFamily: 'Raleway',
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  EmailTextFormField(emailController),
                  SizedBox(
                    height: 50,
                  ),
                  StatefulBuilder(builder: (context, setState) {
                    return ElevatedButton(
                      onPressed: () {
                        _submit(context, setState);
                      },
                      // onPressed: !_isLogin && !agree ? null : _submit,
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                          foregroundColor:
                              Theme.of(context).colorScheme.onSecondary),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(10),
                        child: _isLoading
                            ? Center(
                                child: CircularProgressIndicator(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ))
                            : Text(
                                'Continue',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 18, fontFamily: 'MoonBold'),
                              ),
                      ),
                    );
                  }),
                  SizedBox(
                    height: 200,
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}

class EmailTextFormField extends StatelessWidget {
  TextEditingController emailController;
  EmailTextFormField(
    this.emailController, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.red,
      // height: 47,
      constraints: BoxConstraints(
        minHeight: 47,
      ),
      width: double.infinity,
      // padding: EdgeInsets.all(7),
      // color: Colors.black,
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Card(
            margin: EdgeInsets.all(0),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            elevation: 4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Text('ab'),
                Card(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Icon(
                      Icons.email_outlined,
                      size: 35,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                  ),
                  margin: EdgeInsets.all(0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 7,
          ),
          Expanded(
              child: TextFormField(
            controller: emailController,
            style:
                TextStyle(fontFamily: 'Raleway', fontWeight: FontWeight.w700),
            keyboardType: TextInputType.emailAddress,
            // maxLength: 20,
            decoration: InputDecoration(
              labelText: 'Email',
              labelStyle: TextStyle(fontFamily: 'Raleway'),
              // border: OutlineInputBorder(),
              // contentPadding: EdgeInsets.symmetric(vertical: ),
            ),
            validator: (value) {
              if (value!.isEmpty || !value.contains('@')) {
                return 'Invalid email!';
              }
              return null;
            },
            onSaved: (value) {
              // _formData['email'] = value!;
            },
            // style: TextStyle(fontSize: 10),
          )),
        ],
      ),
    );
  }
}
