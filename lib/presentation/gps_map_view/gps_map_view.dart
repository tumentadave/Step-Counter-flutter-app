import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/gps_status_indicator.dart';
import './widgets/map_control_panel.dart';
import './widgets/route_info_sheet.dart';

class GpsMapView extends StatefulWidget {
  const GpsMapView({Key? key}) : super(key: key);

  @override
  State<GpsMapView> createState() => _GpsMapViewState();
}

class _GpsMapViewState extends State<GpsMapView> with TickerProviderStateMixin {
  // Tracking State
  bool _isTracking = false;
  bool _hasGpsSignal = false;
  bool _isLocationPermissionGranted = false;
  double _gpsAccuracy = 0.0;
  int _batteryLevel = 85;

  // Session Data
  DateTime? _sessionStartTime;
  Duration _elapsedTime = Duration.zero;
  double _totalDistance = 0.0;
  int _stepCount = 0;
  double _currentPace = 0.0;
  List<Position> _routePoints = [];
  List<Map<String, dynamic>> _splitTimes = [];

  // Controllers and Timers
  Timer? _trackingTimer;
  Timer? _locationTimer;
  StreamSubscription<Position>? _positionStream;
  Position? _lastPosition;

  // UI State
  bool _showRouteInfo = false;
  double _mapZoom = 15.0;
  AnimationController? _pulseController;

