import 'package:flutter/material.dart';

import 'package:flutter_cfmid_1/user/view/splash_screen.dart';

void main() {
  runApp(const _App());
}

class _App extends StatelessWidget {
  const _App();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(fontFamily: 'NotoSnas'),
        debugShowCheckedModeBanner: false,
        home: const SplashScreen());
  }
}
