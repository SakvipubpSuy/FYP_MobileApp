import 'package:flutter/material.dart';
import 'package:fyp_mobileapp/pages/auth/landingpage.dart';
import 'package:fyp_mobileapp/widgets/login_register_component.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const Text('Profile Page 1'),
            const Text('Profile Page 2'),
            const Spacer(),
            CustomCard(
                buttonText: "Logout",
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const LandingPage();
                  }));
                },
                color: Colors.blue),
          ],
        ),
      ),
    );
  }
}
