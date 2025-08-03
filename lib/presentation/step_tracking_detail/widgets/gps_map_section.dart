import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class GpsMapSection extends StatelessWidget {
  final VoidCallback onFullScreenTap;
  final bool hasGpsData;

  const GpsMapSection({
    Key? key,
    required this.onFullScreenTap,
    this.hasGpsData = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    return Container(
      width: double.infinity,
      height: 30.h,
      decoration: AppTheme.glassDecoration(
        isLight: isLight,
        borderRadius: 16,
      ),
      child: hasGpsData ? _buildMapView(context) : _buildNoGpsView(context),
    );
  }

  Widget _buildMapView(BuildContext context) {
    return Stack(
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
                  AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                  AppTheme.accentLight.withValues(alpha: 0.1),
                ],
              ),
            ),
            child: CustomPaint(
              painter: RoutePathPainter(),
              child: Container(),
            ),
          ),
        ),
        Positioned(
          top: 2.h,
          left: 4.w,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            decoration: AppTheme.glassDecoration(
              isLight: Theme.of(context).brightness == Brightness.light,
              borderRadius: 20,
              opacity: 0.9,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconWidget(
                  iconName: 'location_on',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 16,
                ),
                SizedBox(width: 1.w),
                Text(
                  'Live Route',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 2.h,
          right: 4.w,
          child: GestureDetector(
            onTap: onFullScreenTap,
            child: Container(
              padding: EdgeInsets.all(2.w),
              decoration: AppTheme.glassDecoration(
                isLight: Theme.of(context).brightness == Brightness.light,
                borderRadius: 20,
                opacity: 0.9,
              ),
              child: CustomIconWidget(
                iconName: 'fullscreen',
                color: AppTheme.lightTheme.primaryColor,
                size: 20,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 2.h,
          left: 4.w,
          right: 4.w,
          child: Container(
            padding: EdgeInsets.all(3.w),
            decoration: AppTheme.glassDecoration(
              isLight: Theme.of(context).brightness == Brightness.light,
              borderRadius: 12,
              opacity: 0.95,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMapStat(context, 'Distance', '2.4 km', 'directions_walk'),
                _buildMapStat(context, 'Duration', '32 min', 'timer'),
                _buildMapStat(context, 'Pace', '13:20/km', 'speed'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNoGpsView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'location_off',
            color: AppTheme.textMediumEmphasisLight,
            size: 48,
          ),
          SizedBox(height: 2.h),
          Text(
            'GPS Unavailable',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.textMediumEmphasisLight,
                ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Indoor step tracking active',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.textMediumEmphasisLight,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapStat(
      BuildContext context, String label, String value, String iconName) {
    return Column(
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: AppTheme.lightTheme.primaryColor,
          size: 16,
        ),
        SizedBox(height: 0.5.h),
        Text(
          value,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.textHighEmphasisLight,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 8.sp,
                color: AppTheme.textMediumEmphasisLight,
              ),
        ),
      ],
    );
  }
}

class RoutePathPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.lightTheme.primaryColor
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();

    // Simulate a walking route path
    path.moveTo(size.width * 0.1, size.height * 0.8);
    path.quadraticBezierTo(
      size.width * 0.3,
      size.height * 0.6,
      size.width * 0.5,
      size.height * 0.7,
    );
    path.quadraticBezierTo(
      size.width * 0.7,
      size.height * 0.8,
      size.width * 0.9,
      size.height * 0.3,
    );

    canvas.drawPath(path, paint);

    // Draw start point
    canvas.drawCircle(
      Offset(size.width * 0.1, size.height * 0.8),
      6,
      Paint()..color = AppTheme.lightTheme.primaryColor,
    );

    // Draw end point
    canvas.drawCircle(
      Offset(size.width * 0.9, size.height * 0.3),
      6,
      Paint()..color = AppTheme.secondaryLight,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
