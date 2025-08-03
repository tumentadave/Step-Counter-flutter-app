import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class AchievementBadges extends StatefulWidget {
  final List<Map<String, dynamic>> achievements;

  const AchievementBadges({
    Key? key,
    required this.achievements,
  }) : super(key: key);

  @override
  State<AchievementBadges> createState() => _AchievementBadgesState();
}

class _AchievementBadgesState extends State<AchievementBadges>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _scaleAnimations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.achievements.length,
      (index) => AnimationController(
        duration: Duration(milliseconds: 300),
        vsync: this,
      ),
    );

    _scaleAnimations = _controllers.map((controller) {
      return Tween<double>(begin: 1.0, end: 1.1).animate(
        CurvedAnimation(parent: controller, curve: Curves.elasticOut),
      );
    }).toList();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onBadgeTap(int index) {
    _controllers[index].forward().then((_) {
      _controllers[index].reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.achievements.isEmpty) return const SizedBox();

    final isLight = Theme.of(context).brightness == Brightness.light;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: AppTheme.glassDecoration(
        isLight: isLight,
        borderRadius: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'emoji_events',
                color: AppTheme.accentLight,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'Achievements',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Wrap(
            spacing: 3.w,
            runSpacing: 2.h,
            children: widget.achievements.asMap().entries.map((entry) {
              final index = entry.key;
              final achievement = entry.value;
              return _buildAchievementBadge(context, achievement, index);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementBadge(
      BuildContext context, Map<String, dynamic> achievement, int index) {
    final isUnlocked = achievement['unlocked'] as bool;
    final isLight = Theme.of(context).brightness == Brightness.light;

    return GestureDetector(
      onTap: () => _onBadgeTap(index),
      child: AnimatedBuilder(
        animation: _scaleAnimations[index],
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimations[index].value,
            child: Container(
              width: 25.w,
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: isUnlocked
                    ? AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1)
                    : AppTheme.textDisabledLight.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isUnlocked
                      ? AppTheme.lightTheme.primaryColor.withValues(alpha: 0.3)
                      : AppTheme.textDisabledLight.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 12.w,
                    height: 12.w,
                    decoration: BoxDecoration(
                      color: isUnlocked
                          ? AppTheme.accentLight
                          : AppTheme.textDisabledLight,
                      shape: BoxShape.circle,
                    ),
                    child: CustomIconWidget(
                      iconName: achievement['icon'] as String,
                      color: isUnlocked
                          ? Colors.white
                          : AppTheme.textMediumEmphasisLight,
                      size: 20,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    achievement['title'] as String,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: isUnlocked
                              ? AppTheme.textHighEmphasisLight
                              : AppTheme.textMediumEmphasisLight,
                        ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (isUnlocked) ...[
                    SizedBox(height: 0.5.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.primaryColor
                            .withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        achievement['date'] as String,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontSize: 7.sp,
                              color: AppTheme.lightTheme.primaryColor,
                            ),
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
