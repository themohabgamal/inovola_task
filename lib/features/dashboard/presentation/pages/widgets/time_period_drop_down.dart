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

  final List<Map<String, dynamic>> _timePeriods = [
    {'name': 'Last 7 Days', 'icon': Icons.today_outlined},
    {'name': 'This Month', 'icon': Icons.calendar_month_outlined},
    {'name': 'Last Month', 'icon': Icons.calendar_today_outlined},
    {'name': 'This Quarter', 'icon': Icons.date_range_outlined},
    {'name': 'Last Quarter', 'icon': Icons.date_range_outlined},
    {'name': 'This Year', 'icon': Icons.calendar_month},
    {'name': 'Last Year', 'icon': Icons.history},
  ];

  late String _selectedPeriod;

  @override
  void initState() {
    super.initState();
    _selectedPeriod = widget.selectedPeriod ?? 'This Month';
  }

  @override
  void didUpdateWidget(TimePeriodDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedPeriod != null &&
        widget.selectedPeriod != _selectedPeriod) {
      setState(() {
        _selectedPeriod = widget.selectedPeriod!;
      });
    }
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
    setState(() {
      _isOpen = true;
    });
    _showOverlay();
  }

  void _closeDropdown() {
    setState(() {
      _isOpen = false;
    });
    _removeOverlay();
  }

  void _showOverlay() {
    final renderBox =
        _buttonKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy + size.height + 8,
        width: 220,
        child: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: _timePeriods.map((period) {
              final isSelected = period['name'] == _selectedPeriod;
              return ListTile(
                leading: Icon(period['icon'],
                    color: isSelected ? Colors.blue : Colors.grey),
                title: Text(period['name']),
                trailing:
                    isSelected ? Icon(Icons.check, color: Colors.blue) : null,
                onTap: () => _selectPeriod(period['name']),
              );
            }).toList(),
          ),
        ),
      ),
    );

    Overlay.of(context, rootOverlay: true).insert(_overlayEntry!);
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
        borderRadius: BorderRadius.circular(12.r),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 10.h,
          ),
          decoration: BoxDecoration(
            color: _isOpen ? Colors.blue.shade50 : Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: _isOpen ? Colors.blue.shade200 : Colors.grey[300]!,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
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
                  color: _isOpen ? Colors.blue.shade700 : Colors.black87,
                  fontSize: 12.sp,
                  letterSpacing: 0.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: 8.w),
              AnimatedRotation(
                duration: const Duration(milliseconds: 200),
                turns: _isOpen ? 0.5 : 0,
                child: Icon(
                  Icons.keyboard_arrow_down,
                  color: _isOpen ? Colors.blue.shade600 : Colors.grey[600],
                  size: 18.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
