import 'package:attandance_app/wrapper/auth_wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
 options: FirebaseOptions(
     apiKey: "AIzaSyAZ6CXkzbNaSPMoumWceztXZA_PMXX3PHI"  ,
     appId:"1:239818974327:android:a4bf35514862c8a8f5d272" ,
     messagingSenderId: "239818974327",
     projectId: "attendance-app-b1d25"
 ),
  );
  runApp(AttendanceApp());
}


class AttendanceApp extends StatelessWidget {
  const AttendanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Attandance App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light
        ),
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          centerTitle: true,
          elevation: 0,
        )
      ),
      home: AuthWrapper(),
    );
  }
}