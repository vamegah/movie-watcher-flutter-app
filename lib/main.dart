import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'home_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions (
        apiKey: "AIzaSyAkHMGve5owhXlB4icCKpp7jxn2QqjJ5tE",
        authDomain: "moviewatcher-app-ec23d.firebaseapp.com",
        projectId: "moviewatcher-app-ec23d",
        storageBucket: "moviewatcher-app-ec23d.firebasestorage.app",
        messagingSenderId: "755281906125",
        appId: "1:755281906125:web:247c0b6c9f336545d0dc84",
        measurementId: "G-5P9Q96MG5E"
      ),
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie Watcher',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}