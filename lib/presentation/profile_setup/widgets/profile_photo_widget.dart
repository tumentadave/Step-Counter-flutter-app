import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProfilePhotoWidget extends StatefulWidget {
  final Function(XFile?) onPhotoSelected;

  const ProfilePhotoWidget({
    Key? key,
    required this.onPhotoSelected,
  }) : super(key: key);

  @override
  State<ProfilePhotoWidget> createState() => _ProfilePhotoWidgetState();
}

class _ProfilePhotoWidgetState extends State<ProfilePhotoWidget> {
  XFile? _selectedImage;
  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];
  bool _isCameraInitialized = false;
  bool _showCamera = false;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<bool> _requestCameraPermission() async {
    if (kIsWeb) return true;
    return (await Permission.camera.request()).isGranted;
  }

  Future<void> _initializeCamera() async {
    try {
      if (!await _requestCameraPermission()) return;

      _cameras = await availableCameras();
      if (_cameras.isEmpty) return;

      final camera = kIsWeb
          ? _cameras.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.front,
              orElse: () => _cameras.first)
          : _cameras.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.back,
              orElse: () => _cameras.first);

      _cameraController = CameraController(
          camera, kIsWeb ? ResolutionPreset.medium : ResolutionPreset.high);

      await _cameraController!.initialize();
      await _applySettings();

      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      // Silent fail - camera not available
    }
  }

  Future<void> _applySettings() async {
    if (_cameraController == null) return;

    try {
      await _cameraController!.setFocusMode(FocusMode.auto);
    } catch (e) {}

    if (!kIsWeb) {
      try {
        await _cameraController!.setFlashMode(FlashMode.auto);
      } catch (e) {}
    }
  }

  Future<void> _capturePhoto() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized)
      return;

    try {
      final XFile photo = await _cameraController!.takePicture();
      setState(() {
        _selectedImage = photo;
        _showCamera = false;
      });
      widget.onPhotoSelected(photo);
    } catch (e) {
      // Silent fail
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _selectedImage = image;
        });
        widget.onPhotoSelected(image);
      }
    } catch (e) {
      // Silent fail
    }
  }

  void _showPhotoOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: AppTheme.glassDecoration(
          isLight: Theme.of(context).brightness == Brightness.light,
          borderRadius: 20,
        ),
        margin: EdgeInsets.all(4.w),
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select Profile Photo',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 4.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildOptionButton(
                  icon: 'camera_alt',
                  label: 'Camera',
                  onTap: () {
                    Navigator.pop(context);
                    if (_isCameraInitialized) {
                      setState(() {
                        _showCamera = true;
                      });
                    }
                  },
                ),
                _buildOptionButton(
                  icon: 'photo_library',
                  label: 'Gallery',
                  onTap: () {
                    Navigator.pop(context);
                    _pickFromGallery();
                  },
                ),
              ],
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton({
    required String icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 25.w,
        height: 12.h,
        decoration: AppTheme.glassDecoration(
          isLight: Theme.of(context).brightness == Brightness.light,
          borderRadius: 12,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: icon,
              size: 8.w,
              color: AppTheme.lightTheme.primaryColor,
            ),
            SizedBox(height: 1.h),
            Text(
              label,
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_showCamera && _isCameraInitialized && _cameraController != null) {
      return _buildCameraView();
    }

    return _buildPhotoSelector();
  }

  Widget _buildCameraView() {
    return Container(
      height: 50.h,
      decoration: AppTheme.glassDecoration(
        isLight: Theme.of(context).brightness == Brightness.light,
        borderRadius: 20,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Positioned.fill(
              child: CameraPreview(_cameraController!),
            ),
            Positioned(
              bottom: 4.h,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildCameraButton(
                    icon: 'close',
                    onTap: () {
                      setState(() {
                        _showCamera = false;
                      });
                    },
                  ),
                  _buildCameraButton(
                    icon: 'camera',
                    onTap: _capturePhoto,
                    isPrimary: true,
                  ),
                  _buildCameraButton(
                    icon: 'flip_camera_ios',
                    onTap: () {
                      // Switch camera if available
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraButton({
    required String icon,
    required VoidCallback onTap,
    bool isPrimary = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 15.w,
        height: 15.w,
        decoration: BoxDecoration(
          color: isPrimary
              ? AppTheme.lightTheme.primaryColor
              : Colors.black.withValues(alpha: 0.5),
          shape: BoxShape.circle,
          border: isPrimary ? Border.all(color: Colors.white, width: 3) : null,
        ),
        child: Center(
          child: CustomIconWidget(
            iconName: icon,
            color: Colors.white,
            size: isPrimary ? 8.w : 6.w,
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoSelector() {
    return GestureDetector(
      onTap: _showPhotoOptions,
      child: Container(
        width: 35.w,
        height: 35.w,
        decoration: AppTheme.glassDecoration(
          isLight: Theme.of(context).brightness == Brightness.light,
          borderRadius: 100,
        ),
        child: _selectedImage != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: kIsWeb
                    ? Image.network(
                        _selectedImage!.path,
                        width: 35.w,
                        height: 35.w,
                        fit: BoxFit.cover,
                      )
                    : CustomImageWidget(
                        imageUrl: _selectedImage!.path,
                        width: 35.w,
                        height: 35.w,
                        fit: BoxFit.cover,
                      ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'add_a_photo',
                    size: 12.w,
                    color: AppTheme.lightTheme.primaryColor,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Add Photo',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: AppTheme.lightTheme.primaryColor,
                        ),
                  ),
                ],
              ),
      ),
    );
  }
}
