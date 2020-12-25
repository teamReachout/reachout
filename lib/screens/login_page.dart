import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:reachout/auth.dart';
import 'package:reachout/screens/registration_page.dart';

class LoginPage extends StatefulWidget {
  LoginPage({this.auth, this.onSignedIn});
  final BaseAuth auth;
  final VoidCallback onSignedIn;
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email, _password;
  FocusNode focusNode;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
  }

  void _submit() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      // print("Email: $_email Password: $_password");
      _login();
    }
  }

  void _login() async {
    try {
      String uid = await widget.auth.signIn(_email, _password);
      // print("Signed in : $uid");
      await widget.auth.isEmailVerified().then((isVerified) async {
        if (isVerified) {
          // print("Verified");
          widget.onSignedIn();
        } else {
          final snackBar = SnackBar(
            content: Text("Email Not Verified!"),
            duration: Duration(seconds: 1),
            action: SnackBarAction(
                label: "Send Again",
                onPressed: () async {
                  await widget.auth.sendEmailVerification();
                }),
          );
          scaffoldKey.currentState.showSnackBar(snackBar);
          await Future.delayed(Duration(milliseconds: 1001));
          await widget.auth.signOut();
        }
      });
    } catch (e) {
      final snackBar = SnackBar(content: Text("Error in Signing in!"));
      scaffoldKey.currentState.showSnackBar(snackBar);
      // print("Error: $e");
    }
  }

  void _passwordReset() async {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      try {
        await widget.auth.resetPassword(_email);
        Navigator.of(context).pop();
        final snackBar = SnackBar(content: Text("Password Reset Email Sent"));
        scaffoldKey.currentState.showSnackBar(snackBar);
      } catch (e) {
        Fluttertoast.showToast(
          msg: "Invalid Input!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }
    }
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
                'Sign In',
                style: TextStyle(
                  fontSize: 50,
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
                            'LOGIN',
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
                      Container(
                        width: 175,
                        height: 40,
                        child: RaisedButton(
                          child: Text(
                            'REGISTER',
                            style: TextStyle(color: Colors.white),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          color: Theme.of(context).primaryColor,
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (ctx) =>
                                    RegistrationPage(auth: widget.auth),
                              ),
                            );
                          },
                        ),
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
