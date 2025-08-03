import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoAnimationController;
  late AnimationController _backgroundAnimationController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _backgroundOpacityAnimation;
  late Animation<double> _loadingAnimation;

  bool _isInitializing = true;
  double _initializationProgress = 0.0;
  String _initializationStatus = 'Initializing...';

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startInitialization();
  }

  void _setupAnimations() {
    // Logo animation controller
    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Background animation controller
    _backgroundAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Logo scale animation
    _logoScaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: Curves.elasticOut,
    ));

    // Logo fade animation
    _logoFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: Curves.easeInOut,
    ));

    // Background opacity animation
    _backgroundOpacityAnimation = Tween<double>(
      begin: 0.3,
      end: 0.8,
    ).animate(CurvedAnimation(
      parent: _backgroundAnimationController,
      curve: Curves.easeInOut,
    ));

    // Loading animation
    _loadingAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _backgroundAnimationController,
      curve: Curves.linear,
    ));

    // Start animations
    _logoAnimationController.forward();
    _backgroundAnimationController.repeat();
  }

  Future<void> _startInitialization() async {
    try {
      // Step 1: Check location permissions
      await _updateInitializationStatus(
          'Checking location permissions...', 0.2);
      await Future.delayed(const Duration(milliseconds: 500));

      // Step 2: Initialize step counter sensors
      await _updateInitializationStatus('Initializing step counter...', 0.4);
      await Future.delayed(const Duration(milliseconds: 600));

      // Step 3: Load user profile data
      await _updateInitializationStatus('Loading user profile...', 0.6);
      await Future.delayed(const Duration(milliseconds: 500));

      // Step 4: Prepare GPS services
      await _updateInitializationStatus('Preparing GPS services...', 0.8);
      await Future.delayed(const Duration(milliseconds: 600));

      // Step 5: Complete initialization
      await _updateInitializationStatus('Ready to go!', 1.0);
      await Future.delayed(const Duration(milliseconds: 500));

      // Navigate based on user status
      _navigateToNextScreen();
    } catch (e) {
      // Handle initialization errors gracefully
      await _updateInitializationStatus('Setup required...', 1.0);
      await Future.delayed(const Duration(milliseconds: 500));
      _navigateToNextScreen();
    }
  }

  Future<void> _updateInitializationStatus(
      String status, double progress) async {
    if (mounted) {
      setState(() {
        _initializationStatus = status;
        _initializationProgress = progress;
      });
    }
  }

  void _navigateToNextScreen() {
    if (mounted) {
      // Check if user has completed profile setup
      bool hasCompletedProfile = _checkUserProfileStatus();

      if (hasCompletedProfile) {
        Navigator.pushReplacementNamed(context, '/dashboard-home');
      } else {
        Navigator.pushReplacementNamed(context, '/profile-setup');
      }
    }
  }

  bool _checkUserProfileStatus() {
    // Mock check for user profile completion
    // In real implementation, this would check local storage
    return false; // For demo, always show profile setup first
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _backgroundAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: _buildGlassMorphismBackground(),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildAnimatedLogo(),
                      SizedBox(height: 8.h),
                      _buildInitializationStatus(),
                      SizedBox(height: 4.h),
                      _buildLoadingIndicator(),
                    ],
                  ),
                ),
              ),
              _buildBottomBranding(),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildGlassMorphismBackground() {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppTheme.primaryLight.withValues(alpha: 0.3),
          AppTheme.primaryVariantLight.withValues(alpha: 0.5),
          AppTheme.accentLight.withValues(alpha: 0.2),
          AppTheme.secondaryLight.withValues(alpha: 0.1),
        ],
        stops: const [0.0, 0.3, 0.7, 1.0],
      ),
    );
  }

  Widget _buildAnimatedLogo() {
    return AnimatedBuilder(
      animation: _logoAnimationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _logoScaleAnimation.value,
          child: Opacity(
            opacity: _logoFadeAnimation.value,
            child: Container(
              width: 35.w,
              height: 35.w,
              decoration: AppTheme.glassDecoration(
                isLight: true,
                borderRadius: 25.0,
                opacity: 0.9,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'directions_walk',
                    color: AppTheme.primaryLight,
                    size: 15.w,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'WalkKamer',
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      color: AppTheme.primaryLight,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInitializationStatus() {
    return AnimatedBuilder(
      animation: _backgroundAnimationController,
      builder: (context, child) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
          decoration: AppTheme.glassDecoration(
            isLight: true,
            borderRadius: 12.0,
            opacity: 0.7,
          ),
          child: Column(
            children: [
              Text(
                _initializationStatus,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textHighEmphasisLight,
                  fontSize: 12.sp,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 1.h),
              Text(
                '${(_initializationProgress * 100).toInt()}%',
                style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                  color: AppTheme.primaryLight,
                  fontWeight: FontWeight.w600,
                  fontSize: 10.sp,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      width: 60.w,
      height: 0.8.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        color: AppTheme.primaryLight.withValues(alpha: 0.2),
      ),
      child: AnimatedBuilder(
        animation: _backgroundAnimationController,
        builder: (context, child) {
          return Stack(
            children: [
              Container(
                width: 60.w * _initializationProgress,
                height: 0.8.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.0),
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.primaryLight,
                      AppTheme.primaryVariantLight,
                    ],
                  ),
                ),
              ),
              if (_isInitializing)
                Positioned(
                  left: (60.w * _loadingAnimation.value) % 60.w,
                  child: Container(
                    width: 4.w,
                    height: 0.8.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.0),
                      color: AppTheme.accentLight.withValues(alpha: 0.8),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBottomBranding() {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: 'security',
                color: AppTheme.textMediumEmphasisLight,
                size: 4.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'Your data stays on your device',
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  color: AppTheme.textMediumEmphasisLight,
                  fontSize: 9.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            'Privacy-focused fitness tracking',
            style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
              color: AppTheme.textDisabledLight,
              fontSize: 8.sp,
            ),
          ),
        ],
      ),
    );
  }
}
