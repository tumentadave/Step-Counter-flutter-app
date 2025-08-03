import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class WaterIntakeCard extends StatefulWidget {
  final int currentIntake;
  final int dailyGoal;
  final VoidCallback onAddWater;

  const WaterIntakeCard({
    Key? key,
    required this.currentIntake,
    required this.dailyGoal,
    required this.onAddWater,
  }) : super(key: key);

  @override
  State<WaterIntakeCard> createState() => _WaterIntakeCardState();
}

class _WaterIntakeCardState extends State<WaterIntakeCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _fillController;
  late Animation<double> _fillAnimation;

  @override
  void initState() {
    super.initState();
    _fillController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _fillAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fillController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _fillController.dispose();
    super.dispose();
  }

  void _animateWaterFill() {
    HapticFeedback.lightImpact();
    _fillController.forward().then((_) {
      _fillController.reset();
    });
    widget.onAddWater();
  }

  @override
  Widget build(BuildContext context) {
    final progress = widget.currentIntake / widget.dailyGoal;
    final progressClamped = progress.clamp(0.0, 1.0);
    final glassesCount = (widget.currentIntake / 250).ceil();

    return Container(
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
                'Water Intake',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppTheme.textMediumEmphasisLight,
                    ),
              ),
              CustomIconWidget(
                iconName: 'water_drop',
                color: AppTheme.primaryLight,
                size: 24,
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.currentIntake} ml',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppTheme.primaryLight,
                          ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'Goal: ${widget.dailyGoal} ml',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textMediumEmphasisLight,
                          ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      '$glassesCount glasses today',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.textMediumEmphasisLight,
                          ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 4.w),
              Container(
                width: 25.w,
                height: 25.w,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 25.w,
                      height: 25.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppTheme.primaryLight.withValues(alpha: 0.3),
                          width: 3,
                        ),
                      ),
                    ),
                    AnimatedBuilder(
                      animation: _fillAnimation,
                      builder: (context, child) {
                        final animatedProgress =
                            progressClamped + (_fillAnimation.value * 0.1);
                        return Container(
                          width: 22.w,
                          height: 22.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                AppTheme.primaryLight.withValues(alpha: 0.8),
                                AppTheme.primaryLight.withValues(alpha: 0.4),
                                Colors.transparent,
                              ],
                              stops: [
                                0.0,
                                animatedProgress.clamp(0.0, 1.0),
                                1.0
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    Text(
                      '${(progressClamped * 100).toInt()}%',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textHighEmphasisLight,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Container(
            width: double.infinity,
            height: 1.h,
            decoration: BoxDecoration(
              color: AppTheme.primaryLight.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progressClamped,
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.primaryLight,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              Expanded(
                child: _buildWaterButton(
                  context,
                  '250ml',
                  'Glass',
                  () => _animateWaterFill(),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildWaterButton(
                  context,
                  '500ml',
                  'Bottle',
                  () => _animateWaterFill(),
                ),
              ),
            ],
          ),
          if (progress >= 1.0) ...[
            SizedBox(height: 2.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
              decoration: BoxDecoration(
                color: AppTheme.primaryVariantLight.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'check_circle',
                    color: AppTheme.primaryVariantLight,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Daily hydration goal achieved!',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.primaryVariantLight,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildWaterButton(
    BuildContext context,
    String amount,
    String type,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 2.h),
        decoration: BoxDecoration(
          color: AppTheme.primaryLight.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.primaryLight.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            CustomIconWidget(
              iconName: type == 'Glass' ? 'local_bar' : 'sports_bar',
              color: AppTheme.primaryLight,
              size: 24,
            ),
            SizedBox(height: 1.h),
            Text(
              amount,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryLight,
                  ),
            ),
            Text(
              type,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textMediumEmphasisLight,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
