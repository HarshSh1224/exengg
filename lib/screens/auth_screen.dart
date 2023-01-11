import 'dart:io';
import 'package:exengg/providers/auth.dart';
import 'package:exengg/widgets/image_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthScreen extends StatefulWidget {
  static const routeName = '/auth-screen';

  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

var _formData = {
  'name': '',
  'email': '',
  'password': '',
};

final GlobalKey<FormState> _formKey = GlobalKey();

class _AuthScreenState extends State<AuthScreen> {
  final _passwordController = TextEditingController();
  File? _profilePic = null;

  void getProfilePic(File? profilePic) {
    _profilePic = profilePic;
  }

  bool _isLogin = true, _isLoading = false, agree = false;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _toggleLogin() {
    setState(() {
      _isLogin = _isLogin ? false : true;
    });
  }

  void _showErrorDialog(String errorMessage) {
    final start = errorMessage.indexOf(']');
    String croppedMessage =
        errorMessage.substring(start + 2, errorMessage.length - 1).trim();

    print('CROPPED $croppedMessage');

    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text('An Error Occurred!'),
            content: Text(croppedMessage),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Okay'),
              ),
            ],
          );
        });
  }

  void _submit() async {
    FocusScope.of(context).unfocus();

    // if (!_isLogin && _profilePic == null) {
    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //       content: Padding(
    //     padding: const EdgeInsets.symmetric(vertical: 8.0),
    //     child: Text('Please pick an image'),
    //   )));
    //   return;
    // }

    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    // print(_formData);
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<Auth>(context, listen: false).authenticate(
          _formData['email']!.trim(),
          _formData['password']!.trim(),
          _isLogin,
          _formData['name']!,
          _profilePic);
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    } catch (error) {
      _showErrorDialog(error.toString());
      setState(() {
        _isLoading = false;
      });
    }
    bool isAuth = Provider.of<Auth>(context, listen: false).isAuth;
    print('\n\nISAUTH : $isAuth\n\n');
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        SizedBox(
          height: 100,
        ),
        // AnimatedOpacity(
        //   duration: Duration(seconds: 2),
        //   opacity: _isLogin ? 0 : 1,
        //   child: _isLogin
        //       ? null
        //       : Text(
        //           'Welcome to',
        //           style: TextStyle(
        //             fontSize: 20,
        //             fontFamily: 'Raleway',
        //             // fontWeight: FontWeight.w800,
        //           ),
        //         ),
        // ),

        // AnimatedContainer(
        //   duration: Duration(milliseconds: 2000),
        //   curve: Curves.easeOutCirc,
        //   height: _isLogin ? 0 : 50,
        //   child: AnimatedOpacity(
        //     duration: Duration(seconds: 2),
        //     opacity: _isLogin ? 0 : 1,
        //     child: Text(
        //       'ExEngg',
        //       style: TextStyle(
        //         fontSize: 30,
        //         fontFamily: 'Raleway',
        //         fontWeight: FontWeight.w700,
        //       ),
        //     ),
        //   ),
        // ),
        // SizedBox(
        //   height: 30,
        // ),
        AnimatedOpacity(
          duration: Duration(seconds: 2),
          opacity: _isLogin ? 0 : 1,
          child: _isLogin ? null : ImagePickerWidget(getProfilePic),
        ),
        if (_isLogin)
          CircleAvatar(
            child: ClipRRect(
              child: Image.asset(
                Theme.of(context).colorScheme.brightness == Brightness.dark
                    ? 'assets/images/logo.png'
                    : 'assets/images/logo_light.png',
                fit: BoxFit.fitWidth,
              ),
              borderRadius: BorderRadius.circular(50),
            ),
            backgroundColor: Colors.transparent,
            radius: 50,
          ),
        // SizedBox(
        //   height: 20,
        // ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 30, horizontal: 46),
          constraints: BoxConstraints(minHeight: 200),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isLogin ? 'Login to continue' : 'Create a new account',
                  style: TextStyle(
                    fontFamily: 'MoonBold',
                    // fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                // if (!_isLogin)
                NameTextFormField(_isLogin),
                SizedBox(
                  height: _isLogin ? 0 : 10,
                ),
                EmailTextFormField(),
                SizedBox(
                  height: _isLogin ? 10 : 10,
                ),
                PasswordTextFormField(_passwordController),
                SizedBox(
                  height: _isLogin ? 50 : 10,
                ),
                // if (!_isLogin)
                ConfirmPasswordTextFormField(_passwordController, _isLogin),
                SizedBox(
                  height: _isLogin ? 0 : 30,
                ),
                if (!_isLogin) agreeToTerms(context),
                ElevatedButton(
                  onPressed: !_isLogin && !agree ? null : _submit,
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
                            _isLogin ? 'LOGIN' : 'SIGN UP',
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(fontSize: 18, fontFamily: 'MoonBold'),
                          ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 50,
                  width: double.infinity,
                  // color: Colors.red,
                  alignment: Alignment.center,
                  child: FittedBox(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _isLogin
                              ? 'Dont have an account?'
                              : 'Already Have an account?',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontFamily: 'MoonBold'),
                        ),
                        TextButton(
                            onPressed: _toggleLogin,
                            child: Text(
                              _isLogin ? 'Sign Up' : 'Login',
                              style: TextStyle(fontFamily: 'MoonBold'),
                            ))
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ]),
    );
  }

  Row agreeToTerms(BuildContext context) {
    return Row(
      children: [
        Transform.scale(
          scale: 0.9,
          child: Checkbox(
            checkColor: Theme.of(context).colorScheme.background,
            activeColor: Theme.of(context).colorScheme.onPrimaryContainer,
            value: agree,
            onChanged: (value) {
              setState(() {
                agree = value ?? false;
              });
            },
          ),
        ),
        Transform.translate(
          offset: Offset(-10, 0),
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                fontFamily: 'Roboto',
                // fontSize: 12,
                color: Theme.of(context).colorScheme.onBackground,
              ),
              children: [
                TextSpan(
                  text: 'I agree to the ',
                  // textAlign: TextAlign.center,
                ),
                TextSpan(
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                    text: 'Privacy Policy',
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        print('TAP Policy');
                        final Uri url = Uri.parse(
                            'https://github.com/HarshSh1224/ExEngg-privacy/blob/main/privacy_policy.md');
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url,
                              mode: LaunchMode.externalApplication);
                        }
                      }),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class EmailTextFormField extends StatelessWidget {
  const EmailTextFormField({
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
              _formData['email'] = value!;
            },
            // style: TextStyle(fontSize: 10),
          )),
        ],
      ),
    );
  }
}

