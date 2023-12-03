import 'package:fashionstore/utils/extension/datetime_extension.dart';
import 'package:fashionstore/utils/extension/number_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Calendar extends StatefulWidget {
  const Calendar({
    super.key,
    this.selectedDate,
    required this.onSelectDate,
    this.isNewDateUpdatable,
  });

  final DateTime? selectedDate;
  final void Function(DateTime) onSelectDate;
  final bool? Function(DateTime)? isNewDateUpdatable;

  @override
  State<StatefulWidget> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  late DateTime date;

  void _showCalendar() {
    showDatePicker(
      context: context,
      initialDate: widget.selectedDate ?? DateTime.now(),
      firstDate: DateTime(1940),
      lastDate: DateTime(2099),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            dialogTheme: DialogTheme(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.radius),
              ),
            ),
            colorScheme: const ColorScheme.light(
              primary: Colors.orange,
            ),
          ),
          child: child!,
        );
      },
    ).then(
      (selectedDate) {
        if (selectedDate != null) {
          bool isUpdatable = widget.isNewDateUpdatable!(selectedDate) ?? true;

          if (isUpdatable == true) {
            _selectDate(selectedDate);
          }
        }
      },
    );
  }

  void _selectDate(DateTime dateTime) {
    setState(() {
      date = dateTime;
      widget.onSelectDate(dateTime);
    });
  }

  @override
  void initState() {
    date = widget.selectedDate ?? DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showCalendar,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5.height, horizontal: 10.width),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7.radius),
          border: Border.all(
            color: const Color(0xFFA9A9AD),
          ),
        ),
        child: Row(
          children: [
            Text(
              date.date,
              style: TextStyle(
                color: const Color(0xFF606060),
                fontWeight: FontWeight.w400,
                fontSize: 13.size,
              ),
            ),
            7.horizontalSpace,
            Image.asset(
              'assets/icon/calendar_icon.png',
              width: 18.width,
              height: 16.height,
            ),
          ],
        ),
      ),
    );
  }
}
