import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          Card(
            child: ListTile(
              title: Text('Home Page 1'),
              subtitle: Text('Home Page 1 Description'),
            ),
          ),
          Card(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Column(
                    children: const [
                      Text('Home Page 1'),
                      Text('Home Page 2'),
                    ],
                  ),
                  Spacer(),
                  Column(
                    children: [
                      Text('Home Page 1'),
                      Text('Home Page 2'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Text('Home Page 1'),
          Text('Home Page 2'),
        ],
      ),
    );
  }
}
