// ✅ Define GoRouter with a ShellRoute to keep BottomNavBar static
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:location_test/main_scree.dart';
import 'package:location_test/pages/dashboard.dart';
import 'package:location_test/pages/location_page.dart';
import 'package:location_test/pages/more.dart';
import 'package:location_test/pages/profile.dart';

final GoRouter router = GoRouter(
  initialLocation: '/dashboard',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return MainScreen(child: child);
      },
      routes: [
        GoRoute(path: '/dashboard', builder: (context, state) => DashBoard(),),
        GoRoute(path: '/location', builder: (context, state) => GPSTrackingAttendance(),),
        GoRoute(
          path: '/profile',
          builder: (context, state) => Profile(),),
        
        GoRoute(path: '/more',builder: (context, state) => More(),),
      ],
    ),
  ],
);

// // ✅ Page transition wrapper
// CustomTransitionPage _buildPageWithTransition(GoRouterState state, Widget page) {
//   return CustomTransitionPage(
//     key: state.pageKey,
//     child: page,
//     transitionsBuilder: (context, animation, secondaryAnimation, child) {
//       return FadeTransition(opacity: animation, child: child);
//     },
//   );
// }


