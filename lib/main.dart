import 'package:flutter/material.dart';
import 'dart:async';
import 'login_screen.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dashboard.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

ColorScheme defaultColorScheme = const ColorScheme(
  primary: Color.fromARGB(255, 120, 158, 254),
  secondary: Color(0xff03DAC6),
  surface: Color(0xff181818),
  background: Color.fromARGB(255, 34, 34, 52),
  error: Color(0xffCF6679),
  onPrimary: Color(0xff000000),
  onSecondary: Color(0xff000000),
  onSurface: Color(0xffffffff),
  onBackground: Color(0xffffffff),
  onError: Color(0xff000000),
  brightness: Brightness.dark,
);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Waste not',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 34, 34, 52),
        colorScheme: defaultColorScheme,
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void runthis() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('email')) {
      Timer(
          const Duration(seconds: 5),
          () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const DashboardScreen(),
                ),
              ));
    } else {
      Timer(
          const Duration(seconds: 5),
          () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const LoginPage(title: 'Login UI'))));
    }
  }

  @override
  void initState() {
    super.initState();
    runthis();
  }

  double opacityLevel = 1.0;
  bool _visible = true;
  void _changeOpacity() {
    Timer(const Duration(milliseconds: 1500), () {
      if (this.mounted) {
        setState(() {
          _visible = !_visible;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _changeOpacity();
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
          child: Container(
            color: const Color.fromARGB(255, 34, 34, 52),
            child: AnimatedOpacity(
              opacity: _visible ? 1.0 : 0.3,
              duration: const Duration(milliseconds: 500),
              child: AvatarGlow(
                endRadius: 60.0,
                child: Material(
                  // Replace this child with your own
                  elevation: 8.0,
                  shape: CircleBorder(),
                  child: CircleAvatar(
                    backgroundColor: Colors.grey[100],
                    child: Image.asset(
                      'assets/logo.png',
                      height: 200,
                    ),
                    radius: 30.0,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    ));
  }
}
