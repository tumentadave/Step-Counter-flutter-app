import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ActivityLevelWidget extends StatefulWidget {
  final Function(Map<String, dynamic>) onActivityChanged;
  final String? initialActivity;

  const ActivityLevelWidget({
    Key? key,
    required this.onActivityChanged,
    this.initialActivity,
  }) : super(key: key);

  @override
  State<ActivityLevelWidget> createState() => _ActivityLevelWidgetState();
}

class _ActivityLevelWidgetState extends State<ActivityLevelWidget> {
  String _selectedActivity = 'Moderately Active';
  final PageController _pageController = PageController(viewportFraction: 0.8);

  final List<Map<String, dynamic>> _activityLevels = [
    {
      'title': 'Sedentary',
      'description': 'Little to no exercise',
      'steps': '< 5,000 steps/day',
      'icon': 'weekend',
      'multiplier': 1.2,
      'color': Color(0xFFE74C3C),
    },
    {
      'title': 'Lightly Active',
      'description': 'Light exercise 1-3 days/week',
      'steps': '5,000 - 7,500 steps/day',
      'icon': 'directions_walk',
      'multiplier': 1.375,
      'color': Color(0xFFE67E22),
    },
    {
      'title': 'Moderately Active',
      'description': 'Moderate exercise 3-5 days/week',
      'steps': '7,500 - 10,000 steps/day',
      'icon': 'directions_run',
      'multiplier': 1.55,
      'color': Color(0xFFF1C40F),
    },
    {
      'title': 'Very Active',
      'description': 'Hard exercise 6-7 days/week',
      'steps': '10,000 - 12,500 steps/day',
      'icon': 'fitness_center',
      'multiplier': 1.725,
      'color': Color(0xFF27AE60),
    },
    {
      'title': 'Extremely Active',
      'description': 'Very hard exercise, physical job',
      'steps': '> 12,500 steps/day',
      'icon': 'sports',
      'multiplier': 1.9,
      'color': Color(0xFF2ECC71),
    },
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialActivity != null) {
      _selectedActivity = widget.initialActivity!;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final index = _activityLevels
          .indexWhere((level) => level['title'] == _selectedActivity);
      if (index != -1) {
        _pageController.animateToPage(
          index,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });

    _notifyChanges();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _notifyChanges() {
    final selectedLevel = _activityLevels.firstWhere(
      (level) => level['title'] == _selectedActivity,
    );

    widget.onActivityChanged({
      'activityLevel': _selectedActivity,
      'multiplier': selectedLevel['multiplier'],
      'dailyStepsGoal': _calculateStepsGoal(selectedLevel),
    });
  }

  int _calculateStepsGoal(Map<String, dynamic> level) {
    switch (level['title']) {
      case 'Sedentary':
        return 5000;
      case 'Lightly Active':
        return 7500;
      case 'Moderately Active':
        return 10000;
      case 'Very Active':
        return 12500;
      case 'Extremely Active':
        return 15000;
      default:
        return 10000;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppTheme.glassDecoration(
        isLight: Theme.of(context).brightness == Brightness.light,
        borderRadius: 16,
      ),
      padding: EdgeInsets.all(6.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Activity Level',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(height: 2.h),
          Text(
            'Help us set your daily step goal',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.color
                      ?.withValues(alpha: 0.7),
                ),
          ),
          SizedBox(height: 4.h),
          SizedBox(
            height: 25.h,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _selectedActivity = _activityLevels[index]['title'];
                });
                _notifyChanges();
              },
              itemCount: _activityLevels.length,
              itemBuilder: (context, index) {
                final level = _activityLevels[index];
                final isSelected = level['title'] == _selectedActivity;

                return AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(horizontal: 2.w),
                  child: _buildActivityCard(level, isSelected),
                );
              },
            ),
          ),
          SizedBox(height: 3.h),
          _buildActivityIndicators(),
        ],
      ),
    );
  }

  Widget _buildActivityCard(Map<String, dynamic> level, bool isSelected) {
    return GestureDetector(
      onTap: () {
        final index = _activityLevels.indexOf(level);
        _pageController.animateToPage(
          index,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? level['color'].withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? level['color'] : Colors.transparent,
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: level['color'].withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ]
              : null,
        ),
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 15.w,
              height: 15.w,
              decoration: BoxDecoration(
                color: level['color'],
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: level['icon'],
                  color: Colors.white,
                  size: 8.w,
                ),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              level['title'],
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? level['color'] : null,
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.h),
            Text(
              level['description'],
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 1.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
              decoration: BoxDecoration(
                color: level['color'].withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                level['steps'],
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: level['color'],
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_activityLevels.length, (index) {
        final isSelected = _activityLevels[index]['title'] == _selectedActivity;
        return AnimatedContainer(
          duration: Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: 1.w),
          width: isSelected ? 8.w : 2.w,
          height: 1.h,
          decoration: BoxDecoration(
            color: isSelected
                ? _activityLevels[index]['color']
                : Colors.grey.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}
