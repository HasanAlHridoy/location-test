import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainScreen extends StatelessWidget {
  final Widget child;
  const MainScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child, // This will change while keeping BottomNavBar fixed
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _getSelectedIndex(context),
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/dashboard'); 
              break;
            case 1:
              context.go('/location');
              break;
            case 2:
              context.go('/profile');
              break;
            case 3:
              context.go('/more');
              break;
          }
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Location'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'More'),
        ],
      ),
    );
    
  }
   int _getSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/location')) return 1;
    if (location.startsWith('/profile')) return 2;
    if (location.startsWith('/more')) return 3;
    return 0;
  }
}