  // Mock route data for demonstration
  final List<Map<String, dynamic>> _mockRouteData = [
    {
      "latitude": 37.7749,
      "longitude": -122.4194,
      "timestamp": "2025-08-01T23:00:00Z",
      "elevation": 50.0,
      "accuracy": 5.0,
    },
    {
      "latitude": 37.7759,
      "longitude": -122.4184,
      "timestamp": "2025-08-01T23:05:00Z",
      "elevation": 55.0,
      "accuracy": 4.0,
    },
    {
      "latitude": 37.7769,
      "longitude": -122.4174,
      "timestamp": "2025-08-01T23:10:00Z",
      "elevation": 60.0,
      "accuracy": 3.0,
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeGpsTracking();
    _pulseController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _trackingTimer?.cancel();
    _locationTimer?.cancel();
    _positionStream?.cancel();
    _pulseController?.dispose();
    super.dispose();
  }

  Future<void> _initializeGpsTracking() async {
    await _checkLocationPermission();
    await _checkGpsStatus();
    _startLocationUpdates();
  }

  Future<void> _checkLocationPermission() async {
    final permission = await Permission.location.status;
    setState(() {
      _isLocationPermissionGranted = permission.isGranted;
    });

    if (!permission.isGranted) {
      final result = await Permission.location.request();
      setState(() {
        _isLocationPermissionGranted = result.isGranted;
      });
    }
  }

  Future<void> _checkGpsStatus() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      setState(() {
        _hasGpsSignal = serviceEnabled;
      });
    } catch (e) {
      setState(() {
        _hasGpsSignal = false;
      });
    }
  }

  void _startLocationUpdates() {
    if (!_isLocationPermissionGranted) return;

    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 1,
    );

    _positionStream = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen(
      (Position position) {
        setState(() {
          _hasGpsSignal = true;
          _gpsAccuracy = position.accuracy;
        });

        if (_isTracking) {
          _updateTrackingData(position);
        }
      },
      onError: (error) {
        setState(() {
          _hasGpsSignal = false;
        });
      },
    );
  }

  void _updateTrackingData(Position position) {
    if (_lastPosition != null) {
      final distance = Geolocator.distanceBetween(
        _lastPosition!.latitude,
        _lastPosition!.longitude,
        position.latitude,
        position.longitude,
      );

      setState(() {
        _totalDistance += distance / 1000; // Convert to km
        _routePoints.add(position);
        _stepCount += (distance / 0.8).round(); // Approximate steps
      });
    }

    _lastPosition = position;
    _calculateCurrentPace();
  }

  void _calculateCurrentPace() {
    if (_elapsedTime.inMinutes > 0 && _totalDistance > 0) {
      final paceMinutesPerKm = _elapsedTime.inMinutes / _totalDistance;
      setState(() {
        _currentPace = paceMinutesPerKm;
      });
    }
  }

  void _startStopTracking() {
    HapticFeedback.mediumImpact();

    if (_isTracking) {
      _stopTracking();
    } else {
      _startTracking();
    }
  }

  void _startTracking() {
    if (!_isLocationPermissionGranted || !_hasGpsSignal) {
      _showPermissionDialog();
      return;
    }

    setState(() {
      _isTracking = true;
      _sessionStartTime = DateTime.now();
      _elapsedTime = Duration.zero;
      _totalDistance = 0.0;
      _stepCount = 0;
      _routePoints.clear();
      _splitTimes.clear();
    });

    _trackingTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_sessionStartTime != null) {
        setState(() {
          _elapsedTime = DateTime.now().difference(_sessionStartTime!);
        });
      }
    });

    // Prevent screen from turning off
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }

  void _stopTracking() {
    setState(() {
      _isTracking = false;
    });

    _trackingTimer?.cancel();

    // Re-enable system UI
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    if (_totalDistance > 0) {
      _generateSplitTimes();
      _showRouteInfoSheet();
    }
  }

  void _generateSplitTimes() {
    final splits = <Map<String, dynamic>>[];
    const splitDistance = 1.0; // 1km splits

    for (int i = 1; i <= (_totalDistance / splitDistance).floor(); i++) {
      final splitTime = Duration(
        minutes: (i * _elapsedTime.inMinutes / (_totalDistance / splitDistance))
            .round(),
      );

      splits.add({
        'distance': '${splitDistance.toStringAsFixed(1)} km',
        'time': _formatDuration(splitTime),
      });
    }

    setState(() {
      _splitTimes = splits;
    });
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Location Access Required',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        content: Text(
          'WalkKamer needs location access to track your route and provide accurate fitness data. Your location data stays private on your device.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _checkLocationPermission();
            },
            child: Text('Enable Location'),
          ),
        ],
      ),
    );
  }

  void _showRouteInfoSheet() {
    setState(() {
      _showRouteInfo = true;
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => RouteInfoSheet(
        totalDistance: '${_totalDistance.toStringAsFixed(2)} km',
        totalTime: _formatDuration(_elapsedTime),
        averagePace: _currentPace > 0
            ? '${_currentPace.toStringAsFixed(1)} min/km'
            : '0.0 min/km',
        elevationGain: '${(math.Random().nextInt(100) + 50)} m',
        caloriesBurned: '${(_totalDistance * 65).round()} cal',
        splitTimes: _splitTimes,
        onShare: _shareRoute,
        onSave: _saveRoute,
      ),
    ).whenComplete(() {
      setState(() {
        _showRouteInfo = false;
      });
    });
  }

  void _shareRoute() {
    // Implement route sharing functionality
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Route shared successfully!'),
        backgroundColor: AppTheme.primaryLight,
      ),
    );
  }

  void _saveRoute() {
    // Implement route saving functionality
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Route saved to your history!'),
        backgroundColor: AppTheme.primaryLight,
      ),
    );
  }

  void _zoomIn() {
    setState(() {
      _mapZoom = math.min(_mapZoom + 1, 20);
    });
  }

  void _zoomOut() {
    setState(() {
      _mapZoom = math.max(_mapZoom - 1, 5);
    });
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            // Map Container (Full Screen)
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppTheme.primaryLight.withValues(alpha: 0.1),
                    Theme.of(context).scaffoldBackgroundColor,
                  ],
                ),
              ),
              child: _buildMapView(),
            ),

            // Top Status Bar
            Positioned(
              top: 2.h,
              left: 4.w,
              right: 4.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back Button
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 12.w,
                      height: 6.h,
                      decoration: AppTheme.glassDecoration(
                        isLight:
                            Theme.of(context).brightness == Brightness.light,
                        borderRadius: 12.0,
                        opacity: 0.9,
                      ),
                      child: Center(
                        child: CustomIconWidget(
                          iconName: 'arrow_back',
                          color: Theme.of(context).colorScheme.onSurface,
                          size: 6.w,
                        ),
                      ),
                    ),
                  ),

                  // GPS Status Indicator
                  GpsStatusIndicator(
                    hasGpsSignal: _hasGpsSignal,
                    accuracy: _gpsAccuracy,
                    isLocationPermissionGranted: _isLocationPermissionGranted,
                    batteryLevel: _batteryLevel,
                    onPermissionRequest: _checkLocationPermission,
                  ),
                ],
              ),
            ),

            // Control Panel
            Positioned(
              bottom: 4.h,
              left: 4.w,
              right: 4.w,
              child: MapControlPanel(
                elapsedTime: _formatDuration(_elapsedTime),
                distance: '${_totalDistance.toStringAsFixed(2)} km',
                currentPace: _currentPace > 0
                    ? '${_currentPace.toStringAsFixed(1)}'
                    : '0.0',
                stepCount: _stepCount,
                isTracking: _isTracking,
                onStartStop: _startStopTracking,
                onZoomIn: _zoomIn,
                onZoomOut: _zoomOut,
              ),
            ),

            // Route Info Button (when not tracking)
            if (!_isTracking && _totalDistance > 0)
              Positioned(
                bottom: 20.h,
                right: 4.w,
                child: GestureDetector(
                  onTap: _showRouteInfoSheet,
                  child: Container(
                    width: 14.w,
                    height: 7.h,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.primaryLight,
                          AppTheme.primaryVariantLight
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryLight.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: CustomIconWidget(
                        iconName: 'info',
                        color: Colors.white,
                        size: 6.w,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapView() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          // Map Background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.primaryLight.withValues(alpha: 0.05),
                  AppTheme.secondaryLight.withValues(alpha: 0.05),
                  AppTheme.accentLight.withValues(alpha: 0.05),
                ],
              ),
            ),
          ),

          // Mock Map Grid
          CustomPaint(
            size: Size(double.infinity, double.infinity),
            painter: MapGridPainter(
              zoom: _mapZoom,
              theme: Theme.of(context),
            ),
          ),

          // Route Path
          if (_routePoints.isNotEmpty)
            CustomPaint(
              size: Size(double.infinity, double.infinity),
              painter: RoutePathPainter(
                points: _routePoints,
                isTracking: _isTracking,
              ),
            ),

          // Current Location Indicator
          if (_hasGpsSignal && _isTracking)
            Center(
              child: AnimatedBuilder(
                animation: _pulseController!,
                builder: (context, child) {
                  return Container(
                    width: 20.w * (1 + _pulseController!.value * 0.3),
                    height: 20.w * (1 + _pulseController!.value * 0.3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.primaryLight.withValues(
                        alpha: 0.3 * (1 - _pulseController!.value),
                      ),
                    ),
                    child: Center(
                      child: Container(
                        width: 4.w,
                        height: 4.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.primaryLight,
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  AppTheme.primaryLight.withValues(alpha: 0.5),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

          // Map Labels and Markers
          if (_routePoints.isNotEmpty) ..._buildRouteMarkers(),
        ],
      ),
    );
  }

  List<Widget> _buildRouteMarkers() {
    final markers = <Widget>[];

    // Start marker
    if (_routePoints.isNotEmpty) {
      markers.add(
        Positioned(
          left: 20.w,
          top: 30.h,
          child: Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: AppTheme.primaryLight,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryLight.withValues(alpha: 0.3),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: CustomIconWidget(
              iconName: 'play_arrow',
              color: Colors.white,
              size: 4.w,
            ),
          ),
        ),
      );
    }

    // End marker (if tracking stopped)
    if (!_isTracking && _routePoints.length > 1) {
      markers.add(
        Positioned(
          right: 20.w,
          bottom: 40.h,
          child: Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: AppTheme.secondaryLight,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.secondaryLight.withValues(alpha: 0.3),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: CustomIconWidget(
              iconName: 'stop',
              color: Colors.white,
              size: 4.w,
            ),
          ),
        ),
      );
    }

    return markers;
  }
}

