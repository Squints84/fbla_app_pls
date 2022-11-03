import 'package:flutter/material.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';

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

class DistrictNewsLetterPage extends StatefulWidget {
  const DistrictNewsLetterPage({Key? key}) : super(key: key);
  final String title = "District Newsletter";
  static final List months = [
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
  State<DistrictNewsLetterPage> createState() => _DistrictNewsLetterPageState();
}

class _DistrictNewsLetterPageState extends State<DistrictNewsLetterPage> {
  final String url = 'https://www.ucvts.org/cms/lib/NJ50000421/Centricity/Domain/4/UCVTS%20DISTRICT%20NEWSLETTER%20${DistrictNewsLetterPage.months[DateTime.now().month - 1]}%20${DateTime.now().year}.pdf';
  final String url2 = 'https://www.africau.edu/images/default/sample.pdf';
  bool _isLoading = true;
  late PDFDocument document;

  @override
  void initState() {
    super.initState();
    loadDocument();
  }

  loadDocument() async {
    document = await PDFDocument.fromURL(url2);

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title,style: const TextStyle(fontSize: 17.5),textAlign: TextAlign.center)
      ),
      body: Center(
        child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : PDFViewer(
            document: document,
            lazyLoad: false,
            showPicker: false,
            showIndicator: false
          ),
      ),
    );
  }
}