import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SettingsSectionWidget extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> items;
  final Function(String, dynamic)? onItemChanged;
  final Function(String)? onItemTapped;

  const SettingsSectionWidget({
    Key? key,
    required this.title,
    required this.items,
    this.onItemChanged,
    this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: AppTheme.glassDecoration(
        isLight: Theme.of(context).brightness == Brightness.light,
        borderRadius: 16.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(4.w, 3.h, 4.w, 1.h),
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryLight,
                  ),
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              color: AppTheme.dividerLight.withValues(alpha: 0.3),
              indent: 4.w,
              endIndent: 4.w,
            ),
            itemBuilder: (context, index) {
              final item = items[index];
              return _buildSettingItem(context, item);
            },
          ),
          SizedBox(height: 1.h),
        ],
      ),
    );
  }

  Widget _buildSettingItem(BuildContext context, Map<String, dynamic> item) {
    final String type = item["type"] as String? ?? "navigation";
    final String title = item["title"] as String? ?? "";
    final String? subtitle = item["subtitle"] as String?;
    final String iconName = item["icon"] as String? ?? "settings";
    final String key = item["key"] as String? ?? "";
    final dynamic value = item["value"];

    return InkWell(
      onTap: type == "navigation" ? () => onItemTapped?.call(key) : null,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        child: Row(
          children: [
            Container(
              width: 10.w,
              height: 10.w,
              decoration: BoxDecoration(
                color: _getIconColor(key).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: iconName,
                  color: _getIconColor(key),
                  size: 20,
                ),
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (subtitle != null) ...[
                    SizedBox(height: 0.5.h),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.textMediumEmphasisLight,
                          ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(width: 2.w),
            _buildTrailingWidget(context, type, key, value),
          ],
        ),
      ),
    );
  }

  Widget _buildTrailingWidget(
      BuildContext context, String type, String key, dynamic value) {
    switch (type) {
      case "switch":
        return Switch(
          value: value as bool? ?? false,
          onChanged: (newValue) => onItemChanged?.call(key, newValue),
          activeColor: AppTheme.primaryLight,
        );
      case "dropdown":
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value as String? ?? "",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textMediumEmphasisLight,
                  ),
            ),
            SizedBox(width: 2.w),
            CustomIconWidget(
              iconName: 'keyboard_arrow_down',
              color: AppTheme.textMediumEmphasisLight,
              size: 20,
            ),
          ],
        );
      case "navigation":
      default:
        return CustomIconWidget(
          iconName: 'chevron_right',
          color: AppTheme.textMediumEmphasisLight,
          size: 20,
        );
    }
  }

  Color _getIconColor(String key) {
    switch (key) {
      case "profile":
      case "units":
      case "privacy":
        return AppTheme.primaryLight;
      case "water_reminders":
      case "achievements":
      case "permissions":
        return Colors.blue;
      case "export_data":
      case "clear_cache":
      case "privacy_policy":
        return Colors.orange;
      case "theme":
      case "sounds":
      case "haptics":
        return Colors.purple;
      case "apple_health":
      case "google_fit":
        return Colors.red;
      case "help":
      case "contact":
      case "version":
        return Colors.grey;
      case "sensor_calibration":
      case "gps_accuracy":
      case "battery_optimization":
        return Colors.teal;
      default:
        return AppTheme.primaryLight;
    }
  }
}
