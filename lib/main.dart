import 'package:college_gram/screens/main/feed_screen.dart';
import 'package:college_gram/screens/init/init_screen.dart';
import 'package:flutter/material.dart';

import 'screens/accounts/auth_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/init',
      routes: {
        "/init": (context) => InitScreen(),
        '/auth': (context) => AuthScreen(),
      },
    );
  }
}
