import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class StepCounterCard extends StatefulWidget {
  final int currentSteps;
  final int dailyGoal;
  final bool isWalking;
  final VoidCallback onTap;

  const StepCounterCard({
    Key? key,
    required this.currentSteps,
    required this.dailyGoal,
    required this.isWalking,
    required this.onTap,
  }) : super(key: key);

  @override
  State<StepCounterCard> createState() => _StepCounterCardState();
}

class _StepCounterCardState extends State<StepCounterCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    if (widget.isWalking) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(StepCounterCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isWalking && !oldWidget.isWalking) {
      _pulseController.repeat(reverse: true);
    } else if (!widget.isWalking && oldWidget.isWalking) {
      _pulseController.stop();
      _pulseController.reset();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = widget.currentSteps / widget.dailyGoal;
    final progressClamped = progress.clamp(0.0, 1.0);

    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: widget.isWalking ? _pulseAnimation.value : 1.0,
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
                        'Steps Today',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: AppTheme.textMediumEmphasisLight,
                                ),
                      ),
                      CustomIconWidget(
                        iconName: 'directions_walk',
                        color: widget.isWalking
                            ? AppTheme.primaryLight
                            : AppTheme.textMediumEmphasisLight,
                        size: 24,
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${widget.currentSteps.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.primaryLight,
                                  ),
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              'Goal: ${widget.dailyGoal.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} steps',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: AppTheme.textMediumEmphasisLight,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 20.w,
                        height: 20.w,
                        child: Stack(
                          children: [
                            Container(
                              width: 20.w,
                              height: 20.w,
                              child: CircularProgressIndicator(
                                value: progressClamped,
                                strokeWidth: 6,
                                backgroundColor: AppTheme.primaryLight
                                    .withValues(alpha: 0.2),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  progress >= 1.0
                                      ? AppTheme.primaryVariantLight
                                      : AppTheme.primaryLight,
                                ),
                              ),
                            ),
                            Positioned.fill(
                              child: Center(
                                child: Text(
                                  '${(progressClamped * 100).toInt()}%',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: AppTheme.textHighEmphasisLight,
                                      ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (progress >= 1.0) ...[
                    SizedBox(height: 2.h),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                      decoration: BoxDecoration(
                        color:
                            AppTheme.primaryVariantLight.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomIconWidget(
                            iconName: 'check_circle',
                            color: AppTheme.primaryVariantLight,
                            size: 16,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            'Goal Achieved!',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
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
            ),
          );
        },
      ),
    );
  }
}
