import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class HealthIntegrationWidget extends StatelessWidget {
  final Map<String, dynamic> healthData;
  final Function(String, bool) onToggleSync;

  const HealthIntegrationWidget({
    Key? key,
    required this.healthData,
    required this.onToggleSync,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: AppTheme.glassDecoration(
        isLight: Theme.of(context).brightness == Brightness.light,
        borderRadius: 16.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(4.w, 3.h, 4.w, 1.h),
            child: Text(
              "Health Integrations",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryLight,
                  ),
            ),
          ),
          _buildHealthIntegrationItem(
            context,
            "Apple Health",
            "apple_health",
            "Sync steps and health data",
            healthData["appleHealthConnected"] as bool? ?? false,
            healthData["appleHealthLastSync"] as String?,
            Colors.red,
          ),
          Divider(
            height: 1,
            color: AppTheme.dividerLight.withValues(alpha: 0.3),
            indent: 4.w,
            endIndent: 4.w,
          ),
          _buildHealthIntegrationItem(
            context,
            "Google Fit",
            "google_fit",
            "Sync fitness activities and metrics",
            healthData["googleFitConnected"] as bool? ?? false,
            healthData["googleFitLastSync"] as String?,
            Colors.blue,
          ),
          SizedBox(height: 1.h),
        ],
      ),
    );
  }

  Widget _buildHealthIntegrationItem(
    BuildContext context,
    String title,
    String key,
    String description,
    bool isConnected,
    String? lastSync,
    Color iconColor,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Row(
        children: [
          Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: key == "apple_health" ? 'favorite' : 'fitness_center',
                color: iconColor,
                size: 24,
              ),
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: isConnected
                            ? AppTheme.primaryLight.withValues(alpha: 0.1)
                            : Colors.grey.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        isConnected ? "Connected" : "Disconnected",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: isConnected
                                  ? AppTheme.primaryLight
                                  : Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 0.5.h),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textMediumEmphasisLight,
                      ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                if (isConnected && lastSync != null) ...[
                  SizedBox(height: 0.5.h),
                  Text(
                    "Last sync: $lastSync",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textMediumEmphasisLight,
                          fontSize: 10.sp,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          SizedBox(width: 2.w),
          Switch(
            value: isConnected,
            onChanged: (value) => onToggleSync(key, value),
            activeColor: AppTheme.primaryLight,
          ),
        ],
      ),
    );
  }
}
