import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/gps_map_card.dart';
import './widgets/quick_actions_sheet.dart';
import './widgets/step_counter_card.dart';
import './widgets/water_intake_card.dart';

class DashboardHome extends StatefulWidget {
  const DashboardHome({Key? key}) : super(key: key);

  @override
  State<DashboardHome> createState() => _DashboardHomeState();
}

class _DashboardHomeState extends State<DashboardHome>
    with TickerProviderStateMixin {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  // Mock data for fitness tracking
  final List<Map<String, dynamic>> _fitnessData = [
    {
      "currentSteps": 7842,
      "dailyStepGoal": 10000,
      "isWalking": true,
      "todayDistance": "5.2 km",
      "todayDuration": "1h 23m",
      "isGpsTracking": true,
      "currentWaterIntake": 1750,
      "dailyWaterGoal": 2500,
      "userName": "Alex",
      "lastUpdated": DateTime.now(),
    }
  ];

  int _selectedIndex = 0;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _refreshData() async {
    if (_isRefreshing) return;

    setState(() {
      _isRefreshing = true;
    });

    // Simulate data refresh
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      // Update mock data with new values
      _fitnessData[0]["currentSteps"] =
          (_fitnessData[0]["currentSteps"] as int) + 50;
      _fitnessData[0]["lastUpdated"] = DateTime.now();
      _isRefreshing = false;
    });
  }

  void _showQuickActionsSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => QuickActionsSheet(
        onStartGpsTracking: () {
          Navigator.pop(context);
          _toggleGpsTracking();
        },
        onLogWater: () {
          Navigator.pop(context);
          _addWaterIntake();
        },
        onViewWeeklyStats: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, '/step-tracking-detail');
        },
        onOpenSettings: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, '/settings');
        },
      ),
    );
  }

  void _toggleGpsTracking() {
    setState(() {
      _fitnessData[0]["isGpsTracking"] =
          !(_fitnessData[0]["isGpsTracking"] as bool);
    });
  }

  void _addWaterIntake() {
    setState(() {
      final currentIntake = _fitnessData[0]["currentWaterIntake"] as int;
      _fitnessData[0]["currentWaterIntake"] = currentIntake + 250;
    });
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        // Already on home
        break;
      case 1:
        Navigator.pushNamed(context, '/step-tracking-detail');
        break;
      case 2:
        Navigator.pushNamed(context, '/gps-map-view');
        break;
      case 3:
        Navigator.pushNamed(context, '/settings');
        break;
    }
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  String _getFormattedDate() {
    final now = DateTime.now();
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return '${months[now.month - 1]} ${now.day}, ${now.year}';
  }

  @override
  Widget build(BuildContext context) {
    final fitnessData = _fitnessData.first;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: _refreshData,
          color: AppTheme.primaryLight,
          child: CustomScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${_getGreeting()}, ${fitnessData["userName"]}!',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.textHighEmphasisLight,
                                    ),
                              ),
                              SizedBox(height: 0.5.h),
                              Text(
                                _getFormattedDate(),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: AppTheme.textMediumEmphasisLight,
                                    ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () =>
                                Navigator.pushNamed(context, '/profile-setup'),
                            child: Container(
                              width: 12.w,
                              height: 12.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [
                                    AppTheme.primaryLight,
                                    AppTheme.primaryVariantLight,
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.primaryLight
                                        .withValues(alpha: 0.3),
                                    blurRadius: 8,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  (fitnessData["userName"] as String)
                                      .substring(0, 1)
                                      .toUpperCase(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: AppTheme.onPrimaryLight,
                                      ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (_isRefreshing) ...[
                        SizedBox(height: 2.h),
                        Row(
                          children: [
                            SizedBox(
                              width: 4.w,
                              height: 4.w,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppTheme.primaryLight,
                                ),
                              ),
                            ),
                            SizedBox(width: 3.w),
                            Text(
                              'Updating fitness data...',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: AppTheme.textMediumEmphasisLight,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    SizedBox(height: 2.h),
                    StepCounterCard(
                      currentSteps: fitnessData["currentSteps"] as int,
                      dailyGoal: fitnessData["dailyStepGoal"] as int,
                      isWalking: fitnessData["isWalking"] as bool,
                      onTap: () =>
                          Navigator.pushNamed(context, '/step-tracking-detail'),
                    ),
                    GpsMapCard(
                      todayDistance: fitnessData["todayDistance"] as String,
                      todayDuration: fitnessData["todayDuration"] as String,
                      isTracking: fitnessData["isGpsTracking"] as bool,
                      onTap: _toggleGpsTracking,
                      onExpandMap: () =>
                          Navigator.pushNamed(context, '/gps-map-view'),
                    ),
                    WaterIntakeCard(
                      currentIntake: fitnessData["currentWaterIntake"] as int,
                      dailyGoal: fitnessData["dailyWaterGoal"] as int,
                      onAddWater: _addWaterIntake,
                    ),
                    SizedBox(height: 10.h), // Space for FAB
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showQuickActionsSheet,
        backgroundColor: AppTheme.primaryLight,
        foregroundColor: AppTheme.onPrimaryLight,
        elevation: 6,
        child: CustomIconWidget(
          iconName: 'add',
          color: AppTheme.onPrimaryLight,
          size: 28,
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.light
              ? AppTheme.surfaceGlassLight
              : AppTheme.surfaceGlassDark,
          boxShadow: [
            BoxShadow(
              color: AppTheme.shadowLight,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onBottomNavTap,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: AppTheme.primaryLight,
          unselectedItemColor: AppTheme.textMediumEmphasisLight,
          selectedLabelStyle: Theme.of(context).textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
          unselectedLabelStyle: Theme.of(context).textTheme.labelSmall,
          items: [
            BottomNavigationBarItem(
              icon: CustomIconWidget(
                iconName: 'home',
                color: _selectedIndex == 0
                    ? AppTheme.primaryLight
                    : AppTheme.textMediumEmphasisLight,
                size: 24,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: CustomIconWidget(
                iconName: 'directions_walk',
                color: _selectedIndex == 1
                    ? AppTheme.primaryLight
                    : AppTheme.textMediumEmphasisLight,
                size: 24,
              ),
              label: 'Steps',
            ),
            BottomNavigationBarItem(
              icon: CustomIconWidget(
                iconName: 'map',
                color: _selectedIndex == 2
                    ? AppTheme.primaryLight
                    : AppTheme.textMediumEmphasisLight,
                size: 24,
              ),
              label: 'Map',
            ),
            BottomNavigationBarItem(
              icon: CustomIconWidget(
                iconName: 'settings',
                color: _selectedIndex == 3
                    ? AppTheme.primaryLight
                    : AppTheme.textMediumEmphasisLight,
                size: 24,
              ),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
