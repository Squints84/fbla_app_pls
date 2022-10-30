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
            Expanded(flex:5,
              child: SfCalendar(
								view: CalendarView.month,
								dataSource: DataSource.getCalendarDataSource(),
								onTap: calendarTapped,
								monthViewSettings: const MonthViewSettings(
									appointmentDisplayCount: 10
								)
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
  String date;
  String? start;
  String? end;
  String title;
  String? school;
	String? where;

  HumanFriendlyAppointment({required this.date, required this.start, required this.end, required this.title, this.school = "UCVTS", this.where}) :
  super(
    startTime: humanToDateTime(date, start!),
    endTime: humanToDateTime(date, end!),
    subject: title,
    notes: school,
    location: where,
    color: SchoolColors.getSchoolColor(school!),
  );

	HumanFriendlyAppointment.allDay({required this.date, required this.title, this.school = "UCVTS", this.where}) :
  super(
    startTime: humanToDateTime(date, "00:00"),
    endTime: humanToDateTime(date, "23:59"),
		isAllDay: true,
    subject: title,
    notes: school,
    location: where,
    color: SchoolColors.getSchoolColor(school!),
  );

  static DateTime humanToDateTime(String date, String time) => DateTime.parse("20${date.split("/")[2]}-${date.split("/")[0]}-${date.split("/")[1].length == 2 ? date.split("/")[1] : "0${date.split("/")[1]}"} ${time.length == 4 ? "0$time" : time}");
}

class DataSource extends CalendarDataSource {
 DataSource(List<Appointment> source) {
   appointments = source;
 }

	static DataSource getCalendarDataSource() {
		List<Appointment> appointments = <Appointment>[];
		appointments.add(HumanFriendlyAppointment.allDay(date: "10/29/22", title: "Meeting", where: "Room 123"));
		appointments.add(HumanFriendlyAppointment(date: "10/31/22", start: "10:00", end: "14:00", title: "Halloween Party", school: "UCTech"));
		appointments.add(HumanFriendlyAppointment(date: "10/31/22", start: "11:00", end: "15:00", title: "Halloween Party", school: "AIT"));
		appointments.add(HumanFriendlyAppointment(date: "10/31/22", start: "09:00", end: "11:00", title: "Halloween Party", school: "Magnet"));
		appointments.add(HumanFriendlyAppointment.allDay(date: "10/31/22", title: "Halloween Party", school: "APA"));
		appointments.add(HumanFriendlyAppointment(date: "10/29/22", start: "11:00", end: "13:00", title: "Harvest Fest", where: "The Quad"));
		appointments.add(HumanFriendlyAppointment(date: "11/3/22", start: "19:00", end: "22:00", title: "Drama Club - CoffeeHouse", where: "Baxel Hall Auditorium"));
		appointments.add(HumanFriendlyAppointment(date: "11/4/22", start: "19:00", end: "22:00", title: "Drama Club - CoffeeHouse", where: "Baxel Hall Auditorium"));

		return DataSource(appointments);
	}
}