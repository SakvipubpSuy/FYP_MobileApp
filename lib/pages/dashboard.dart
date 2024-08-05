import 'package:flutter/material.dart';
import 'package:fyp_mobileapp/pages/decks_cards/deckspage.dart';
import 'package:fyp_mobileapp/pages/homepage.dart';
import 'package:fyp_mobileapp/pages/profilepage.dart';
import 'package:fyp_mobileapp/pages/qrscanpage.dart';
import 'package:fyp_mobileapp/pages/trades/tradepage.dart';

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
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              backgroundColor: Color(0xFF1A1A4D),
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.collections_bookmark),
              label: 'Deck',
              backgroundColor: Color(0xFF1A1A4D),
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
              backgroundColor: const Color(0xFF1A1A4D),
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.currency_exchange),
              label: 'Trade',
              backgroundColor: Color(0xFF1A1A4D),
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
              backgroundColor: Color(0xFF1A1A4D),
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.yellow[700],
          onTap: _onItemTapped,
        ));
  }
}
