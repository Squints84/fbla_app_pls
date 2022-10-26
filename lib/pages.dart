import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

class StaffDirectoryPage extends StatelessWidget {
  const StaffDirectoryPage({Key? key}) : super(key: key);
  final String title = "Staff Directory";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(title,
          style: const TextStyle(fontSize: 17.5),
          textAlign: TextAlign.center)),
      body: const Center(child: Text("UCVTS Staff :)")),
    );
  }
}

class ImportantFormsPage extends StatelessWidget {
  const ImportantFormsPage({Key? key}) : super(key: key);
  final String title = "Important Forms";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text(title,
              style: const TextStyle(fontSize: 17.5),
              textAlign: TextAlign.center)),
      body: const Center(child: Text("UCVTS Forms :)")),
    );
  }
}

class DistrictNewsLetterPage extends StatelessWidget {
  DistrictNewsLetterPage({Key? key}) : super(key: key);
  final String title = "District Newsletter";
  final List months = [
    'JANUARY',
    'FEBRUARY',
    'MARCH',
    'APRIL',
    'MAY',
    'JUNE',
    'JULY',
    'AUGUST',
    'SEPTEMBER',
    'OCTOBER',
    'NOVEMBER',
    'DECEMBER'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(title,style: const TextStyle(fontSize: 17.5),textAlign: TextAlign.center)
      ),
      body: Center(
        child: const PDF().cachedFromUrl('https://www.ucvts.org/cms/lib/NJ50000421/Centricity/Domain/4/UCVTS%20DISTRICT%20NEWSLETTER%20${months[DateTime.now().month - 1]}%20${DateTime.now().year.toString()}.pdf')
      ),
    );
  }
}