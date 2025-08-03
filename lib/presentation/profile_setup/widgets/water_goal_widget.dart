import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'dart:math';

import '../../../core/app_export.dart';

class WaterGoalWidget extends StatefulWidget {
  final Function(double) onGoalChanged;
  final double? initialGoal;
  final double? userWeight;
  final String? activityLevel;

  const WaterGoalWidget({
    Key? key,
    required this.onGoalChanged,
    this.initialGoal,
    this.userWeight,
    this.activityLevel,
  }) : super(key: key);

  @override
  State<WaterGoalWidget> createState() => _WaterGoalWidgetState();
}

class _WaterGoalWidgetState extends State<WaterGoalWidget>
    with TickerProviderStateMixin {
  double _waterGoal = 2.0; // Default 2 liters
  late AnimationController _animationController;
  late Animation<double> _waveAnimation;

  @override
  void initState() {
    super.initState();
    _initializeGoal();
    _setupAnimations();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _initializeGoal() {
    if (widget.initialGoal != null) {
      _waterGoal = widget.initialGoal!;
    } else {
      _waterGoal = _calculateRecommendedGoal();
    }
    widget.onGoalChanged(_waterGoal);
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );

    _waveAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.repeat();
  }

  double _calculateRecommendedGoal() {
    double baseGoal = 2.0; // Base 2 liters

    // Adjust based on weight
    if (widget.userWeight != null) {
      // 35ml per kg of body weight
      baseGoal = (widget.userWeight! * 0.035).clamp(1.5, 4.0);
    }

    // Adjust based on activity level
    if (widget.activityLevel != null) {
      switch (widget.activityLevel) {
        case 'Sedentary':
          baseGoal *= 1.0;
          break;
        case 'Lightly Active':
          baseGoal *= 1.1;
          break;
        case 'Moderately Active':
          baseGoal *= 1.2;
          break;
        case 'Very Active':
          baseGoal *= 1.3;
          break;
        case 'Extremely Active':
          baseGoal *= 1.4;
          break;
      }
    }

    return double.parse(baseGoal.toStringAsFixed(1));
  }

  void _updateGoal(double newGoal) {
    setState(() {
      _waterGoal = newGoal;
    });
    widget.onGoalChanged(_waterGoal);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppTheme.glassDecoration(
        isLight: Theme.of(context).brightness == Brightness.light,
        borderRadius: 16,
      ),
      padding: EdgeInsets.all(6.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Daily Water Goal',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(height: 2.h),
          Text(
            'Stay hydrated for optimal health',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.color
                      ?.withValues(alpha: 0.7),
                ),
          ),
          SizedBox(height: 4.h),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: _buildWaterVisualization(),
              ),
              SizedBox(width: 6.w),
              Expanded(
                flex: 3,
                child: _buildGoalControls(),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          _buildSlider(),
          SizedBox(height: 3.h),
          _buildRecommendationInfo(),
        ],
      ),
    );
  }

  Widget _buildWaterVisualization() {
    final fillPercentage = (_waterGoal / 4.0).clamp(0.0, 1.0);

    return Container(
      height: 25.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Water bottle outline
          Container(
            width: 20.w,
            height: 25.h,
            decoration: BoxDecoration(
              border: Border.all(
                color: AppTheme.lightTheme.primaryColor,
                width: 3,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          // Water fill
          Positioned(
            bottom: 2.h,
            child: AnimatedBuilder(
              animation: _waveAnimation,
              builder: (context, child) {
                return Container(
                  width: 16.w,
                  height: (20.h * fillPercentage),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppTheme.lightTheme.primaryColor.withValues(alpha: 0.6),
                        AppTheme.lightTheme.primaryColor.withValues(alpha: 0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CustomPaint(
                      painter: WavePainter(
                        animationValue: _waveAnimation.value,
                        color: AppTheme.lightTheme.primaryColor,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Water amount text
          Positioned(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${_waterGoal.toStringAsFixed(1)}L',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppTheme.lightTheme.primaryColor,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                Text(
                  'per day',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalControls() {
    return Column(
      children: [
        _buildQuickGoalButton('1.5L', 1.5),
        SizedBox(height: 2.h),
        _buildQuickGoalButton('2.0L', 2.0),
        SizedBox(height: 2.h),
        _buildQuickGoalButton('2.5L', 2.5),
        SizedBox(height: 2.h),
        _buildQuickGoalButton('3.0L', 3.0),
        SizedBox(height: 2.h),
        _buildQuickGoalButton('3.5L', 3.5),
      ],
    );
  }

  Widget _buildQuickGoalButton(String label, double value) {
    final isSelected = _waterGoal == value;

    return GestureDetector(
      onTap: () => _updateGoal(value),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 1.5.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.lightTheme.primaryColor
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? AppTheme.lightTheme.primaryColor
                : Colors.grey.withValues(alpha: 0.3),
          ),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: isSelected
                    ? Colors.white
                    : Theme.of(context).textTheme.labelLarge?.color,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildSlider() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '1.0L',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            Text(
              '4.0L',
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ],
        ),
        SizedBox(height: 1.h),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 6,
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12),
            overlayShape: RoundSliderOverlayShape(overlayRadius: 20),
            activeTrackColor: AppTheme.lightTheme.primaryColor,
            inactiveTrackColor:
                AppTheme.lightTheme.primaryColor.withValues(alpha: 0.3),
            thumbColor: AppTheme.lightTheme.primaryColor,
            overlayColor:
                AppTheme.lightTheme.primaryColor.withValues(alpha: 0.2),
          ),
          child: Slider(
            value: _waterGoal,
            min: 1.0,
            max: 4.0,
            divisions: 30,
            onChanged: _updateGoal,
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendationInfo() {
    final recommendedGoal = _calculateRecommendedGoal();

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'lightbulb',
            color: AppTheme.lightTheme.primaryColor,
            size: 5.w,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Recommended: ${recommendedGoal.toStringAsFixed(1)}L',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppTheme.lightTheme.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  'Based on your weight and activity level',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppTheme.lightTheme.primaryColor
                            .withValues(alpha: 0.8),
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  final double animationValue;
  final Color color;

  WavePainter({
    required this.animationValue,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;

    final path = Path();
    final waveHeight = size.height * 0.1;
    final waveLength = size.width;

    path.moveTo(0, size.height);

    for (double x = 0; x <= size.width; x++) {
      final y = size.height -
          waveHeight *
              (1 +
                  0.5 *
                      sin(animationValue * 2 * 3.14159 +
                              x / waveLength * 2 * 3.14159));
      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}