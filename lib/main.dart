import 'package:flutter/material.dart';

import 'core/routes/router_generator.dart';
import 'core/routes/routing_constants.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Music Player',
      onGenerateRoute: RouterGenerator.generateRoute,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        accentColor: Colors.amberAccent,
      ),
      initialRoute: HomeScreenRoute,
    );
  }
}
