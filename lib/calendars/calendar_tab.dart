import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'calendar_classes.dart';
import '../icons_and_colors/school_identities.dart';
import 'events.dart';
import '../extra.dart';

class CalendarTab extends StatefulWidget {
  const CalendarTab({super.key});

  @override
  State<CalendarTab> createState() => _CalendarTabState();
}

class _CalendarTabState extends State<CalendarTab> with AutomaticKeepAliveClientMixin<CalendarTab> {
  List<Appointment> _appointmentDetails = <Appointment>[];

	@override
  bool get wantKeepAlive => true;

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(flex:5,
              child: SfCalendar(
                minDate: DateTime(2021, DateTime.september),
                maxDate: DateTime(2023, DateTime.june),
								view: CalendarView.month,
                showDatePickerButton: true,
                initialSelectedDate: DateTime.now(),
								dataSource: DataSource.getCalendarDataSource(),
								onTap: calendarTapped,
								monthViewSettings: const MonthViewSettings(
									appointmentDisplayCount: 10
								),
                monthCellBuilder: (BuildContext buildContext, MonthCellDetails details) {
                  bool currentDay = details.date.toString().split(" ")[0] == DateTime.now().toString().split(" ")[0];
                  int year = details.visibleDates[21].year;
                  int month = details.visibleDates[21].month;
                  int firstSunday = 7 - DateTime(year,month,1).weekday; firstSunday == 0 ? 7 : firstSunday;
                  bool currentMonth = details.date.month.toString() == month.toString();

                  return Container(
                    padding: currentDay ? const EdgeInsets.only(top: 4, right: 2) : const EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                      gradient: (DataSource.findWithDate(details.date, DataSource.halfDays) || details.date.toString().split(" ")[0] == DataSource.findWithTitle("Last Day of School", year, DataSource.schoolYearBookends).toString().split(" ")[0])
                      ? LinearGradient(
                        colors: [
                          Theme.of(context).canvasColor,
                          Theme.of(context).canvasColor,
                          ExtraStuff.darken(Theme.of(context).canvasColor, 0.04),
                          ExtraStuff.darken(Theme.of(context).canvasColor, 0.04)
                        ],
                        stops: const [0, 0.55, 0.55, 1],
                        end: Alignment.bottomCenter,
                        begin: Alignment.topCenter,
                      )
                      : null,
                      color: (details.date.weekday == 6 || details.date.weekday == 7)
                      || (DataSource.findWithDate(details.date, DataSource.plannedClosings) || DataSource.findWithDate(details.date, DataSource.unplannedClosings))
                      || (details.date.isAfter(DataSource.findWithTitle("Last Day of School", year, DataSource.schoolYearBookends)!) && details.date.isBefore(DataSource.findWithTitle("First Day of School", year, DataSource.schoolYearBookends)!))
                        ? ExtraStuff.darken(Theme.of(context).canvasColor, 0.04)
                        : Theme.of(context).canvasColor,
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
                      alignment: Alignment.topLeft,
                      child: currentDay
                      ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
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
                                style: const TextStyle(color: Colors.white, fontSize: 13)
                              ),
                            ),
                          ),
                          Text(
                            DataSource.findWithTitle("First Day of School", year, DataSource.schoolYearBookends) == DateTime.parse(details.date.toString().split(" ")[0])
                            ? "A"
                            : ABdays.daysFinder(details.date),
                            style: TextStyle(fontSize: 13, color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold)
                          )
                        ]
                      )
                      : (currentMonth
                        ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              details.date.day.toString(),
                              style: const TextStyle(fontSize: 13)
                            ),
                            Text(
                              DataSource.findWithTitle("First Day of School", year, DataSource.schoolYearBookends) == DateTime.parse(details.date.toString().split(" ")[0])
                              ? "A"
                              : ABdays.daysFinder(details.date),
                              style: TextStyle(fontSize: 13, color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold)
                            )
                          ]
                        )
                        : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              details.date.day.toString(),
                              style: const TextStyle(fontSize: 13, color: Colors.black45)
                            ),
                            Text(
                              DataSource.findWithTitle("First Day of School", year, DataSource.schoolYearBookends) == DateTime.parse(details.date.toString().split(" ")[0])
                              ? "A"
                              : ABdays.daysFinder(details.date),
                              style: TextStyle(fontSize: 13, color: Theme.of(context).primaryColor.withOpacity(0.45), fontWeight: FontWeight.bold)
                            )
                          ]
                        )
                      )
                    ),
                  );
                },
							),
            ),
            Expanded(flex:2,
              child: Container(
								color: Colors.black12,
								child: ListView.separated(
									padding: const EdgeInsets.all(5),
									itemCount: _appointmentDetails.length,
									itemBuilder: (BuildContext context, int index) {
										return Container(
											padding: const EdgeInsets.all(2),
											height: 60,
											color: _appointmentDetails[index].id != "Closed" && _appointmentDetails[index].id != "HalfDay"
                        ? _appointmentDetails[index].color
                        :  _appointmentDetails[index].subject.contains("Last Day of School")
                          ? SchoolColors.UCVTS
                          : Colors.red[600],
											child: ListTile(
												contentPadding: const EdgeInsets.fromLTRB(10, 0, 20, 0),
												leading: _appointmentDetails[index].id == "Closed"
                        ? null
                        : ExtraStuff.centerAlign(
                          (_appointmentDetails[index].isAllDay
                          ? [
                            const Text(
                              "All Day",
                              style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
                              textAlign: TextAlign.center,
                            )
                          ]
                          : [
                            Text(
                              DateFormat.jm().format(_appointmentDetails[index].startTime),
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              DateFormat.jm().format(_appointmentDetails[index].endTime),
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
                            ),
                          ])
                        ),
												title: FittedBox(
													fit: BoxFit.scaleDown,
													child: Text(
                            _appointmentDetails[index].id != "Closed" && _appointmentDetails[index].id != "HalfDay"
                            ? "${_appointmentDetails[index].subject} ${(_appointmentDetails[index].notes != null && _appointmentDetails[index].notes != "UCVTS") ? "for ${_appointmentDetails[index].notes}" : ""}${_appointmentDetails[index].location != null ? "\nin ${_appointmentDetails[index].location}" : ""}"
                            :  _appointmentDetails[index].id == "HalfDay"
                              ? !_appointmentDetails[index].subject.contains("Last Day of School")
                                ? "Early Dismissal for ${_appointmentDetails[index].subject}"
                                : "Have a great summer!!!"
                              : "Closed for ${_appointmentDetails[index].subject}",
														textAlign: TextAlign.center,
														style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white)
													)
												),
												trailing: _appointmentDetails[index].id != "Closed" && _appointmentDetails[index].id != "HalfDay"
                        ? Icon(SchoolIcons.getSchoolIcon(_appointmentDetails[index].notes!), size: 30, color: Colors.white)
                        :  _appointmentDetails[index].subject.contains("Last Day of School")
                          ? const Icon(SchoolIcons.UCVTS, size: 30, color: Colors.white)
                          : null,
											)
										);
									},
									separatorBuilder: (BuildContext context, int index) => const Divider(height: 5, color: Colors.transparent),
								)
							)
						)
          ],
        ),
      ),
    );
  }

  void calendarTapped(CalendarTapDetails calendarTapDetails) {
    if (calendarTapDetails.targetElement == CalendarElement.calendarCell) {
      setState(() {
        _appointmentDetails = calendarTapDetails.appointments!.cast<Appointment>();
      });
    }
  }
}