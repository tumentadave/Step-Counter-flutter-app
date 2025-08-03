import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/app_info_widget.dart';
import './widgets/health_integration_widget.dart';
import './widgets/profile_section_widget.dart';
import './widgets/settings_section_widget.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  // Mock user profile data
  final Map<String, dynamic> userProfile = {
    "name": "Sarah Johnson",
    "avatar":
        "https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face",
    "height": "168",
    "weight": "62",
    "todaySteps": 12847,
    "waterIntake": 6,
  };

  // Mock health integration data
  final Map<String, dynamic> healthData = {
    "appleHealthConnected": true,
    "appleHealthLastSync": "2 hours ago",
    "googleFitConnected": false,
    "googleFitLastSync": null,
  };

  // Mock app info data
  final Map<String, dynamic> appInfo = {
    "version": "1.2.3",
    "build": "145",
    "lastUpdate": "2025-07-28",
  };

  // Settings state
  Map<String, dynamic> settingsState = {
    "waterReminders": true,
    "achievements": true,
    "permissions": true,
    "theme": "System",
    "sounds": true,
    "haptics": true,
    "units": "Metric",
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            _buildAppBar(context),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  SizedBox(height: 2.h),
                  ProfileSectionWidget(
                    userProfile: userProfile,
                    onEditProfile: _onEditProfile,
                  ),
                  _buildProfileSettings(),
                  _buildNotificationSettings(),
                  _buildDataPrivacySettings(),
                  _buildAppPreferences(),
                  HealthIntegrationWidget(
                    healthData: healthData,
                    onToggleSync: _onToggleHealthSync,
                  ),
                  _buildSupportSettings(),
                  _buildAdvancedSettings(),
                  AppInfoWidget(
                    appInfo: appInfo,
                    onCheckUpdates: _onCheckUpdates,
                  ),
                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 12.h,
      floating: false,
      pinned: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          margin: EdgeInsets.all(2.w),
          decoration: AppTheme.glassDecoration(
            isLight: Theme.of(context).brightness == Brightness.light,
            borderRadius: 12.0,
            opacity: 0.7,
          ),
          child: Center(
            child: CustomIconWidget(
              iconName: 'arrow_back_ios',
              color: Theme.of(context).colorScheme.onSurface,
              size: 20,
            ),
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          "Settings",
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.onSurface,
              ),
        ),
        centerTitle: false,
        titlePadding: EdgeInsets.only(left: 16.w, bottom: 2.h),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.primaryLight.withValues(alpha: 0.1),
                Colors.transparent,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSettings() {
    final List<Map<String, dynamic>> profileItems = [
      {
        "key": "profile",
        "title": "Edit Personal Information",
        "subtitle": "Update your name, height, weight, and goals",
        "icon": "person",
        "type": "navigation",
      },
      {
        "key": "units",
        "title": "Units Preference",
        "subtitle": "Choose between metric and imperial units",
        "icon": "straighten",
        "type": "dropdown",
        "value": settingsState["units"],
      },
      {
        "key": "privacy",
        "title": "Privacy Settings",
        "subtitle": "Manage your data privacy preferences",
        "icon": "privacy_tip",
        "type": "navigation",
      },
    ];

    return SettingsSectionWidget(
      title: "Profile",
      items: profileItems,
      onItemChanged: _onSettingChanged,
      onItemTapped: _onSettingTapped,
    );
  }

  Widget _buildNotificationSettings() {
    final List<Map<String, dynamic>> notificationItems = [
      {
        "key": "water_reminders",
        "title": "Water Reminders",
        "subtitle": "Get notified to stay hydrated throughout the day",
        "icon": "notifications",
        "type": "switch",
        "value": settingsState["waterReminders"],
      },
      {
        "key": "achievements",
        "title": "Achievement Alerts",
        "subtitle": "Celebrate your fitness milestones and goals",
        "icon": "emoji_events",
        "type": "switch",
        "value": settingsState["achievements"],
      },
      {
        "key": "permissions",
        "title": "System Permissions",
        "subtitle": "Manage app permissions for location and health data",
        "icon": "security",
        "type": "navigation",
      },
    ];

    return SettingsSectionWidget(
      title: "Notifications",
      items: notificationItems,
      onItemChanged: _onSettingChanged,
      onItemTapped: _onSettingTapped,
    );
  }

  Widget _buildDataPrivacySettings() {
    final List<Map<String, dynamic>> dataItems = [
      {
        "key": "export_data",
        "title": "Export Data",
        "subtitle": "Download your fitness data as CSV or PDF",
        "icon": "file_download",
        "type": "navigation",
      },
      {
        "key": "clear_cache",
        "title": "Clear Cache",
        "subtitle": "Free up storage space by clearing temporary data",
        "icon": "cleaning_services",
        "type": "navigation",
      },
      {
        "key": "privacy_policy",
        "title": "Privacy Policy",
        "subtitle": "Learn how we protect and handle your data",
        "icon": "policy",
        "type": "navigation",
      },
    ];

    return SettingsSectionWidget(
      title: "Data & Privacy",
      items: dataItems,
      onItemTapped: _onSettingTapped,
    );
  }

  Widget _buildAppPreferences() {
    final List<Map<String, dynamic>> appItems = [
      {
        "key": "theme",
        "title": "Theme",
        "subtitle": "Choose your preferred app appearance",
        "icon": "palette",
        "type": "dropdown",
        "value": settingsState["theme"],
      },
      {
        "key": "sounds",
        "title": "Sound Effects",
        "subtitle": "Enable audio feedback for interactions",
        "icon": "volume_up",
        "type": "switch",
        "value": settingsState["sounds"],
      },
      {
        "key": "haptics",
        "title": "Haptic Feedback",
        "subtitle": "Feel vibrations for button taps and gestures",
        "icon": "vibration",
        "type": "switch",
        "value": settingsState["haptics"],
      },
    ];

    return SettingsSectionWidget(
      title: "App Preferences",
      items: appItems,
      onItemChanged: _onSettingChanged,
      onItemTapped: _onSettingTapped,
    );
  }

  Widget _buildSupportSettings() {
    final List<Map<String, dynamic>> supportItems = [
      {
        "key": "help",
        "title": "Help & FAQ",
        "subtitle": "Find answers to common questions",
        "icon": "help",
        "type": "navigation",
      },
      {
        "key": "contact",
        "title": "Contact Support",
        "subtitle": "Get help from our support team",
        "icon": "support_agent",
        "type": "navigation",
      },
      {
        "key": "feedback",
        "title": "Send Feedback",
        "subtitle": "Share your thoughts and suggestions",
        "icon": "feedback",
        "type": "navigation",
      },
    ];

    return SettingsSectionWidget(
      title: "Support",
      items: supportItems,
      onItemTapped: _onSettingTapped,
    );
  }

  Widget _buildAdvancedSettings() {
    final List<Map<String, dynamic>> advancedItems = [
      {
        "key": "sensor_calibration",
        "title": "Sensor Calibration",
        "subtitle": "Calibrate step counter for better accuracy",
        "icon": "tune",
        "type": "navigation",
      },
      {
        "key": "gps_accuracy",
        "title": "GPS Accuracy",
        "subtitle": "Adjust location tracking precision settings",
        "icon": "gps_fixed",
        "type": "navigation",
      },
      {
        "key": "battery_optimization",
        "title": "Battery Optimization",
        "subtitle": "Learn how to optimize battery usage",
        "icon": "battery_saver",
        "type": "navigation",
      },
    ];

    return SettingsSectionWidget(
      title: "Advanced",
      items: advancedItems,
      onItemTapped: _onSettingTapped,
    );
  }

  void _onEditProfile() {
    Navigator.pushNamed(context, '/profile-setup');
  }

  void _onSettingChanged(String key, dynamic value) {
    setState(() {
      settingsState[key] = value;
    });

    // Show feedback for setting changes
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${_getSettingTitle(key)} updated"),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _onSettingTapped(String key) {
    switch (key) {
      case "profile":
        Navigator.pushNamed(context, '/profile-setup');
        break;
      case "units":
        _showUnitsDialog();
        break;
      case "theme":
        _showThemeDialog();
        break;
      case "privacy":
      case "permissions":
      case "export_data":
      case "clear_cache":
      case "privacy_policy":
      case "help":
      case "contact":
      case "feedback":
      case "sensor_calibration":
      case "gps_accuracy":
      case "battery_optimization":
        _showComingSoonDialog(key);
        break;
    }
  }

  void _onToggleHealthSync(String platform, bool enabled) {
    setState(() {
      if (platform == "apple_health") {
        healthData["appleHealthConnected"] = enabled;
        if (enabled) {
          healthData["appleHealthLastSync"] = "Just now";
        }
      } else if (platform == "google_fit") {
        healthData["googleFitConnected"] = enabled;
        if (enabled) {
          healthData["googleFitLastSync"] = "Just now";
        }
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "${platform == "apple_health" ? "Apple Health" : "Google Fit"} ${enabled ? "connected" : "disconnected"}",
        ),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _onCheckUpdates() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("You're using the latest version!"),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _showUnitsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Units Preference"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: Text("Metric (kg, cm, km)"),
              value: "Metric",
              groupValue: settingsState["units"],
              onChanged: (value) {
                setState(() {
                  settingsState["units"] = value;
                });
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: Text("Imperial (lbs, ft, miles)"),
              value: "Imperial",
              groupValue: settingsState["units"],
              onChanged: (value) {
                setState(() {
                  settingsState["units"] = value;
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
        ],
      ),
    );
  }

  void _showThemeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Theme"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: Text("System"),
              value: "System",
              groupValue: settingsState["theme"],
              onChanged: (value) {
                setState(() {
                  settingsState["theme"] = value;
                });
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: Text("Light"),
              value: "Light",
              groupValue: settingsState["theme"],
              onChanged: (value) {
                setState(() {
                  settingsState["theme"] = value;
                });
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: Text("Dark"),
              value: "Dark",
              groupValue: settingsState["theme"],
              onChanged: (value) {
                setState(() {
                  settingsState["theme"] = value;
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
        ],
      ),
    );
  }

  void _showComingSoonDialog(String feature) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Coming Soon"),
        content: Text(
            "${_getSettingTitle(feature)} will be available in a future update."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  String _getSettingTitle(String key) {
    switch (key) {
      case "water_reminders":
        return "Water Reminders";
      case "achievements":
        return "Achievement Alerts";
      case "sounds":
        return "Sound Effects";
      case "haptics":
        return "Haptic Feedback";
      case "units":
        return "Units Preference";
      case "theme":
        return "Theme";
      case "privacy":
        return "Privacy Settings";
      case "permissions":
        return "System Permissions";
      case "export_data":
        return "Export Data";
      case "clear_cache":
        return "Clear Cache";
      case "privacy_policy":
        return "Privacy Policy";
      case "help":
        return "Help & FAQ";
      case "contact":
        return "Contact Support";
      case "feedback":
        return "Send Feedback";
      case "sensor_calibration":
        return "Sensor Calibration";
      case "gps_accuracy":
        return "GPS Accuracy";
      case "battery_optimization":
        return "Battery Optimization";
      default:
        return "Setting";
    }
  }
}
