import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttershop/homepage.dart';
import 'package:fluttershop/providers/auth/user_data_provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  static const routename = '/login';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //Color(0xff18203d);

  final Color secondaryColor = Color(0xff232c51);

  final Color logoGreen = Color(0xff25bcbb);

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();
  final _loginkey = GlobalKey<FormState>();
  final storage = new FlutterSecureStorage();

  String _userEmail = '';
  String _userPassword = '';
  var _isLoading = false;
  var _obsecurePassword = true;
  final FirebaseAuth _firebaseAuthLogin = FirebaseAuth.instance;

  final GoogleSignIn googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;
    return Scaffold(
      body: Container(
        alignment: Alignment.topCenter,
        height: MediaQuery.of(context).size.height,
        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //     image: ExactAssetImage('assets/images/bg3.jpg'),
        //     fit: BoxFit.fill,
        //     alignment: Alignment.topCenter,
        //   ),
        // ),
        // Container(
        //   child: Image.asset("assets/images/bg3.jpg",height: MediaQuery.of(context).size.height*1.1,fit: BoxFit.fitHeight,width: MediaQuery.of(context).size.width,),
        // ),
        // margin: EdgeInsets.symmetric(horizontal: 30),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: SingleChildScrollView(
                child: Form(
                  key: _loginkey,
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 80,
                      ),
                      Align(
                          alignment: Alignment.bottomCenter,
                          child: Text(
                            'FlutterShop',
                            style: TextStyle(
                              fontSize: 45,
                              // color: Colors.white
                            ),
                          )),
                      SizedBox(height: 50),
                      Text(
                        'Sign-In',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          // color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                                color: Theme.of(context).primaryColor,
                                width: 2)),
                        padding:
                        EdgeInsets.all(4.0), //.symmetric(horizontal: 4.0),
                        child: TextFormField(
                          controller: _emailController,
                          validator: (value) {
                            if (value.isEmpty || !value.contains('@')) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _userEmail = value;
                          },
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                              contentPadding:
                              EdgeInsets.symmetric(horizontal: 10),
                              labelText: 'Email',
                              labelStyle: TextStyle(color: Colors.blue),
                              icon: Icon(
                                Icons.account_circle,
                                color: primaryColor,
                              ),
                              // prefix: Icon(icon),
                              border: InputBorder.none),
                        ),
                      ),
                      // _buildTextField(
                      //     nameController, Icons.account_circle, 'Username'),
                      SizedBox(height: 20),
                      Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                                color: Theme.of(context).primaryColor,
                                width: 2)),
                        padding: EdgeInsets.all(4.0),
                        child: TextFormField(
                          controller: _passwordController,
                          validator: (value) {
                            if (value.isEmpty || value.length < 7) {
                              return 'Password must be atleast 7 charachters';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _userPassword = value;
                          },
                          obscureText: _obsecurePassword,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                              contentPadding:
                              EdgeInsets.symmetric(horizontal: 10),
                              labelText: 'Password',
                              labelStyle: TextStyle(color: Colors.blue),
                              icon: Icon(
                                Icons.lock,
                                color: primaryColor,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(Icons.compass_calibration_outlined),
                                onPressed: () {
                                  setState(() {
                                    _obsecurePassword = !_obsecurePassword;
                                  });
                                },
                              ),
                              // prefix: Icon(icon),
                              border: InputBorder.none),
                        ),
                      ),
                      // _buildTextField(passwordController, Icons.lock, 'Password'),
                      SizedBox(height: 30),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: primaryColor, width: 2)),
                        child: MaterialButton(
                          elevation: 0,
                          minWidth: double.maxFinite,
                          height: 50,
                          onPressed: _submitAuthFormLogin,
                          color: primaryColor,
                          child: _isLoading
                              ? CircularProgressIndicator(
                            backgroundColor:Colors.blue
                            ,
                          )
                              : Text('Login',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16)),
                          textColor: Colors.white,
                        ),
                      ),
                      SizedBox(height: 20),
                      // OutlinedButton(onPressed: (){}),
                      SizedBox(height: 20),
                      MaterialButton(
                        color: Colors.white,
                        child: Text(
                          "  New here ? Sign Up  ",
                          style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        onPressed: () {
                          Navigator.of(context)
                              .pushReplacementNamed(SignUp.routename);
                        },
                      ),
                      SizedBox(height: 10),
                      TextButton(
                        onPressed: _resetPassword,
                        child: Text(
                          "Forgot Password ? Need help ",
                          style: TextStyle(
                              color: Colors.teal.shade400, fontSize: 14),
                        ),
                      ),
                      SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitAuthFormLogin() async {
    FocusScope.of(context).unfocus();
    var isValid = _loginkey.currentState.validate();
    if (isValid) {
      _loginkey.currentState.save();
    }
    setState(() {
      _isLoading = true;
    });
    var message = 'An error occured, please check your credentials';
    UserCredential authResult;
    try {
      if (isValid) {
        authResult = await _firebaseAuthLogin.signInWithEmailAndPassword(
            email: _userEmail, password: _userPassword);
        await storage.write(key: "signedIn", value: "true");
        // await storage.write(key: "emailsignin",value: "true");

        // storage.write(key: "driveStarted", value: "false");
        // final prefs = await SharedPreferences.getInstance();
        // if(!prefs.containsKey('userData')){
        //   prefs.setString('userData', _emailController.text);
        // }
        await Provider.of<UserData>(context, listen: false).fetchUser().then((value) => print('22'));
        Navigator.of(context).pushReplacementNamed(HomePage.routeName);
      }
    } on PlatformException catch (error) {
      if (error.message != null) message = error.message;
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Failed to Sign-in'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.of(ctx).pop();
                // if (Navigator.canPop(context)) {
                //   Navigator.of(ctx).pop();
                // }
              },
            )
          ],
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided for that user.';
      }
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Failed to Sign-in'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.of(ctx).pop();
                // if (Navigator.canPop(context)) {
                //   Navigator.of(ctx).pop();
                // }
              },
            )
          ],
        ),
      );
    } catch (err) {
      message = 'An error occured. Please try again';
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Failed to Sign-in'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.of(ctx).pop();
                // if (Navigator.canPop(context)) {
                //   Navigator.of(ctx).pop();
                // }
              },
            )
          ],
        ),
      );
    }
    setState(() {
      _isLoading = false;
    });
    // if(!isValid){
    //   print('11');
    //   // Scaffold.of(context).showSnackBar(SnackBar(
    //   //   content: Text('message'),
    //   //   backgroundColor: Theme.of(context).errorColor,
    //   // ));
    // }
  }

  void _resetPassword() async {
    if (_emailController.text.isEmpty || !_emailController.text.contains('@')) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Enter a valid email'),
          content: Text(
              'Unable to reset password to as email address is not valid.'),
          actions: <Widget>[
            TextButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            )
          ],
        ),
      );
      return;
    }
    await _firebaseAuthLogin.sendPasswordResetEmail(
        email: _emailController.text);
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Password reset link sent'),
        content: Text(
            'A password reset link has been sent to your email. Please follow the steps to reset your password.'),
        actions: <Widget>[
          TextButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }
}
