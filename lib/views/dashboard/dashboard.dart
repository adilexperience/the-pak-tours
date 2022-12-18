import 'package:flutter/material.dart';
import 'package:the_pak_tours/views/views_exporter.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int activeIndex = 0;
  final List<Widget> screens = [
    const MapScreen(),
    const SearchScreen(),
    NotificationsScreen(),
    const TouristProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          screens[activeIndex],
          Positioned(
            bottom: 10.0,
            left: 0.0,
            right: 0.0,
            child: BottomNavBar(
              screenChanged: (index) {
                print("$index  is selected now");
                activeIndex = index;
                setState(() {});
              },
            ),
          ),
        ],
      ),
    );
  }
}
