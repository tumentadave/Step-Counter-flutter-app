import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AppInfoWidget extends StatelessWidget {
  final Map<String, dynamic> appInfo;
  final VoidCallback onCheckUpdates;

  const AppInfoWidget({
    Key? key,
    required this.appInfo,
    required this.onCheckUpdates,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: AppTheme.glassDecoration(
        isLight: Theme.of(context).brightness == Brightness.light,
        borderRadius: 16.0,
      ),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          children: [
            Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryLight,
                    AppTheme.primaryLight.withValues(alpha: 0.7),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryLight.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'directions_walk',
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              "WalkKamer",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primaryLight,
                  ),
            ),
            SizedBox(height: 0.5.h),
            Text(
              "Fitness Tracking Companion",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textMediumEmphasisLight,
                  ),
            ),
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: AppTheme.primaryLight.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.primaryLight.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Version",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.textMediumEmphasisLight,
                            ),
                      ),
                      Text(
                        appInfo["version"] as String? ?? "1.0.0",
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Build",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.textMediumEmphasisLight,
                            ),
                      ),
                      Text(
                        appInfo["build"] as String? ?? "100",
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 2.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onCheckUpdates,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryLight.withValues(alpha: 0.1),
                  foregroundColor: AppTheme.primaryLight,
                  elevation: 0,
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: AppTheme.primaryLight.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'system_update',
                      color: AppTheme.primaryLight,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      "Check for Updates",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: AppTheme.primaryLight,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              "© 2025 WalkKamer. All rights reserved.",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textMediumEmphasisLight,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
