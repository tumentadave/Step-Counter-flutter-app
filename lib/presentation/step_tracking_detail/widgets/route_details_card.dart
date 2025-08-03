import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class RouteDetailsCard extends StatelessWidget {
  final Map<String, dynamic> routeData;

  const RouteDetailsCard({
    Key? key,
    required this.routeData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: AppTheme.glassDecoration(
        isLight: isLight,
        borderRadius: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'route',
                color: AppTheme.lightTheme.primaryColor,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'Today\'s Route Details',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              Expanded(
                child: _buildDetailItem(
                  context,
                  'Distance',
                  routeData['distance'] as String,
                  'straighten',
                  AppTheme.lightTheme.primaryColor,
                ),
              ),
              Expanded(
                child: _buildDetailItem(
                  context,
                  'Duration',
                  routeData['duration'] as String,
                  'timer',
                  AppTheme.accentLight,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildDetailItem(
                  context,
                  'Avg Pace',
                  routeData['avgPace'] as String,
                  'speed',
                  AppTheme.secondaryLight,
                ),
              ),
              Expanded(
                child: _buildDetailItem(
                  context,
                  'Calories',
                  routeData['calories'] as String,
                  'local_fire_department',
                  AppTheme.secondaryVariantLight,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'info',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 16,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    'Route automatically tracked using GPS. Data stored locally on your device.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.lightTheme.primaryColor,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(
    BuildContext context,
    String label,
    String value,
    String iconName,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(3.w),
      margin: EdgeInsets.symmetric(horizontal: 1.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: iconName,
            color: color,
            size: 24,
          ),
          SizedBox(height: 1.h),
          Text(
            value,
            style: AppTheme.dataTextTheme(
              isLight: Theme.of(context).brightness == Brightness.light,
            ).headlineSmall?.copyWith(
                  fontSize: 14.sp,
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
      ),
    );
  }
}
