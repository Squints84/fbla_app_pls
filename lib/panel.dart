import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'custom_icons_icons.dart';
import 'pages.dart';

class Slidey {
  static double buttonHeight = 90; // Height of each button for easy changing access
  static bool opened = false;

  Widget panel(PanelController pc, ScrollController sc) {
    return Builder(
      builder: (BuildContext context) => ListView(
        controller: sc, // Not me spending ~2 hours trying to get this to work because I didn't read documentation...
        physics: opened ? const ScrollPhysics() : const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.only(left: 5, right: 5),
        children: <Widget>[
          _pullyBar(), // Wittle gwippy baw
          _buttonRow([
            _snackButton(context,const Icon(CustomIcons.userTimes, color: Colors.amber),"PowerSchool"), // Button1 = PowerSchool
            _snackButton(context,const Icon(CustomIcons.wallet, color: Colors.amber),"Naviance"), // Button2 = Naviance
            _linkButton(context,const Icon(Icons.contact_mail, color: Colors.amber),"https://mail.ucvts.tec.nj.us/","the Outlook District Email") // Button3 = Outlook
          ]),

          _buttonRow([
            _linkButton(context,const Text("School Lunch"),"https://ucvts.nutrislice.com/menu/uvcts-cafeteria/lunch/${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}","today's lunch menu"),
            _pageButton(context, const Text("Staff"),const StaffDirectoryPage()) // "Open a seperate flutter page with Staff Directory"
          ]),

          _buttonRow([
            _pageButton(context, const Text("District News Letter"),DistrictNewsLetterPage()) // "Built in PDF -> Talk to Kneisel"
          ]),

          _buttonRow([
            _pageButton(context, const Text("Important Forms"),const ImportantFormsPage()) // "Flutter page with direct links to PDFs"
          ])
        ]
      )
    );
  }
} // Main class containing all the stuff for the slide panel

Widget _pullyBar() {
  return Column(children: [
    const SizedBox(height: 12),
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 45,
          height: 5,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: const BorderRadius.all(Radius.circular(12.0))),
        ),
      ],
    ), // The grippy bar itself
    const SizedBox(height: 5)
  ]);
} // The little grippy bar (like Google Maps!!)

Widget _buttonRow(List<Widget> widgs) {
  return ButtonBarSuper(
    wrapType: WrapType.fit,
    wrapFit: WrapFit.divided,
    spacing: 10,
    children: widgs
  );
} // Simplification of ButtonBarSuper with premade size / format styling

Widget _snackButton(BuildContext context, Widget inside, String text) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom( minimumSize: Size.fromHeight(Slidey .buttonHeight)), // We need this stupid style thing because I think the ListView and/or the panel itself is fucking with the normal ButtonBar height setter...
    onPressed: () {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar( content: Text(text), duration: const Duration(seconds: 1)));
    }, // Action to be done upon button press
    child: inside // What the button displays
  );
} // Default button Widget so that the ButtonBars don't get too crowded, we can always add individual button styles later

Widget _pageButton(BuildContext context, Widget inside, StatelessWidget page) {
  return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size.fromHeight(Slidey.buttonHeight), // We need this stupid style thing because I think the ListView and/or the panel itself is fucking with the normal ButtonBar height setter...
      ),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return page;
        }));
      }, // Action to be done upon button press
      child: inside // What the button displays
      );
}

Widget _linkButton(BuildContext context, Widget inside, String link, String errorMessage) { 
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      minimumSize: Size.fromHeight(Slidey.buttonHeight), // We need this stupid style thing because I think the ListView and/or the panel itself is fucking with the normal ButtonBar height setter...
    ),
    onPressed: () async {
      if (!await launchUrl(Uri.parse(link))) {
        throw "Could not reach $errorMessage at this time.";
      }
    }, // Action to be done upon button press
    child: inside // What the button displays
  );
}