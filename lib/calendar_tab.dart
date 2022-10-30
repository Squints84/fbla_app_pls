import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'school_identities.dart';
import 'extra.dart';

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
                minDate: DateTime(2021, DateTime.september, 1),
                maxDate: DateTime(2023, DateTime.june, 30),
								view: CalendarView.month,
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
                    padding: currentDay ? const EdgeInsets.only(top: 4, right: 2) : const EdgeInsets.only(top: 8, left: 4, right: 2),
                    decoration: BoxDecoration(
                      color: (details.date.weekday == 6 || details.date.weekday == 7)
                      || (details.appointments.isNotEmpty ? details.appointments.toString().contains("id: closed") : false)
                      || (details.date.isAfter(DataSource.findWithID("lastDayOfSchool", year, DataSource.schoolYearBookends)) && details.date.isBefore(DataSource.findWithID("firstDayOfSchool", year, DataSource.schoolYearBookends)))
                        ? ExtraStuff.darken(Theme.of(context).canvasColor, 0.05)
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
                            ABdays.daysFinder(details.date),
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
                              ABdays.daysFinder(details.date),
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
                              ABdays.daysFinder(details.date),
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
											color: _appointmentDetails[index].id != "closed"
                        ? _appointmentDetails[index].color
                        : Colors.red[600],
											child: ListTile(
												contentPadding: const EdgeInsets.fromLTRB(10, 0, 20, 0),
												leading: _appointmentDetails[index].id == "closed"
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
                            _appointmentDetails[index].id != "closed"
                            ? "${_appointmentDetails[index].subject} ${_appointmentDetails[index].notes! != "UCVTS" ? "for ${_appointmentDetails[index].notes!}" : ""}${_appointmentDetails[index].location != null ? "\nin ${_appointmentDetails[index].location}" : ""}"
                            : "Closed for ${_appointmentDetails[index].subject}",
														textAlign: TextAlign.center,
														style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white)
													)
												),
												trailing: _appointmentDetails[index].id != "closed"
                        ? Icon(SchoolLogos.getSchoolLogo(_appointmentDetails[index].notes!), size: 30, color: Colors.white)
                        :  null,
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

class UpcomingEvents extends StatefulWidget {
  const UpcomingEvents({super.key});

  @override
  State<UpcomingEvents> createState() => _UpcomingEventsState();
}

class _UpcomingEventsState extends State<UpcomingEvents>  with AutomaticKeepAliveClientMixin<UpcomingEvents> {
  List<Appointment> _appointmentDetails=<Appointment>[];
	
