import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'events.dart';

class ABdays{
  // ignore: non_constant_identifier_names
  static dynamic ABdayGenerator(DateTime startDate, DateTime endDate){
    dynamic days = {};
    int off = 0;
    DateTime currentDay = startDate;

    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      currentDay = DateTime(startDate.year, startDate.month, startDate.day + i);
      
      if (currentDay.weekday != 6 && currentDay.weekday != 7){
        if(!(DataSource.plannedClosings.any((appt) => DateTime.parse(appt.startTime.toString().split(" ")[0]) == currentDay))){
          days[currentDay] = (i-off)%2==0 ? "A" : "B";
        }
        else{off++;}
      }
    }
    return days;
  }

  static dynamic days21_22 = ABdays.ABdayGenerator(DataSource.findWithTitle("First Day of School", 2021, DataSource.schoolYearBookends, -1)!, DataSource.findWithTitle("Last Day of School", 2022, DataSource.schoolYearBookends, 1)!);
  static dynamic days22_23 = ABdays.ABdayGenerator(DataSource.findWithTitle("First Day of School", 2022, DataSource.schoolYearBookends, -1)!, DataSource.findWithTitle("Last Day of School", 2023, DataSource.schoolYearBookends, 1)!);

  // ignore: non_constant_identifier_names
  static String daysFinder(DateTime date){
    if (date.isAfter(DataSource.findWithTitle("First Day of School", 2021, DataSource.schoolYearBookends, -1)!) && date.isBefore(DataSource.findWithTitle("Last Day of School", 2022, DataSource.schoolYearBookends, 1)!)){ 
      return days21_22.containsKey(date) ? days21_22[date] : "";
    }
    else if (date.isAfter(DataSource.findWithTitle("First Day of School", 2022, DataSource.schoolYearBookends, -1)!) && date.isBefore(DataSource.findWithTitle("Last Day of School", 2023, DataSource.schoolYearBookends, 1)!)){ 
      return days22_23.containsKey(date) ? days22_23[date] : "";
    }
    else{
      return "";
    }
  }
}

// default monthCellBuilder
Widget monthCellBuilder (BuildContext context, MonthCellDetails details) {
  bool currentDay = details.date.toString().split(" ")[0] == DateTime.now().toString().split(" ")[0];
  int year = details.visibleDates[21].year;
  int month = details.visibleDates[21].month;
  int firstSunday = 7 - DateTime(year,month,1).weekday; firstSunday == 0 ? 7 : firstSunday;
  bool currentMonth = details.date.month.toString() == month.toString();

  return Container(
    padding: currentDay ? const EdgeInsets.only(top: 4) : const EdgeInsets.only(top: 8),
    decoration: BoxDecoration(
      color: Theme.of(context).canvasColor,
      border: details.date.isAfter(DateTime(year,month,firstSunday)) 
      ? Border.all(color: Colors.black12, width: 0.25)
      : const Border(
        top: BorderSide(color: Colors.black12, width: 1),
        bottom: BorderSide(color: Colors.black12, width: 0.5),
        left: BorderSide(color: Colors.black12, width: 0.5),
        right: BorderSide(color: Colors.black12, width: 0.5)
      )
    ),
    child: Align(
      alignment: Alignment.topCenter,
      child: currentDay
      ? Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            details.date.day.toString(),
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 13),
          ),
        ),
      )
      : (currentMonth
        ? Text(
          details.date.day.toString(),
          style: const TextStyle(fontSize: 13),
        )
        : Text(
          details.date.day.toString(),
          style: const TextStyle(fontSize: 13, color: Colors.black45),
        )
      )
    ),
  );
}