import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/achievement_badges.dart';
import './widgets/gps_map_section.dart';
import './widgets/quick_actions.dart';
import './widgets/route_details_card.dart';
import './widgets/step_progress_ring.dart';
import './widgets/weekly_chart.dart';

class StepTrackingDetail extends StatefulWidget {
  const StepTrackingDetail({Key? key}) : super(key: key);

  @override
  State<StepTrackingDetail> createState() => _StepTrackingDetailState();
}

class _StepTrackingDetailState extends State<StepTrackingDetail> {
  final ScrollController _scrollController = ScrollController();
  bool _isRefreshing = false;
  int _selectedDayIndex = -1;

  // Mock data for step tracking
  final Map<String, dynamic> _stepData = {
    "currentSteps": 8247,
    "goalSteps": 10000,
    "todayDistance": "6.2 km",
    "todayDuration": "1h 24m",
    "todayCalories": "312 kcal",
    "todayPace": "13:30/km",
  };

  final List<Map<String, dynamic>> _weeklyData = [
    {"day": "Monday", "steps": 9245, "date": "2025-07-28"},
    {"day": "Tuesday", "steps": 7832, "date": "2025-07-29"},
    {"day": "Wednesday", "steps": 10156, "date": "2025-07-30"},
    {"day": "Thursday", "steps": 6543, "date": "2025-07-31"},
    {"day": "Friday", "steps": 8247, "date": "2025-08-01"},
    {"day": "Saturday", "steps": 0, "date": "2025-08-02"},
    {"day": "Sunday", "steps": 0, "date": "2025-08-03"},
  ];

  final List<Map<String, dynamic>> _achievements = [
    {
      "id": 1,
      "title": "Daily Goal",
      "icon": "flag",
      "unlocked": true,
      "date": "Jul 30",
    },
    {
      "id": 2,
      "title": "5K Steps",
      "icon": "directions_walk",
      "unlocked": true,
      "date": "Jul 28",
    },
    {
      "id": 3,
      "title": "Week Streak",
      "icon": "local_fire_department",
      "unlocked": false,
      "date": "",
    },
    {
      "id": 4,
      "title": "10K Master",
      "icon": "emoji_events",
      "unlocked": true,
      "date": "Jul 30",
    },
  ];

  final Map<String, dynamic> _routeData = {
    "distance": "6.2 km",
    "duration": "1h 24m",
    "avgPace": "13:30/km",
    "calories": "312 kcal",
  };

  @override
  void initState() {
    super.initState();
    _loadStepData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadStepData() async {
    // Simulate loading step data from sensors
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      setState(() {
        // Data is already loaded in mock format
      });
    }
  }

