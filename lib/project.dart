import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/pages/addproject.dart';
import 'package:frontend/profile.dart';

class project_home extends StatefulWidget {

  @override
  _project_home createState() => _project_home();
}

class _project_home extends State<project_home> {
  int _selectedIndex = 0;
  final storage = const FlutterSecureStorage();

  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _CreationDate = TextEditingController();
  final _description = TextEditingController();
  final _task = TextEditingController();
  
  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void dispose() {
    //
    _name.dispose();
    _CreationDate.dispose();
    _description.dispose();
    _task.dispose;
    dispose();
  }
  final List<Widget> _pages = [
    //homePage(),
    addproject(),
    // profilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor:const Color(0xff4281A4),
          currentIndex: _selectedIndex,
          type: BottomNavigationBarType.fixed,
          onTap: _navigateBottomBar,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Create Project'),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_circle_rounded),
                label: 'Profile'
            ),
          ],
          selectedItemColor:Colors.white ,
          unselectedItemColor:const Color.fromARGB(255, 207, 207, 207),
        ));
  }
}