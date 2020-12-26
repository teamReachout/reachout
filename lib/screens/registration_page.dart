import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:reachout/auth.dart';
import 'package:reachout/home.dart';
import 'package:reachout/screens/login_page.dart';
import 'package:reachout/screens/root_page.dart';

class RegistrationPage extends StatefulWidget {
  final BaseAuth auth;
  RegistrationPage({this.auth});
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  String _email, _password, _firstName, _lastName;
  FocusNode focusNode;

  void _submit() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      // print("Name: $_firstName Email: $_email Password: $_password");
      _register();
    }
  }

  void _register() async {
    try {
      String uid = await widget.auth.createUser(_email, _password);
      // print("uid: $uid");
      await widget.auth.sendEmailVerification().then((user) async {
        widget.auth.signOut();
        Fluttertoast.showToast(
            msg: "Verification Email Sent! Verify to Login",
            gravity: ToastGravity.BOTTOM,
            toastLength: Toast.LENGTH_LONG);
        createUser(uid);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (BuildContext context) => RootPage(auth: widget.auth),
            ),
            (Route<dynamic> route) => false);
      });
    } catch (e) {
      // print("Error: $e");
    }
  }

  createUser(String uid) {
    usersRef.document(uid).setData({
      'firstName': _firstName,
      'lastName': _lastName,
      'id': uid,
      'number': '',
      'photoUrl': '',
      'email': '',
      'bio': '',
      'areaOfWork': [],
      'educations': [],
      'experiences': [],
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'REGISTER',
                style: TextStyle(
                  fontSize: 40,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 12,
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                key: ValueKey('first name'),
                                autocorrect: false,
                                cursorColor: Color.fromRGBO(89, 89, 89, 1),
                                textCapitalization: TextCapitalization.none,
                                enableSuggestions: false,
                                validator: (value) {
                                  if (value.length <= 3) {
                                    return 'Invalid';
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  labelStyle: TextStyle(
                                    color: Color.fromRGBO(89, 89, 89, 1),
                                  ),
                                  labelText: 'First Name',
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromRGBO(89, 89, 89, 1),
                                      width: 3,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromRGBO(89, 89, 89, 1),
                                      width: 3,
                                    ),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromRGBO(89, 89, 89, 1),
                                      width: 3,
                                    ),
                                  ),
                                  border: UnderlineInputBorder(),
                                ),
                                onSaved: (value) {
                                  _firstName = value;
                                },
                              ),
                            ),
                          ),
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                cursorColor: Color.fromRGBO(89, 89, 89, 1),
                                key: ValueKey('last name'),
                                validator: (value) {
                                  if (value.length <= 3) {
                                    return 'Invalid';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  labelStyle: TextStyle(
                                    color: Color.fromRGBO(89, 89, 89, 1),
                                  ),
                                  labelText: 'Last Name',
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromRGBO(89, 89, 89, 1),
                                      width: 3,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromRGBO(89, 89, 89, 1),
                                      width: 3,
                                    ),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromRGBO(89, 89, 89, 1),
                                      width: 3,
                                    ),
                                  ),
                                  border: UnderlineInputBorder(),
                                ),
                                onSaved: (value) {
                                  _lastName = value;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      TextFormField(
                        key: ValueKey('email'),
                        autocorrect: false,
                        cursorColor: Color.fromRGBO(89, 89, 89, 1),
                        textCapitalization: TextCapitalization.none,
                        enableSuggestions: false,
                        validator: (value) {
                          if (!EmailValidator.validate(value)) {
                            return 'Invalid email!';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          icon: Icon(Icons.mail_outline),
                          labelStyle: TextStyle(
                            color: Color.fromRGBO(89, 89, 89, 1),
                          ),
                          labelText: 'E-Mail',
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromRGBO(89, 89, 89, 1),
                              width: 3,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromRGBO(89, 89, 89, 1),
                              width: 3,
                            ),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromRGBO(89, 89, 89, 1),
                              width: 3,
                            ),
                          ),
                          border: UnderlineInputBorder(),
                        ),
                        onSaved: (value) {
                          _email = value;
                        },
                        onFieldSubmitted: (val) =>
                            FocusScope.of(context).requestFocus(focusNode),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        cursorColor: Color.fromRGBO(89, 89, 89, 1),
                        key: ValueKey('password'),
                        validator: (value) {
                          if (value.isEmpty || value.length < 7) {
                            return 'Please enter valid Password';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          icon: Icon(
                            Icons.lock_outline,
                          ),
                          labelStyle: TextStyle(
                            color: Color.fromRGBO(89, 89, 89, 1),
                          ),
                          labelText: 'Password',
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromRGBO(89, 89, 89, 1),
                              width: 3,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromRGBO(89, 89, 89, 1),
                              width: 3,
                            ),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromRGBO(89, 89, 89, 1),
                              width: 3,
                            ),
                          ),
                          border: UnderlineInputBorder(),
                        ),
                        onSaved: (value) {
                          _password = value;
                        },
                        obscureText: true,
                        focusNode: focusNode,
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Container(
                        width: 175,
                        height: 40,
                        child: RaisedButton(
                          child: Text(
                            'SIGN UP',
                            style: TextStyle(color: Colors.white),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          color: Theme.of(context).primaryColor,
                          onPressed: _submit,
                        ),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      FlatButton(
                        textColor: Theme.of(context).primaryColor,
                        child: Text(
                          'BACK TO LOGIN',
                          style: TextStyle(
                            color: Color.fromRGBO(89, 89, 89, 1),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (ctx) => LoginPage(auth: widget.auth),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
