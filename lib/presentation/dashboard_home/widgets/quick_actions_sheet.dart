import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class QuickActionsSheet extends StatelessWidget {
  final VoidCallback onStartGpsTracking;
  final VoidCallback onLogWater;
  final VoidCallback onViewWeeklyStats;
  final VoidCallback onOpenSettings;

  const QuickActionsSheet({
    Key? key,
    required this.onStartGpsTracking,
    required this.onLogWater,
    required this.onViewWeeklyStats,
    required this.onOpenSettings,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light
            ? AppTheme.surfaceLight
            : AppTheme.surfaceDark,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: AppTheme.dividerLight,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            'Quick Actions',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textHighEmphasisLight,
                ),
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  context,
                  'Start GPS',
                  'location_on',
                  AppTheme.primaryLight,
                  onStartGpsTracking,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildActionButton(
                  context,
                  'Log Water',
                  'water_drop',
                  AppTheme.primaryLight,
                  onLogWater,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.w),
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  context,
                  'Weekly Stats',
                  'bar_chart',
                  AppTheme.accentLight,
                  onViewWeeklyStats,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildActionButton(
                  context,
                  'Settings',
                  'settings',
                  AppTheme.textMediumEmphasisLight,
                  onOpenSettings,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String title,
    String iconName,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 3.h),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: color,
              size: 32,
            ),
            SizedBox(height: 1.h),
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: color,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