class NameTextFormField extends StatelessWidget {
  final isLogin;
  const NameTextFormField(
    this.isLogin, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      // color: Colors.red,
      duration: Duration(milliseconds: 300),
      height: isLogin ? 0 : 70,
      constraints: BoxConstraints(
          // minHeight: 47,
          ),
      width: double.infinity,
      // padding: EdgeInsets.all(7),
      // color: Colors.black,
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 500),
        opacity: isLogin ? 0 : 1,
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Card(
              margin: EdgeInsets.all(0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
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
                        Icons.person,
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
              style:
                  TextStyle(fontFamily: 'Raleway', fontWeight: FontWeight.w700),
              keyboardType: TextInputType.emailAddress,
              // maxLength: 50,
              decoration: InputDecoration(
                labelText: 'Full Name',
                labelStyle: TextStyle(fontFamily: 'Raleway'),
                // border: OutlineInputBorder(),
                // contentPadding: EdgeInsets.symmetric(vertical: ),
              ),
              validator: (value) {
                if (!isLogin && value!.length < 3) {
                  return 'Name should be min 3 character long';
                }
                return null;
              },
              onSaved: (value) {
                _formData['name'] = value!;
              },
              // style: TextStyle(fontSize: 10),
            )),
          ],
        ),
      ),
    );
  }
}

class PasswordTextFormField extends StatelessWidget {
  final _passwordController;
  PasswordTextFormField(
    this._passwordController, {
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
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
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
                        Icons.lock_outline_rounded,
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
              style:
                  TextStyle(fontFamily: 'Raleway', fontWeight: FontWeight.w700),
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
              // maxLength: 100,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(fontFamily: 'Raleway'),
                // border: OutlineInputBorder(),
                // contentPadding: EdgeInsets.symmetric(vertical: ),
              ),
              controller: _passwordController,
              validator: (value) {
                if (value!.isEmpty || value.length < 8) {
                  return 'Password Should be 8 characters long';
                }
                return null;
              },
              onSaved: (value) {
                _formData['password'] = value!;
              },
              // style: TextStyle(fontSize: 10),
            )),
          ],
        ));
  }
}

class ConfirmPasswordTextFormField extends StatelessWidget {
  final _passwordController, isLogin;
  ConfirmPasswordTextFormField(
    this._passwordController,
    this.isLogin, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        // color: Colors.red,
        duration: Duration(milliseconds: 300),
        height: isLogin ? 0 : 75,
        constraints: BoxConstraints(
            // minHeight: 47,
            ),
        width: double.infinity,
        // padding: EdgeInsets.only(bottom: 7),
        // color: Colors.black,
        child: AnimatedOpacity(
          duration: Duration(milliseconds: 500),
          opacity: isLogin ? 0 : 1,
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Card(
                margin: EdgeInsets.all(0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
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
                          Icons.lock_outline_rounded,
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
                style: TextStyle(
                    fontFamily: 'Raleway', fontWeight: FontWeight.w700),
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  labelStyle: TextStyle(fontFamily: 'Raleway'),
                  // border: OutlineInputBorder(),
                  // contentPadding: EdgeInsets.symmetric(vertical: ),
                ),
                validator: (value) {
                  if (!isLogin && value != _passwordController.text) {
                    return 'Passwords dont match!';
                  }
                  return null;
                },
                onSaved: (value) {},
                // style: TextStyle(fontSize: 10),
              )),
            ],
          ),
        ));
  }
}
