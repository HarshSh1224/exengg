import 'dart:io';
import 'package:exengg/providers/auth.dart';
import 'package:exengg/widgets/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatefulWidget {
  static const routeName = '/auth-screen';

  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

var formData = {
  'name': '',
  'email': '',
  'password': '',
};

final GlobalKey<FormState> _formKey = GlobalKey();

class _AuthScreenState extends State<AuthScreen> {
  final _passwordController = TextEditingController();
  File? _profilePic;

  void getProfilePic(File? profilePic) {
    _profilePic = profilePic;
  }

  bool _isLogin = true, _isLoading = false;

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

    if (!_isLogin && _profilePic == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Please pick an image')));
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    // print(formData);
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<Auth>(context, listen: false).authenticate(
          formData['email']!.trim(),
          formData['password']!.trim(),
          _isLogin,
          formData['name']!,
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
        if (!_isLogin) ImagePickerWidget(getProfilePic),
        if (_isLogin)
          CircleAvatar(
            child: ClipRRect(
              child: Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.fitWidth,
              ),
              borderRadius: BorderRadius.circular(50),
            ),
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
                Text(_isLogin ? 'Login to continue' : 'Create a new account'),
                SizedBox(
                  height: 25,
                ),
                if (!_isLogin) NameTextFormField(),
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
                if (!_isLogin)
                  ConfirmPasswordTextFormField(_passwordController),
                SizedBox(
                  height: _isLogin ? 0 : 50,
                ),
                ElevatedButton(
                  onPressed: _submit,
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
                            style: TextStyle(fontSize: 18),
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
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _isLogin
                            ? 'Dont have an account?'
                            : 'Already Have an account?',
                        textAlign: TextAlign.center,
                      ),
                      TextButton(
                          onPressed: _toggleLogin,
                          child: Text(_isLogin ? 'Sign Up' : 'Login'))
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      ]),
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
            keyboardType: TextInputType.emailAddress,
            // maxLength: 20,
            decoration: InputDecoration(
              labelText: 'Email',
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
              formData['email'] = value!;
            },
            // style: TextStyle(fontSize: 10),
          )),
        ],
      ),
    );
  }
}

class NameTextFormField extends StatelessWidget {
  const NameTextFormField({
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
            keyboardType: TextInputType.emailAddress,
            // maxLength: 50,
            decoration: InputDecoration(
              labelText: 'Full Name',
              // border: OutlineInputBorder(),
              // contentPadding: EdgeInsets.symmetric(vertical: ),
            ),
            validator: (value) {
              if (value!.isEmpty || value.length < 3) {
                return 'Name should be min 3 character long';
              }
              return null;
            },
            onSaved: (value) {
              formData['name'] = value!;
            },
            // style: TextStyle(fontSize: 10),
          )),
        ],
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
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
              // maxLength: 100,
              decoration: InputDecoration(
                labelText: 'Password',
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
                formData['password'] = value!;
              },
              // style: TextStyle(fontSize: 10),
            )),
          ],
        ));
  }
}

class ConfirmPasswordTextFormField extends StatelessWidget {
  final _passwordController;
  ConfirmPasswordTextFormField(
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
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                // border: OutlineInputBorder(),
                // contentPadding: EdgeInsets.symmetric(vertical: ),
              ),
              validator: (value) {
                if (value != _passwordController.text) {
                  return 'Passwords dont match!';
                }
                return null;
              },
              onSaved: (value) {},
              // style: TextStyle(fontSize: 10),
            )),
          ],
        ));
  }
}
