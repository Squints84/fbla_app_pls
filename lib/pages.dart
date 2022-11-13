import 'package:flutter/material.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'icons_and_colors/school_identities.dart';
import 'main.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
  final String title = "Settings";

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}
class _SettingsPageState extends State<SettingsPage> {
  String selectedSchool = MyHomePageState.school;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context, selectedSchool);
          }
        ),
        centerTitle: true,
        title: Text(widget.title,
          style: const TextStyle(fontSize: 17.5),
          textAlign: TextAlign.center
        )
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Select your school: ", style: Theme.of(context).textTheme.subtitle1),
          DropdownButton<String>(
            value: selectedSchool,
            items: SchoolNames.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? value) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar( content: Text("Updating school..."), duration: Duration(seconds: 1)));
              setState(() {
                MyHomePageState.school = value!;
                selectedSchool = value;
              });
            }
          ),
        ],
      ),
    );
  }
}

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