	@override
  bool get wantKeepAlive => true;

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            SizedBox(
							height: 200,
              child: SfCalendar(
								view: CalendarView.timelineMonth,
								dataSource: DataSource.getCalendarDataSource(),
								onTap: calendarTapped,
							),
            ),
            SizedBox(height: 70,
              child: Container(
								color: Colors.black12,
								child: ListView.separated(
									physics: const NeverScrollableScrollPhysics(),
									padding: const EdgeInsets.all(5),
									itemCount: _appointmentDetails.length,
									itemBuilder: (BuildContext context, int index) {
										return Container(
											padding: const EdgeInsets.all(2),
											height: 60,
											color: _appointmentDetails[index].color,
											child: ListTile(
												contentPadding: const EdgeInsets.fromLTRB(10, 0, 20, 0),
												leading: ExtraStuff.centerAlign(
													_appointmentDetails[index].isAllDay
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
													],
												),
												title: FittedBox(
													fit: BoxFit.scaleDown,
													child: Text(
														"${_appointmentDetails[index].subject} ${_appointmentDetails[index].notes! != "UCVTS" ? "for ${_appointmentDetails[index].notes!}" : ""}${_appointmentDetails[index].location != null ? "\nin ${_appointmentDetails[index].location}" : ""}",
														textAlign: TextAlign.center,
														style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white)
													)
												),
												trailing: Icon(SchoolLogos.getSchoolLogo(_appointmentDetails[index].notes!), size: 30, color: Colors.white),
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
    if (calendarTapDetails.targetElement == CalendarElement.appointment) {
      setState(() {
        _appointmentDetails = calendarTapDetails.appointments!.cast<Appointment>();
      });
    }
    else{
      setState(() {
        _appointmentDetails.clear();
      });
    }
  }
}

class HumanFriendlyAppointment extends Appointment{
  Object? eventID;
  String date;
  String? start;
  String? end;
  String title;
  String? school;
	String? where;

  HumanFriendlyAppointment({this.eventID = "Event", required this.date, required this.start, required this.end, required this.title, this.school = "UCVTS", this.where}) :
  super(
    id: eventID,
    startTime: humanToDateTime(date, start!),
    endTime: humanToDateTime(date, end!),
    subject: title,
    notes: school,
    location: where,
    color: SchoolColors.getSchoolColor(school!),
  );

	HumanFriendlyAppointment.allDay({this.eventID = "AllDay", required this.date, required this.title, this.school = "UCVTS", this.where}) :
  super(
    id: eventID,
    startTime: humanToDateTime(date, "00:00"),
    endTime: humanToDateTime(date, "23:59"),
		isAllDay: true,
    subject: title,
    notes: school,
    location: where,
    color: SchoolColors.getSchoolColor(school!),
  );

  HumanFriendlyAppointment.closed({required this.date, required this.title}) :
  super(
    id: "closed",
    startTime: humanToDateTime(date, "00:00"),
    endTime: humanToDateTime(date, "23:59"),
		isAllDay: true,
    subject: title,
    color: Colors.transparent,
  );

  static DateTime humanToDateTime(String date, String time) => DateTime.parse("20${date.split("/")[2]}-${date.split("/")[0].length == 2 ? date.split("/")[0] : "0${date.split("/")[0]}"}-${date.split("/")[1].length == 2 ? date.split("/")[1] : "0${date.split("/")[1]}"} ${time.length == 4 ? "0$time" : time}");
}

class DataSource extends CalendarDataSource {
 DataSource(List<Appointment> source) {
   appointments = source;
 }

	static DataSource getCalendarDataSource() {
		List<Appointment> appointments = appts;
		return DataSource(appointments);
	}

  static DateTime findWithID(String findID, int year, List<Appointment> directory, [int offset = 0]){
    for (Appointment appt in directory) {
      if (appt.id == findID && appt.startTime.year == year){
        return DateTime(appt.startTime.year, appt.startTime.month, appt.startTime.day + offset);
      }
    }
    return DateTime.now();
  }

  static List<Appointment> appts = generalEvents + districtWideEvents + schoolSpecificEvents + clubEvents + schoolYearBookends + schoolClosings;

  static List<Appointment> generalEvents = <Appointment>[
    HumanFriendlyAppointment.allDay(date: "10/18/22", title: "Meeting", where: "Room 123"),
  ];

  static List<Appointment> districtWideEvents = <Appointment>[
    HumanFriendlyAppointment(date: "10/29/22", start: "11:00", end: "13:00", title: "Harvest Fest", where: "The Quad")
  ];

  static List<Appointment> schoolSpecificEvents = <Appointment>[
    HumanFriendlyAppointment(date: "10/31/22", start: "10:00", end: "14:00", title: "Halloween Party", school: "UCTech"),
    HumanFriendlyAppointment(date: "10/31/22", start: "11:00", end: "15:00", title: "Halloween Party", school: "AIT"),
    HumanFriendlyAppointment(date: "10/31/22", start: "09:00", end: "11:00", title: "Halloween Party", school: "Magnet"),
    HumanFriendlyAppointment.allDay(date: "10/31/22", title: "Halloween Party", school: "APA"),
  ];

  static List<Appointment> clubEvents = <Appointment>[
    HumanFriendlyAppointment(date: "11/3/22", start: "19:00", end: "22:00", title: "Drama Club - CoffeeHouse", where: "Baxel Hall Auditorium"),
    HumanFriendlyAppointment(date: "11/4/22", start: "19:00", end: "22:00", title: "Drama Club - CoffeeHouse", where: "Baxel Hall Auditorium"),
  ];

  static List<Appointment> schoolYearBookends = <Appointment>[
    HumanFriendlyAppointment.allDay(eventID: "firstDayOfSchool", date: "9/8/21", title: "First Day of School 2021-22"),
    HumanFriendlyAppointment.allDay(eventID: "lastDayOfSchool", date: "6/20/22", title: "Last Day of School 2021-22"),
    HumanFriendlyAppointment.allDay(eventID: "firstDayOfSchool", date: "9/6/22", title: "First Day of School 2022-23"),
    HumanFriendlyAppointment.allDay(eventID: "lastDayOfSchool", date: "6/20/23", title: "Last Day of School 2022-23")
  ];

  static List<Appointment> schoolClosings = plannedClosings + unplannedClosings;

  static List<Appointment> plannedClosings = <Appointment>[
    HumanFriendlyAppointment.closed(date: "9/26/22", title: "Rosh Hashanah"),
    HumanFriendlyAppointment.closed(date: "10/5/22", title: "Yom Kippur"),
    HumanFriendlyAppointment.closed(date: "11/10/22", title: "NJEA Convention"),
    HumanFriendlyAppointment.closed(date: "11/11/22", title: "NJEA Convention"),
    HumanFriendlyAppointment.closed(date: "11/24/22", title: "Thanksgiving"),
    HumanFriendlyAppointment.closed(date: "11/25/22", title: "Thanksgiving")
  ];

  static List<Appointment> unplannedClosings = <Appointment>[
    HumanFriendlyAppointment.closed(date: "10/6/22", title: "Power Repairs")
  ];
}

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

  static dynamic days21_22 = ABdays.ABdayGenerator(DataSource.findWithID("firstDayOfSchool", 2021, DataSource.schoolYearBookends, -1), DataSource.findWithID("lastDayOfSchool", 2022, DataSource.schoolYearBookends, 1));
  static dynamic days22_23 = ABdays.ABdayGenerator(DataSource.findWithID("firstDayOfSchool", 2022, DataSource.schoolYearBookends, -1), DataSource.findWithID("lastDayOfSchool", 2023, DataSource.schoolYearBookends, 1));

  // ignore: non_constant_identifier_names
  static String daysFinder(DateTime date){
    if (date.isAfter(DataSource.findWithID("firstDayOfSchool", 2021, DataSource.schoolYearBookends, -1)) && date.isBefore(DataSource.findWithID("lastDayOfSchool", 2022, DataSource.schoolYearBookends, 1))){ 
      return days21_22.containsKey(date) ? days21_22[date] : "";
    }
    else if (date.isAfter(DataSource.findWithID("firstDayOfSchool", 2022, DataSource.schoolYearBookends, -1)) && date.isBefore(DataSource.findWithID("lastDayOfSchool", 2023, DataSource.schoolYearBookends, 1))){ 
      return days22_23.containsKey(date) ? days22_23[date] : "";
    }
    else{
      return "";
    }
  }
}


// default monthCellBuilder
/*dynamic monthCellBuilder (BuildContext BuildContext, MonthCellDetails details) {
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
}*/