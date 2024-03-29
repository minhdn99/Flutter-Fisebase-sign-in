import 'package:authentification/start/Start.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomeDemo extends StatefulWidget {
  @override
  _HomeDemoState createState() => _HomeDemoState();
}

class _HomeDemoState extends State<HomeDemo> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User user;
  bool isloggedin = false;

  checkAuthentification() async {
    _auth.authStateChanges().listen((user) {
      if (user == null) {
        Navigator.of(context).pushReplacementNamed("start");
      }
    });
  }

  getUser() async {
    User firebaseUser = _auth.currentUser;
    await firebaseUser?.reload();
    firebaseUser = _auth.currentUser;

    if (firebaseUser != null) {
      setState(() {
        this.user = firebaseUser;
        this.isloggedin = true;
      });
    }
  }

  signOut() async {
    _auth.signOut();

    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
  }

  @override
  void initState() {
    super.initState();
    this.checkAuthentification();
    this.getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          actions: <Widget>[
            FlatButton.icon(
              onPressed: () {},
              icon: Icon(Icons.logout),
              label: Text('hi'),
            )
          ],
        ),
        body: Container(
          // decoration: BoxDecoration(
          //     color: Colors.black12,
          //     image: DecorationImage(
          //         fit: BoxFit.cover,
          //         image: AssetImage('images/logo.jpg')
          //     )
          // ),
          child: !isloggedin
              ? CircularProgressIndicator()
              : Column(
            children: <Widget>[
              // SizedBox(height: 40.0),
              // Container(
              //   // height: 300,
              //   child: Image(
              //     image: AssetImage("images/logo.jpg"),
              //     fit: BoxFit.cover,
              //   ),
              // ),
              SizedBox(height: 80),
              Container(
                child: Text(
                  "Hello ${user.displayName} you are Logged in as ${user.email}",
                  style:
                  TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              RaisedButton(
                padding: EdgeInsets.fromLTRB(70, 10, 70, 10),
                onPressed: signOut,
                child: Text('Signout',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold)),
                color: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              )
            ],
          ),
        ));
  }
}
