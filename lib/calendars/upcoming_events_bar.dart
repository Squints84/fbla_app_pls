import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../icons_and_colors/school_identities.dart';
import 'events.dart';
import '../extra.dart';

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
												trailing: Icon(SchoolIcons.getSchoolIcon(_appointmentDetails[index].notes!), size: 30, color: Colors.white),
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