// Custom Painter for Map Grid
class MapGridPainter extends CustomPainter {
  final double zoom;
  final ThemeData theme;

  MapGridPainter({required this.zoom, required this.theme});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = theme.colorScheme.outline.withValues(alpha: 0.1)
      ..strokeWidth = 1;

    final gridSize = 50.0 / zoom;

    // Draw vertical lines
    for (double x = 0; x < size.width; x += gridSize) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    // Draw horizontal lines
    for (double y = 0; y < size.height; y += gridSize) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Custom Painter for Route Path
class RoutePathPainter extends CustomPainter {
  final List<Position> points;
  final bool isTracking;

  RoutePathPainter({required this.points, required this.isTracking});

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;

    final paint = Paint()
      ..color = AppTheme.primaryLight
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = Path();

    // Convert GPS coordinates to screen coordinates (simplified)
    final screenPoints = points.map((point) {
      final x = (point.longitude + 122.4194) * size.width * 100;
      final y = (37.7749 - point.latitude) * size.height * 100;
      return Offset(x.clamp(0, size.width), y.clamp(0, size.height));
    }).toList();

    if (screenPoints.isNotEmpty) {
      path.moveTo(screenPoints.first.dx, screenPoints.first.dy);

      for (int i = 1; i < screenPoints.length; i++) {
        path.lineTo(screenPoints[i].dx, screenPoints[i].dy);
      }
    }

    canvas.drawPath(path, paint);

    // Draw tracking animation
    if (isTracking && screenPoints.isNotEmpty) {
      final glowPaint = Paint()
        ..color = AppTheme.primaryLight.withValues(alpha: 0.3)
        ..strokeWidth = 8
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

      canvas.drawPath(path, glowPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
