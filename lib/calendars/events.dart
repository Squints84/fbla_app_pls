import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../icons_and_colors/school_identities.dart';

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
    id: "Closed",
    startTime: humanToDateTime(date, "00:00"),
    endTime: humanToDateTime(date, "23:59"),
		isAllDay: true,
    subject: title,
    color: Colors.transparent,
  );

  HumanFriendlyAppointment.halfDay({required this.date, required this.title}) :
  super(
    id: "HalfDay",
    startTime: humanToDateTime(date, "08:00"),
    endTime: humanToDateTime(date, "12:24"),
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

  static DateTime? findWithTitle(String findTitle, int year, List<Appointment> directory, [int offset = 0]){
    for (Appointment appt in directory) {
      if (appt.subject.contains(findTitle) && appt.startTime.year == year){
        return DateTime(appt.startTime.year, appt.startTime.month, appt.startTime.day + offset);
      }
    }
    return null;
  }

  static bool findWithDate(DateTime findDate, List<Appointment> directory){
    for (Appointment appt in directory) {
      if (DateTime(appt.startTime.year, appt.startTime.month, appt.startTime.day) == DateTime(findDate.year, findDate.month, findDate.day)){
        return true;
      }
    }
    return false;
  }

  static List<Appointment> appts = generalEvents + districtWideEvents + schoolSpecificEvents + clubEvents + schoolYearBookends + schoolClosings + halfDays;

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
    HumanFriendlyAppointment.allDay(date: "9/8/21", title: "First Day of School 2021-22"),
    HumanFriendlyAppointment.halfDay(date: "6/20/22", title: "Last Day of School 2021-22"),
    HumanFriendlyAppointment.allDay(date: "9/6/22", title: "First Day of School 2022-23"),
    HumanFriendlyAppointment.halfDay(date: "6/20/23", title: "Last Day of School 2022-23"),
    HumanFriendlyAppointment.allDay(date: "9/7/23", title: "First Day of School 2023-24???"),
  ];

  static List<Appointment> schoolClosings = plannedClosings + unplannedClosings;

  static List<Appointment> plannedClosings = <Appointment>[
    HumanFriendlyAppointment.closed(date: "9/26/22", title: "Rosh Hashanah"),
    HumanFriendlyAppointment.closed(date: "10/5/22", title: "Yom Kippur"),
    HumanFriendlyAppointment.closed(date: "11/10/22", title: "NJEA Convention"),
    HumanFriendlyAppointment.closed(date: "11/11/22", title: "NJEA Convention"),
    HumanFriendlyAppointment.closed(date: "11/24/22", title: "Thanksgiving"),
    HumanFriendlyAppointment.closed(date: "11/25/22", title: "Thanksgiving"),
    HumanFriendlyAppointment.closed(date: "12/26/22", title: "Winter Break"),
    HumanFriendlyAppointment.closed(date: "12/27/22", title: "Winter Break"),
    HumanFriendlyAppointment.closed(date: "12/28/22", title: "Winter Break"),
    HumanFriendlyAppointment.closed(date: "12/29/22", title: "Winter Break"),
    HumanFriendlyAppointment.closed(date: "12/30/22", title: "Winter Break"),
    HumanFriendlyAppointment.closed(date: "1/2/23", title: "Winter Break"),
    HumanFriendlyAppointment.closed(date: "1/16/23", title: "Dr. Martin Luther King, Jr. Holiday"),
    HumanFriendlyAppointment.closed(date: "2/17/23", title: "Staff Development #3"),
    HumanFriendlyAppointment.closed(date: "2/20/23", title: "Presidents' Day"),
    HumanFriendlyAppointment.closed(date: "4/7/23", title: "Good Friday"),
    HumanFriendlyAppointment.closed(date: "4/10/23", title: "Spring Break"),
    HumanFriendlyAppointment.closed(date: "4/11/23", title: "Spring Break"),
    HumanFriendlyAppointment.closed(date: "4/12/23", title: "Spring Break"),
    HumanFriendlyAppointment.closed(date: "4/13/23", title: "Spring Break"),
    HumanFriendlyAppointment.closed(date: "4/14/23", title: "Spring Break"),
    HumanFriendlyAppointment.closed(date: "5/29/23", title: "Memorial Day"),
    HumanFriendlyAppointment.closed(date: "6/16/23", title: "Juneteenth"),
  ];

  static List<Appointment> unplannedClosings = <Appointment>[
    HumanFriendlyAppointment.closed(date: "10/6/22", title: "Power Repairs")
  ];

  static List<Appointment> halfDays = <Appointment>[
    HumanFriendlyAppointment.halfDay(date: "11/23/22", title: "Thanksgiving"),
    HumanFriendlyAppointment.halfDay(date: "12/23/22", title: "Winter Break"),
    HumanFriendlyAppointment.halfDay(date: "4/6/23", title: "Spring Break")
  ];
}