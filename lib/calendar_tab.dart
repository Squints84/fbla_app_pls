import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarTab {
  Widget tab(){
    return SfCalendar(
      view: CalendarView.month,
      monthViewSettings: const MonthViewSettings(
        showAgenda: true
      )
    );
  }
}