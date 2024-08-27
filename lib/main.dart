import 'package:flutter/material.dart';
import 'db/db_helper.dart';
import 'pages/auth/landingpage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Recreate the database for testing purposes
  DatabaseHelper dbHelper = DatabaseHelper();
  await dbHelper.recreateDatabase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            final maxWidth = constraints.maxWidth;
            final targetWidth =
                maxWidth < 600 ? maxWidth : 400; // Constrain width
            final targetHeight = constraints.maxHeight;

            return Center(
              child: SizedBox(
                width: targetWidth.toDouble(),
                height: targetHeight,
                child: const LandingPage(),
              ),
            );
          },
        ),
      ),
    );
  }
}
