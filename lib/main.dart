import 'package:authentification/end/HomeDemo.dart';
import 'package:authentification/start/Login.dart';
import 'package:authentification/start/SignUp.dart';
import 'package:authentification/start/Start.dart';
import 'package:flutter/material.dart';
import 'end/HomePage.dart';
import 'package:firebase_core/firebase_core.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
   runApp(MyApp());
   }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      theme: ThemeData(
        primaryColor: Colors.green
      ),
      debugShowCheckedModeBanner: false,
      home:
      // HomeDemo(),
    
      HomePage(),

      routes: <String,WidgetBuilder>{

        "Login" : (BuildContext context)=>Login(),
        "SignUp":(BuildContext context)=>SignUp(),
        "start":(BuildContext context)=>Start(),
      },

    );
  }

}



