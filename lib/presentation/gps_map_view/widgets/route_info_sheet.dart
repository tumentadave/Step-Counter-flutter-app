import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RouteInfoSheet extends StatelessWidget {
  final String totalDistance;
  final String totalTime;
  final String averagePace;
  final String elevationGain;
  final String caloriesBurned;
  final List<Map<String, dynamic>> splitTimes;
  final VoidCallback onShare;
  final VoidCallback onSave;

  const RouteInfoSheet({
    Key? key,
    required this.totalDistance,
    required this.totalTime,
    required this.averagePace,
    required this.elevationGain,
    required this.caloriesBurned,
    required this.splitTimes,
    required this.onShare,
    required this.onSave,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        maxHeight: 70.h,
        minHeight: 30.h,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle Bar
          Container(
            width: 12.w,
            height: 0.5.h,
            margin: EdgeInsets.symmetric(vertical: 1.h),
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .onSurfaceVariant
                  .withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Route Details',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                ),
                Row(
                  children: [
                    _buildActionButton(
                      context,
                      CustomIconWidget(
                        iconName: 'share',
                        color: AppTheme.primaryLight,
                        size: 5.w,
                      ),
                      onShare,
                    ),
                    SizedBox(width: 2.w),
                    _buildActionButton(
                      context,
                      CustomIconWidget(
                        iconName: 'save',
                        color: AppTheme.primaryLight,
                        size: 5.w,
                      ),
                      onSave,
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 2.h),
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Summary Stats
                  _buildSummarySection(context),
                  SizedBox(height: 3.h),
                  // Split Times
                  _buildSplitTimesSection(context),
                  SizedBox(height: 2.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
      BuildContext context, Widget icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 10.w,
        height: 5.h,
        decoration: AppTheme.glassDecoration(
          isLight: Theme.of(context).brightness == Brightness.light,
          borderRadius: 12.0,
          opacity: 0.8,
        ),
        child: Center(child: icon),
      ),
    );
  }

  Widget _buildSummarySection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: AppTheme.glassDecoration(
        isLight: Theme.of(context).brightness == Brightness.light,
        borderRadius: 16.0,
        opacity: 0.8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Summary',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildSummaryItem(
                  context,
                  'Distance',
                  totalDistance,
                  AppTheme.primaryLight,
                ),
              ),
              Expanded(
                child: _buildSummaryItem(
                  context,
                  'Time',
                  totalTime,
                  AppTheme.secondaryLight,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildSummaryItem(
                  context,
                  'Avg Pace',
                  averagePace,
                  AppTheme.accentLight,
                ),
              ),
              Expanded(
                child: _buildSummaryItem(
                  context,
                  'Elevation',
                  elevationGain,
                  AppTheme.primaryVariantLight,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          _buildSummaryItem(
            context,
            'Calories Burned',
            caloriesBurned,
            AppTheme.secondaryVariantLight,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(
      BuildContext context, String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 0.5.h),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: color,
              ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildSplitTimesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Split Times',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
        ),
        SizedBox(height: 1.h),
        Container(
          width: double.infinity,
          constraints: BoxConstraints(maxHeight: 25.h),
          decoration: AppTheme.glassDecoration(
            isLight: Theme.of(context).brightness == Brightness.light,
            borderRadius: 16.0,
            opacity: 0.8,
          ),
          child: splitTimes.isEmpty
              ? Padding(
                  padding: EdgeInsets.all(4.w),
                  child: Center(
                    child: Text(
                      'No split data available',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  padding: EdgeInsets.all(2.w),
                  itemCount: splitTimes.length,
                  separatorBuilder: (context, index) => Divider(
                    color: Theme.of(context)
                        .colorScheme
                        .outline
                        .withValues(alpha: 0.3),
                    height: 1,
                  ),
                  itemBuilder: (context, index) {
                    final split = splitTimes[index];
                    return Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Split ${index + 1}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                          ),
                          Row(
                            children: [
                              Text(
                                split['distance'] as String? ?? '0.0 km',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                    ),
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                split['time'] as String? ?? '00:00',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.primaryLight,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
