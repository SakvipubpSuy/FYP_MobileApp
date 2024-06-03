import 'package:flutter/material.dart';
import 'package:fyp_mobileapp/pages/decks_cards/deckspage.dart';
import 'package:fyp_mobileapp/pages/homepage.dart';
import 'package:fyp_mobileapp/pages/profilepage.dart';
import 'package:fyp_mobileapp/pages/qrscanpage.dart';
import 'package:fyp_mobileapp/pages/tradepage.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const HomePage(),
    const DeckPage(),
    const QRScan(),
    const TradePage(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   backgroundColor: Colors.black,
        //   automaticallyImplyLeading: false,
        // ),
        // body: Center(
        //   child: InkWell(
        //     onTap: () {
        //       Navigator.push(context,
        //           MaterialPageRoute(builder: (context) => const QRScan()));
        //     },
        //     child: const Text(
        //       'Welcome to the Dashboard',
        //       style: TextStyle(fontSize: 24),
        //     ),
        //   ),
        // ),
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          showUnselectedLabels: true,
          type: BottomNavigationBarType.shifting,
          items: <BottomNavigationBarItem>[
            const BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: Colors.blue,
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.card_travel),
              label: 'Deck',
              backgroundColor: Colors.blue,
            ),
            BottomNavigationBarItem(
              icon: GestureDetector(
                // onTap: () {
                //   Navigator.push(context,
                //       MaterialPageRoute(builder: (context) => const QRScan()));
                // },
                child: const Icon(Icons.qr_code_scanner),
              ),
              label: 'Scan',
              backgroundColor: Colors.blue,
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.currency_exchange),
              label: 'Trade',
              backgroundColor: Colors.blue,
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
              backgroundColor: Colors.blue,
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
        ));
  }
}
