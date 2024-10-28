import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  // Track the expanded state for each tile
  bool _isAppTileExpanded = false;
  bool _isDevelopersTileExpanded = false;
  bool _isAdvisorTileExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.amber),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'About Us',
          style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF2F2F85),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1A1A4D), Color(0xFF2F2F85)],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            ExpansionTile(
              title: _buildTitle('About the App', _isAppTileExpanded),
              iconColor: Colors.amber,
              collapsedIconColor: Colors.white,
              onExpansionChanged: (expanded) {
                setState(() {
                  _isAppTileExpanded = expanded;
                });
              },
              visualDensity: const VisualDensity(
                  horizontal: 0, vertical: -1), // Adjust the density
              childrenPadding: const EdgeInsets.all(8.0),
              tilePadding: const EdgeInsets.symmetric(horizontal: 16.0),
              trailing: AnimatedRotation(
                turns: _isAppTileExpanded ? 0.5 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  Icons.expand_more,
                  color: _isAppTileExpanded ? Colors.amber : Colors.white,
                ),
              ),
              children: const [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'UniSaga is a gamified mobile app that transforms university life into an engaging adventure.'
                    'By scanning QR codes hidden around campus, students unlock virtual cards containing information about university staff, courses, and facilities '
                    'Completing quests and collecting cards rewards students with valuable knowledge and a deeper connection to their university.',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ExpansionTile(
              title: _buildTitle('Developers', _isDevelopersTileExpanded),
              iconColor: Colors.amber,
              collapsedIconColor: Colors.white,
              onExpansionChanged: (expanded) {
                setState(() {
                  _isDevelopersTileExpanded = expanded;
                });
              },
              visualDensity: const VisualDensity(
                  horizontal: 0, vertical: -1), // Adjust the density
              childrenPadding: const EdgeInsets.all(8.0),
              tilePadding: const EdgeInsets.symmetric(horizontal: 16.0),
              trailing: AnimatedRotation(
                turns: _isDevelopersTileExpanded ? 0.5 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  Icons.expand_more,
                  color:
                      _isDevelopersTileExpanded ? Colors.amber : Colors.white,
                ),
              ),
              children: const [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    '• Developer 1: Sakvipubp Suy\n'
                    '• Developer 2: Samrin Nuon\n',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ExpansionTile(
              title: _buildTitle('Advisor', _isAdvisorTileExpanded),
              iconColor: Colors.amber,
              collapsedIconColor: Colors.white,
              onExpansionChanged: (expanded) {
                setState(() {
                  _isAdvisorTileExpanded = expanded;
                });
              },
              visualDensity: const VisualDensity(
                  horizontal: 0, vertical: -1), // Adjust the density
              childrenPadding: const EdgeInsets.all(8.0),
              tilePadding: const EdgeInsets.symmetric(horizontal: 16.0),
              trailing: AnimatedRotation(
                turns: _isAdvisorTileExpanded ? 0.5 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  Icons.expand_more,
                  color: _isAdvisorTileExpanded ? Colors.amber : Colors.white,
                ),
              ),
              children: const [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Advisor(s) that has been instrumental in guiding our team to success:\n'
                    '• Advisor: Dr.Mony Ho\n',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Method to dynamically build title with color changing based on expanded state
  Widget _buildTitle(String title, bool isExpanded) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: isExpanded ? Colors.amber : Colors.white,
      ),
    );
  }
}
