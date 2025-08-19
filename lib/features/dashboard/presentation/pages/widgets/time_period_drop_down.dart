import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TimePeriodDropdown extends StatefulWidget {
  final String? selectedPeriod;
  final Function(String)? onPeriodChanged;

  const TimePeriodDropdown({
    super.key,
    this.selectedPeriod,
    this.onPeriodChanged,
  });

  @override
  State<TimePeriodDropdown> createState() => _TimePeriodDropdownState();
}

class _TimePeriodDropdownState extends State<TimePeriodDropdown> {
  final GlobalKey _buttonKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;

  final List<String> _timePeriods = [
    'This Month',
    'Last Month',
    'This Quarter',
    'Last Quarter',
    'This Year',
    'Last Year',
    'Custom Range',
  ];

  late String _selectedPeriod;

  @override
  void initState() {
    super.initState();
    _selectedPeriod = widget.selectedPeriod ?? 'This Month';
  }

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  void _toggleDropdown() {
    if (_isOpen) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }

  void _openDropdown() {
    _isOpen = true;
    _showOverlay();
  }

  void _closeDropdown() {
    _isOpen = false;
    _removeOverlay();
  }

  void _showOverlay() {
    final RenderBox? renderBox =
        _buttonKey.currentContext?.findRenderObject() as RenderBox?;

    if (renderBox == null) return;

    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    // Get screen dimensions
    final screenSize = MediaQuery.of(context).size;

    // Calculate dropdown width and position
    double dropdownWidth = size.width.clamp(160.w, 200.w);
    double leftPosition = offset.dx;

    // Ensure dropdown doesn't go off screen
    if (leftPosition + dropdownWidth > screenSize.width) {
      leftPosition = screenSize.width - dropdownWidth - 16.w;
    }

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: 0,
        top: 0,
        width: screenSize.width,
        height: screenSize.height,
        child: GestureDetector(
          onTap: _closeDropdown,
          child: Container(
            color: Colors.transparent,
            child: Stack(
              children: [
                Positioned(
                  left: leftPosition,
                  top: offset.dy + size.height + 8.h,
                  width: dropdownWidth,
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: _timePeriods.asMap().entries.map((entry) {
                          final index = entry.key;
                          final period = entry.value;
                          final isSelected = period == _selectedPeriod;
                          final isFirst = index == 0;
                          final isLast = index == _timePeriods.length - 1;

                          return InkWell(
                            onTap: () => _selectPeriod(period),
                            borderRadius: BorderRadius.vertical(
                              top:
                                  isFirst ? Radius.circular(12.r) : Radius.zero,
                              bottom:
                                  isLast ? Radius.circular(12.r) : Radius.zero,
                            ),
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 12.h,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Colors.blue.shade50
                                    : Colors.transparent,
                                borderRadius: BorderRadius.vertical(
                                  top: isFirst
                                      ? Radius.circular(12.r)
                                      : Radius.zero,
                                  bottom: isLast
                                      ? Radius.circular(12.r)
                                      : Radius.zero,
                                ),
                              ),
                              child: Text(
                                period,
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.blue.shade700
                                      : Colors.black87,
                                  fontSize: 14.sp,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _selectPeriod(String period) {
    setState(() {
      _selectedPeriod = period;
    });
    widget.onPeriodChanged?.call(period);
    _closeDropdown();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: _buttonKey,
        onTap: _toggleDropdown,
        borderRadius: BorderRadius.circular(8.r),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 12.w,
            vertical: 8.h,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _selectedPeriod,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 12.sp,
                  letterSpacing: 0.8,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: 8.w),
              Icon(
                Icons.keyboard_arrow_down,
                color: Colors.black87,
                size: 16.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
