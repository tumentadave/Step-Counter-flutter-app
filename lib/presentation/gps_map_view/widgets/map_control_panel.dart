import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MapControlPanel extends StatelessWidget {
  final String elapsedTime;
  final String distance;
  final String currentPace;
  final int stepCount;
  final bool isTracking;
  final VoidCallback onStartStop;
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;

  const MapControlPanel({
    Key? key,
    required this.elapsedTime,
    required this.distance,
    required this.currentPace,
    required this.stepCount,
    required this.isTracking,
    required this.onStartStop,
    required this.onZoomIn,
    required this.onZoomOut,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: AppTheme.glassDecoration(
        isLight: Theme.of(context).brightness == Brightness.light,
        borderRadius: 20.0,
        opacity: 0.9,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Session Stats Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem(
                context,
                'Time',
                elapsedTime,
                CustomIconWidget(
                  iconName: 'timer',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 5.w,
                ),
              ),
              _buildStatItem(
                context,
                'Distance',
                distance,
                CustomIconWidget(
                  iconName: 'straighten',
                  color: AppTheme.lightTheme.colorScheme.secondary,
                  size: 5.w,
                ),
              ),
              _buildStatItem(
                context,
                'Pace',
                currentPace,
                CustomIconWidget(
                  iconName: 'speed',
                  color: AppTheme.accentLight,
                  size: 5.w,
                ),
              ),
              _buildStatItem(
                context,
                'Steps',
                stepCount.toString(),
                CustomIconWidget(
                  iconName: 'directions_walk',
                  color: AppTheme.primaryLight,
                  size: 5.w,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          // Control Buttons Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Zoom Controls
              Row(
                children: [
                  _buildControlButton(
                    context,
                    CustomIconWidget(
                      iconName: 'zoom_in',
                      color: Theme.of(context).colorScheme.onSurface,
                      size: 6.w,
                    ),
                    onZoomIn,
                  ),
                  SizedBox(width: 2.w),
                  _buildControlButton(
                    context,
                    CustomIconWidget(
                      iconName: 'zoom_out',
                      color: Theme.of(context).colorScheme.onSurface,
                      size: 6.w,
                    ),
                    onZoomOut,
                  ),
                ],
              ),
              // Start/Stop Button
              _buildStartStopButton(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
      BuildContext context, String label, String value, Widget icon) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          SizedBox(height: 0.5.h),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton(
      BuildContext context, Widget icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 12.w,
        height: 6.h,
        decoration: AppTheme.glassDecoration(
          isLight: Theme.of(context).brightness == Brightness.light,
          borderRadius: 12.0,
          opacity: 0.8,
        ),
        child: Center(child: icon),
      ),
    );
  }

  Widget _buildStartStopButton(BuildContext context) {
    return GestureDetector(
      onTap: onStartStop,
      child: Container(
        width: 20.w,
        height: 8.h,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isTracking
                ? [AppTheme.secondaryLight, AppTheme.secondaryVariantLight]
                : [AppTheme.primaryLight, AppTheme.primaryVariantLight],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color:
                  (isTracking ? AppTheme.secondaryLight : AppTheme.primaryLight)
                      .withValues(alpha: 0.3),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: CustomIconWidget(
            iconName: isTracking ? 'stop' : 'play_arrow',
            color: Colors.white,
            size: 8.w,
          ),
        ),
      ),
    );
  }
}
