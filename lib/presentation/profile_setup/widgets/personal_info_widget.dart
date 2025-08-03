import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PersonalInfoWidget extends StatefulWidget {
  final Function(Map<String, dynamic>) onInfoChanged;
  final Map<String, dynamic> initialData;

  const PersonalInfoWidget({
    Key? key,
    required this.onInfoChanged,
    this.initialData = const {},
  }) : super(key: key);

  @override
  State<PersonalInfoWidget> createState() => _PersonalInfoWidgetState();
}

class _PersonalInfoWidgetState extends State<PersonalInfoWidget> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  String _selectedGender = 'Male';
  bool _isMetric = true;

  final Map<String, bool> _validationStatus = {
    'name': false,
    'age': false,
    'height': false,
    'weight': false,
  };

  @override
  void initState() {
    super.initState();
    _initializeData();
    _setupListeners();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _initializeData() {
    _nameController.text = widget.initialData['name'] ?? '';
    _ageController.text = widget.initialData['age']?.toString() ?? '';
    _heightController.text = widget.initialData['height']?.toString() ?? '';
    _weightController.text = widget.initialData['weight']?.toString() ?? '';
    _selectedGender = widget.initialData['gender'] ?? 'Male';
    _isMetric = widget.initialData['isMetric'] ?? true;

    _validateAllFields();
  }

  void _setupListeners() {
    _nameController.addListener(() => _validateField('name'));
    _ageController.addListener(() => _validateField('age'));
    _heightController.addListener(() => _validateField('height'));
    _weightController.addListener(() => _validateField('weight'));
  }

  void _validateField(String field) {
    bool isValid = false;

    switch (field) {
      case 'name':
        isValid = _nameController.text.trim().length >= 2;
        break;
      case 'age':
        final age = int.tryParse(_ageController.text);
        isValid = age != null && age >= 13 && age <= 120;
        break;
      case 'height':
        final height = double.tryParse(_heightController.text);
        if (_isMetric) {
          isValid = height != null && height >= 100 && height <= 250; // cm
        } else {
          isValid = height != null && height >= 3.0 && height <= 8.5; // feet
        }
        break;
      case 'weight':
        final weight = double.tryParse(_weightController.text);
        if (_isMetric) {
          isValid = weight != null && weight >= 30 && weight <= 300; // kg
        } else {
          isValid = weight != null && weight >= 66 && weight <= 660; // lbs
        }
        break;
    }

    setState(() {
      _validationStatus[field] = isValid;
    });

    _notifyChanges();
  }

  void _validateAllFields() {
    _validateField('name');
    _validateField('age');
    _validateField('height');
    _validateField('weight');
  }

  void _notifyChanges() {
    final data = {
      'name': _nameController.text.trim(),
      'age': int.tryParse(_ageController.text),
      'height': double.tryParse(_heightController.text),
      'weight': double.tryParse(_weightController.text),
      'gender': _selectedGender,
      'isMetric': _isMetric,
      'isValid': _validationStatus.values.every((valid) => valid),
    };

    widget.onInfoChanged(data);
  }

  void _toggleUnits() {
    setState(() {
      _isMetric = !_isMetric;
    });

    // Convert existing values
    if (_heightController.text.isNotEmpty) {
      final currentHeight = double.tryParse(_heightController.text);
      if (currentHeight != null) {
        if (_isMetric) {
          // Convert feet to cm
          _heightController.text = (currentHeight * 30.48).toStringAsFixed(0);
        } else {
          // Convert cm to feet
          _heightController.text = (currentHeight / 30.48).toStringAsFixed(1);
        }
      }
    }

    if (_weightController.text.isNotEmpty) {
      final currentWeight = double.tryParse(_weightController.text);
      if (currentWeight != null) {
        if (_isMetric) {
          // Convert lbs to kg
          _weightController.text = (currentWeight / 2.205).toStringAsFixed(1);
        } else {
          // Convert kg to lbs
          _weightController.text = (currentWeight * 2.205).toStringAsFixed(1);
        }
      }
    }

    _validateAllFields();
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Personal Information',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              _buildUnitToggle(),
            ],
          ),
          SizedBox(height: 4.h),
          _buildTextField(
            controller: _nameController,
            label: 'Full Name',
            hint: 'Enter your full name',
            field: 'name',
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.words,
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: _ageController,
                  label: 'Age',
                  hint: '25',
                  field: 'age',
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: _buildGenderSelector(),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: _heightController,
                  label: 'Height',
                  hint: _isMetric ? '170' : '5.7',
                  field: 'height',
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  suffix: _isMetric ? 'cm' : 'ft',
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                  ],
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: _buildTextField(
                  controller: _weightController,
                  label: 'Weight',
                  hint: _isMetric ? '70' : '154',
                  field: 'weight',
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  suffix: _isMetric ? 'kg' : 'lbs',
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUnitToggle() {
    return Container(
      decoration: AppTheme.glassDecoration(
        isLight: Theme.of(context).brightness == Brightness.light,
        borderRadius: 20,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildUnitOption('Metric', _isMetric),
          _buildUnitOption('Imperial', !_isMetric),
        ],
      ),
    );
  }

  Widget _buildUnitOption(String label, bool isSelected) {
    return GestureDetector(
      onTap: isSelected ? null : _toggleUnits,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.lightTheme.primaryColor
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: isSelected
                    ? Colors.white
                    : Theme.of(context).textTheme.labelMedium?.color,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required String field,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? suffix,
    TextCapitalization textCapitalization = TextCapitalization.none,
  }) {
    final isValid = _validationStatus[field] ?? false;
    final hasContent = controller.text.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge,
        ),
        SizedBox(height: 1.h),
        Container(
          decoration: AppTheme.glassDecoration(
            isLight: Theme.of(context).brightness == Brightness.light,
            borderRadius: 12,
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            textCapitalization: textCapitalization,
            style: Theme.of(context).textTheme.bodyLarge,
            decoration: InputDecoration(
              hintText: hint,
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (suffix != null) ...[
                    Text(
                      suffix,
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    SizedBox(width: 2.w),
                  ],
                  if (hasContent)
                    CustomIconWidget(
                      iconName: isValid ? 'check_circle' : 'error',
                      color: isValid
                          ? AppTheme.lightTheme.primaryColor
                          : AppTheme.lightTheme.colorScheme.error,
                      size: 5.w,
                    ),
                  SizedBox(width: 2.w),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGenderSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gender',
          style: Theme.of(context).textTheme.labelLarge,
        ),
        SizedBox(height: 1.h),
        Container(
          decoration: AppTheme.glassDecoration(
            isLight: Theme.of(context).brightness == Brightness.light,
            borderRadius: 12,
          ),
          child: DropdownButtonFormField<String>(
            value: _selectedGender,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            ),
            dropdownColor: Theme.of(context).cardColor,
            items: ['Male', 'Female', 'Other'].map((gender) {
              return DropdownMenuItem(
                value: gender,
                child: Text(
                  gender,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedGender = value;
                });
                _notifyChanges();
              }
            },
          ),
        ),
      ],
    );
  }
}
