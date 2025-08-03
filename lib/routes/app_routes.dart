import 'package:flutter/material.dart';
import '../presentation/profile_setup/profile_setup.dart';
import '../presentation/settings/settings.dart';
import '../presentation/step_tracking_detail/step_tracking_detail.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/gps_map_view/gps_map_view.dart';
import '../presentation/dashboard_home/dashboard_home.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String profileSetup = '/profile-setup';
  static const String settings = '/settings';
  static const String stepTrackingDetail = '/step-tracking-detail';
  static const String splash = '/splash-screen';
  static const String gpsMapView = '/gps-map-view';
  static const String dashboardHome = '/dashboard-home';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    profileSetup: (context) => const ProfileSetup(),
    settings: (context) => const Settings(),
    stepTrackingDetail: (context) => const StepTrackingDetail(),
    splash: (context) => const SplashScreen(),
    gpsMapView: (context) => const GpsMapView(),
    dashboardHome: (context) => const DashboardHome(),
    // TODO: Add your other routes here
  };
}
