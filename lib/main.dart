import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'screens/home_page.dart' as home;
import 'screens/profile_page.dart' as profile;
import 'screens/notif_page.dart' as notif;
import 'screens/map_page.dart' as map;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String _title = 'Partouille';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
      home: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key});

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;
  Widget page = home.HomePage();
  List<Widget> _widgetOptions = <Widget>[
    home.HomePage(),
    map.MapPage(),
    notif.NotificationPage(),
    profile.ProfilePage(),
  ];
  Position? position;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index > 0 && index < _widgetOptions.length) {
        page = _widgetOptions.elementAt(index);
      } else {
        page = home.HomePage();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BottomNavigationBar Sample'),
      ),
      body: page,
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Acceuil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Carte',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Color.fromARGB(255, 85, 85, 85),
        onTap: _onItemTapped,
      ),
    );
  }
}
