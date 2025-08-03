import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class StepProgressRing extends StatelessWidget {
  final int currentSteps;
  final int goalSteps;

  const StepProgressRing({
    Key? key,
    required this.currentSteps,
    required this.goalSteps,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final progress =
        goalSteps > 0 ? (currentSteps / goalSteps).clamp(0.0, 1.0) : 0.0;

    return Container(
      width: 35.w,
      height: 35.w,
      decoration: AppTheme.glassDecoration(
        isLight: Theme.of(context).brightness == Brightness.light,
        borderRadius: 100,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 30.w,
            height: 30.w,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 8,
              backgroundColor:
                  AppTheme.lightTheme.primaryColor.withValues(alpha: 0.2),
              valueColor: AlwaysStoppedAnimation<Color>(
                progress < 0.5
                    ? AppTheme.lightTheme.primaryColor
                    : progress < 0.8
                        ? AppTheme.accentLight
                        : AppTheme.lightTheme.primaryColor,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                currentSteps.toString(),
                style: AppTheme.dataTextTheme(
                        isLight:
                            Theme.of(context).brightness == Brightness.light)
                    .displayMedium
                    ?.copyWith(fontSize: 18.sp),
              ),
              Text(
                'steps',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.textMediumEmphasisLight,
                    ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                '${(progress * 100).toInt()}%',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppTheme.lightTheme.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
