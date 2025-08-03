import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/activity_level_widget.dart';
import './widgets/personal_info_widget.dart';
import './widgets/profile_photo_widget.dart';
import './widgets/water_goal_widget.dart';

class ProfileSetup extends StatefulWidget {
  const ProfileSetup({Key? key}) : super(key: key);

  @override
  State<ProfileSetup> createState() => _ProfileSetupState();
}

class _ProfileSetupState extends State<ProfileSetup>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  // Form data
  XFile? _profilePhoto;
  Map<String, dynamic> _personalInfo = {};
  Map<String, dynamic> _activityData = {};
  double _waterGoal = 2.0;

  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _checkFormValidity();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _setupAnimations() {
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _fadeController.forward();
  }

  void _checkFormValidity() {
    final hasValidPersonalInfo = _personalInfo['isValid'] == true;
    final hasActivityLevel = _activityData.isNotEmpty;

    setState(() {
      _isFormValid = hasValidPersonalInfo && hasActivityLevel;
    });
  }

  void _onPersonalInfoChanged(Map<String, dynamic> info) {
    setState(() {
      _personalInfo = info;
    });
    _checkFormValidity();
  }

  void _onActivityChanged(Map<String, dynamic> activity) {
    setState(() {
      _activityData = activity;
    });
    _checkFormValidity();
  }

  void _onWaterGoalChanged(double goal) {
    setState(() {
      _waterGoal = goal;
    });
  }

  void _onPhotoSelected(XFile? photo) {
    setState(() {
      _profilePhoto = photo;
    });
  }

  Future<void> _completeSetup() async {
    if (!_isFormValid) return;

    // Show loading animation
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _buildLoadingDialog(),
    );

    // Simulate saving data (replace with actual storage logic)
    await Future.delayed(Duration(seconds: 2));

    // Save profile data locally
    final profileData = {
      'profilePhoto': _profilePhoto?.path,
      'personalInfo': _personalInfo,
      'activityData': _activityData,
      'waterGoal': _waterGoal,
      'setupCompleted': true,
      'createdAt': DateTime.now().toIso8601String(),
    };

    // TODO: Save to local storage (SharedPreferences or Hive)
    print('Profile data to save: $profileData');

    Navigator.of(context).pop(); // Close loading dialog

    // Show success animation
    await _showSuccessAnimation();

    // Navigate to dashboard
    Navigator.pushReplacementNamed(context, '/dashboard-home');
  }

  Future<void> _showSuccessAnimation() async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _buildSuccessDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
              AppTheme.lightTheme.colorScheme.tertiary.withValues(alpha: 0.05),
              AppTheme.lightTheme.colorScheme.secondary.withValues(alpha: 0.05),
            ],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: _buildScrollableContent(),
                ),
                _buildBottomSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 12.w,
              height: 12.w,
              decoration: AppTheme.glassDecoration(
                isLight: Theme.of(context).brightness == Brightness.light,
                borderRadius: 12,
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'arrow_back_ios',
                  size: 5.w,
                  color: Theme.of(context).textTheme.titleLarge?.color ??
                      Colors.black,
                ),
              ),
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Profile Setup',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                Text(
                  'Let\'s personalize your fitness journey',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.color
                            ?.withValues(alpha: 0.7),
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScrollableContent() {
    return SingleChildScrollView(
      controller: _scrollController,
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: Column(
        children: [
          SizedBox(height: 2.h),

          // Profile Photo Section
          Center(
            child: ProfilePhotoWidget(
              onPhotoSelected: _onPhotoSelected,
            ),
          ),

          SizedBox(height: 4.h),

          // Personal Information Section
          PersonalInfoWidget(
            onInfoChanged: _onPersonalInfoChanged,
            initialData: _personalInfo,
          ),

          SizedBox(height: 4.h),

          // Activity Level Section
          ActivityLevelWidget(
            onActivityChanged: _onActivityChanged,
            initialActivity: _activityData['activityLevel'],
          ),

          SizedBox(height: 4.h),

          // Water Goal Section
          WaterGoalWidget(
            onGoalChanged: _onWaterGoalChanged,
            initialGoal: _waterGoal,
            userWeight: _personalInfo['weight']?.toDouble(),
            activityLevel: _activityData['activityLevel'],
          ),

          SizedBox(height: 10.h), // Extra space for bottom button
        ],
      ),
    );
  }

  Widget _buildBottomSection() {
    return Container(
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color:
            Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.95),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Progress indicator
          _buildProgressIndicator(),
          SizedBox(height: 3.h),

          // Complete setup button
          SizedBox(
            width: double.infinity,
            height: 7.h,
            child: ElevatedButton(
              onPressed: _isFormValid ? _completeSetup : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _isFormValid
                    ? AppTheme.lightTheme.primaryColor
                    : Colors.grey.withValues(alpha: 0.3),
                foregroundColor: Colors.white,
                elevation: _isFormValid ? 4 : 0,
                shadowColor: _isFormValid
                    ? AppTheme.lightTheme.primaryColor.withValues(alpha: 0.3)
                    : Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Complete Setup',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  SizedBox(width: 2.w),
                  CustomIconWidget(
                    iconName: 'arrow_forward',
                    size: 5.w,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    final progress = _calculateProgress();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Setup Progress',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            Text(
              '${(progress * 100).toInt()}%',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppTheme.lightTheme.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey.withValues(alpha: 0.2),
          valueColor: AlwaysStoppedAnimation<Color>(
            AppTheme.lightTheme.primaryColor,
          ),
          minHeight: 6,
        ),
      ],
    );
  }

  double _calculateProgress() {
    double progress = 0.0;

    // Personal info (50%)
    if (_personalInfo['isValid'] == true) {
      progress += 0.5;
    }

    // Activity level (30%)
    if (_activityData.isNotEmpty) {
      progress += 0.3;
    }

    // Water goal (10%)
    if (_waterGoal > 0) {
      progress += 0.1;
    }

    // Profile photo (10%)
    if (_profilePhoto != null) {
      progress += 0.1;
    }

    return progress.clamp(0.0, 1.0);
  }

  Widget _buildLoadingDialog() {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(8.w),
        decoration: AppTheme.glassDecoration(
          isLight: Theme.of(context).brightness == Brightness.light,
          borderRadius: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                AppTheme.lightTheme.primaryColor,
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Setting up your profile...',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessDialog() {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(8.w),
        decoration: AppTheme.glassDecoration(
          isLight: Theme.of(context).brightness == Brightness.light,
          borderRadius: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.primaryColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'check',
                  size: 10.w,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Profile Complete!',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppTheme.lightTheme.primaryColor,
                    fontWeight: FontWeight.w700,
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.h),
            Text(
              'Welcome to WalkKamer! Let\'s start your fitness journey.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Get Started'),
            ),
          ],
        ),
      ),
    );
  }
}
