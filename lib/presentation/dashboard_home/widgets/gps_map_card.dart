import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class GpsMapCard extends StatelessWidget {
  final String todayDistance;
  final String todayDuration;
  final bool isTracking;
  final VoidCallback onTap;
  final VoidCallback onExpandMap;

  const GpsMapCard({
    Key? key,
    required this.todayDistance,
    required this.todayDuration,
    required this.isTracking,
    required this.onTap,
    required this.onExpandMap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onExpandMap,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        padding: EdgeInsets.all(4.w),
        decoration: AppTheme.glassDecoration(
          isLight: Theme.of(context).brightness == Brightness.light,
          borderRadius: 20.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Today\'s Route',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppTheme.textMediumEmphasisLight,
                      ),
                ),
                Row(
                  children: [
                    if (isTracking) ...[
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryLight,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Tracking',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.primaryLight,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                      SizedBox(width: 3.w),
                    ],
                    CustomIconWidget(
                      iconName: 'map',
                      color: AppTheme.textMediumEmphasisLight,
                      size: 24,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 3.h),
            Container(
              width: double.infinity,
              height: 20.h,
              decoration: BoxDecoration(
                color: AppTheme.backgroundLight,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppTheme.dividerLight,
                  width: 1,
                ),
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppTheme.primaryLight.withValues(alpha: 0.1),
                            AppTheme.backgroundLight,
                            AppTheme.primaryLight.withValues(alpha: 0.05),
                          ],
                        ),
                      ),
                      child: CustomPaint(
                        painter: RoutePathPainter(
                          isTracking: isTracking,
                          pathColor: AppTheme.primaryLight,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 2.h,
                    right: 3.w,
                    child: GestureDetector(
                      onTap: onExpandMap,
                      child: Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceLight.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.shadowLight,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: CustomIconWidget(
                          iconName: 'fullscreen',
                          color: AppTheme.textHighEmphasisLight,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                  if (!isTracking && todayDistance == '0.0 km') ...[
                    Positioned.fill(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomIconWidget(
                              iconName: 'location_off',
                              color: AppTheme.textMediumEmphasisLight,
                              size: 32,
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              'No route tracked today',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: AppTheme.textMediumEmphasisLight,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(height: 3.h),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Distance',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.textMediumEmphasisLight,
                            ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        todayDistance,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textHighEmphasisLight,
                            ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 1,
                  height: 6.h,
                  color: AppTheme.dividerLight,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Duration',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.textMediumEmphasisLight,
                            ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        todayDuration,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textHighEmphasisLight,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            GestureDetector(
              onTap: onTap,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 2.h),
                decoration: BoxDecoration(
                  color: isTracking
                      ? AppTheme.secondaryLight.withValues(alpha: 0.1)
                      : AppTheme.primaryLight.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isTracking
                        ? AppTheme.secondaryLight
                        : AppTheme.primaryLight,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: isTracking ? 'stop' : 'play_arrow',
                      color: isTracking
                          ? AppTheme.secondaryLight
                          : AppTheme.primaryLight,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      isTracking ? 'Stop Tracking' : 'Start GPS Tracking',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: isTracking
                                ? AppTheme.secondaryLight
                                : AppTheme.primaryLight,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RoutePathPainter extends CustomPainter {
  final bool isTracking;
  final Color pathColor;

  RoutePathPainter({
    required this.isTracking,
    required this.pathColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (!isTracking) return;

    final paint = Paint()
      ..color = pathColor
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();

    // Sample route path for demonstration
    final points = [
      Offset(size.width * 0.1, size.height * 0.8),
      Offset(size.width * 0.3, size.height * 0.6),
      Offset(size.width * 0.5, size.height * 0.4),
      Offset(size.width * 0.7, size.height * 0.3),
      Offset(size.width * 0.9, size.height * 0.2),
    ];

    if (points.isNotEmpty) {
      path.moveTo(points.first.dx, points.first.dy);
      for (int i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }
      canvas.drawPath(path, paint);

      // Draw start point
      canvas.drawCircle(
        points.first,
        4,
        Paint()..color = pathColor,
      );

      // Draw end point
      canvas.drawCircle(
        points.last,
        4,
        Paint()..color = pathColor,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