  Future<void> _refreshData() async {
    if (_isRefreshing) return;

    setState(() {
      _isRefreshing = true;
    });

    HapticFeedback.lightImpact();

    // Simulate refreshing sensor data
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _isRefreshing = false;
        // Update current steps with small increment to simulate real-time tracking
        _stepData["currentSteps"] = (_stepData["currentSteps"] as int) +
            (DateTime.now().millisecond % 10);
      });
    }
  }

  void _onDaySelected(int index) {
    HapticFeedback.selectionClick();
    setState(() {
      _selectedDayIndex = index;
    });

    if (index < _weeklyData.length) {
      final selectedDay = _weeklyData[index];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${selectedDay["day"]}: ${selectedDay["steps"]} steps',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: AppTheme.lightTheme.primaryColor,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  void _onFullScreenMapTap() {
    HapticFeedback.mediumImpact();
    Navigator.pushNamed(context, '/gps-map-view');
  }

  void _onShareProgress() {
    HapticFeedback.lightImpact();
    final steps = _stepData["currentSteps"] as int;
    final goal = _stepData["goalSteps"] as int;
    final progress = ((steps / goal) * 100).toInt();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Sharing: $steps steps today ($progress% of goal)',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: AppTheme.lightTheme.primaryColor,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _onExportData() {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'Step data exported to local storage',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppTheme.accentLight,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _onAdjustGoals() {
    HapticFeedback.lightImpact();
    _showGoalAdjustmentDialog();
  }

  void _showGoalAdjustmentDialog() {
    final TextEditingController goalController = TextEditingController(
      text: (_stepData["goalSteps"] as int).toString(),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            'Adjust Daily Goal',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: goalController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Daily Step Goal',
                  suffixText: 'steps',
                ),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              SizedBox(height: 2.h),
              Text(
                'Recommended: 8,000 - 12,000 steps per day',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.textMediumEmphasisLight,
                    ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(color: AppTheme.textMediumEmphasisLight),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final newGoal = int.tryParse(goalController.text);
                if (newGoal != null && newGoal > 0) {
                  setState(() {
                    _stepData["goalSteps"] = newGoal;
                  });
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Daily goal updated to ${newGoal.toString()} steps',
                        style: const TextStyle(color: Colors.white),
                      ),
                      backgroundColor: AppTheme.lightTheme.primaryColor,
                      duration: const Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  );
                }
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        color: AppTheme.lightTheme.primaryColor,
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              SizedBox(height: 3.h),
              WeeklyChart(
                weeklyData: _weeklyData,
                onDaySelected: _onDaySelected,
              ),
              SizedBox(height: 3.h),
              GpsMapSection(
                onFullScreenTap: _onFullScreenMapTap,
                hasGpsData: true,
              ),
              SizedBox(height: 3.h),
              RouteDetailsCard(routeData: _routeData),
              SizedBox(height: 3.h),
              AchievementBadges(achievements: _achievements),
              SizedBox(height: 3.h),
              QuickActions(
                onShareProgress: _onShareProgress,
                onExportData: _onExportData,
                onAdjustGoals: _onAdjustGoals,
              ),
              SizedBox(height: 4.h),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      elevation: 0,
      leading: IconButton(
        onPressed: () {
          HapticFeedback.lightImpact();
          Navigator.of(context).pop();
        },
        icon: CustomIconWidget(
          iconName: 'arrow_back',
          color: Theme.of(context).appBarTheme.foregroundColor ??
              AppTheme.textHighEmphasisLight,
          size: 24,
        ),
      ),
      title: Text(
        'Step Tracking',
        style: Theme.of(context).appBarTheme.titleTextStyle,
      ),
      actions: [
        IconButton(
          onPressed: () {
            HapticFeedback.lightImpact();
            Navigator.pushNamed(context, '/settings');
          },
          icon: CustomIconWidget(
            iconName: 'settings',
            color: Theme.of(context).appBarTheme.foregroundColor ??
                AppTheme.textHighEmphasisLight,
            size: 24,
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    final isLight = Theme.of(context).brightness == Brightness.light;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: AppTheme.glassDecoration(
        isLight: isLight,
        borderRadius: 20,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Today\'s Progress',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'August 1, 2025',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.textMediumEmphasisLight,
                          ),
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'directions_walk',
                          color: AppTheme.lightTheme.primaryColor,
                          size: 16,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          'Goal: ${(_stepData["goalSteps"] as int).toString()} steps',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppTheme.textMediumEmphasisLight,
                                  ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              StepProgressRing(
                currentSteps: _stepData["currentSteps"] as int,
                goalSteps: _stepData["goalSteps"] as int,
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  context,
                  'Distance',
                  _stepData["todayDistance"] as String,
                  'straighten',
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  context,
                  'Duration',
                  _stepData["todayDuration"] as String,
                  'timer',
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  context,
                  'Calories',
                  _stepData["todayCalories"] as String,
                  'local_fire_department',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
      BuildContext context, String label, String value, String iconName) {
    return Column(
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: AppTheme.lightTheme.primaryColor,
          size: 20,
        ),
        SizedBox(height: 1.h),
        Text(
          value,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.textHighEmphasisLight,
              ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.textMediumEmphasisLight,
                fontSize: 9.sp,
              ),
        ),
      ],
    );
  }
}
