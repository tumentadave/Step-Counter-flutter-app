import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class GpsStatusIndicator extends StatelessWidget {
  final bool hasGpsSignal;
  final double accuracy;
  final bool isLocationPermissionGranted;
  final int batteryLevel;
  final VoidCallback? onPermissionRequest;

  const GpsStatusIndicator({
    Key? key,
    required this.hasGpsSignal,
    required this.accuracy,
    required this.isLocationPermissionGranted,
    required this.batteryLevel,
    this.onPermissionRequest,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: AppTheme.glassDecoration(
        isLight: Theme.of(context).brightness == Brightness.light,
        borderRadius: 12.0,
        opacity: 0.9,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // GPS Signal Indicator
          _buildGpsIndicator(context),
          SizedBox(width: 2.w),
          // Location Permission Status
          if (!isLocationPermissionGranted) ...[
            _buildPermissionIndicator(context),
            SizedBox(width: 2.w),
          ],
          // Battery Indicator
          _buildBatteryIndicator(context),
        ],
      ),
    );
  }

  Widget _buildGpsIndicator(BuildContext context) {
    Color indicatorColor;
    String statusText;
    String iconName;

    if (!hasGpsSignal) {
      indicatorColor = AppTheme.secondaryLight;
      statusText = 'No GPS';
      iconName = 'gps_off';
    } else if (accuracy > 10) {
      indicatorColor = AppTheme.accentLight;
      statusText = 'Weak';
      iconName = 'gps_not_fixed';
    } else {
      indicatorColor = AppTheme.primaryLight;
      statusText = 'Strong';
      iconName = 'gps_fixed';
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: indicatorColor,
          size: 4.w,
        ),
        SizedBox(width: 1.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'GPS',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 10.sp,
                  ),
            ),
            Text(
              statusText,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: indicatorColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 9.sp,
                  ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPermissionIndicator(BuildContext context) {
    return GestureDetector(
      onTap: onPermissionRequest,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
        decoration: BoxDecoration(
          color: AppTheme.secondaryLight.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppTheme.secondaryLight.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: 'location_disabled',
              color: AppTheme.secondaryLight,
              size: 3.w,
            ),
            SizedBox(width: 1.w),
            Text(
              'Enable Location',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.secondaryLight,
                    fontWeight: FontWeight.w500,
                    fontSize: 9.sp,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBatteryIndicator(BuildContext context) {
    Color batteryColor;
    String batteryIcon;

    if (batteryLevel <= 20) {
      batteryColor = AppTheme.secondaryLight;
      batteryIcon = 'battery_alert';
    } else if (batteryLevel <= 50) {
      batteryColor = AppTheme.accentLight;
      batteryIcon = 'battery_3_bar';
    } else {
      batteryColor = AppTheme.primaryLight;
      batteryIcon = 'battery_full';
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomIconWidget(
          iconName: batteryIcon,
          color: batteryColor,
          size: 4.w,
        ),
        SizedBox(width: 1.w),
        Text(
          '${batteryLevel}%',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: batteryColor,
                fontWeight: FontWeight.w600,
                fontSize: 9.sp,
              ),
        ),
      ],
    );
  }
}
