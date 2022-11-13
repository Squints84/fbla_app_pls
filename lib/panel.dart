import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'icons_and_colors/custom_icons_icons.dart';
import 'pages.dart';

class Slidey { // Main class containing all the stuff for the slide panel
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
            _snackButton(context, const Icon(CustomIcons.userTimes, color: Colors.amber),"PowerSchool"), // Button1 = PowerSchool
            _snackButton(context, const Icon(CustomIcons.wallet, color: Colors.amber),"Naviance"), // Button2 = Naviance
            _linkButton(context, const Icon(Icons.contact_mail, color: Colors.amber),"https://mail.ucvts.tec.nj.us/","the Outlook District Email") // Button3 = Outlook
          ]),
          _buttonRow([
            _linkButton(context, const Text("School Lunch"), "https://ucvts.nutrislice.com/menu/uvcts-cafeteria/lunch/${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}","today's lunch menu"),
            _pageButton(context, const Text("Staff"), const StaffDirectoryPage())
          ]),
          _buttonRow([
            _pageButton(context, const Text("District News Letter"), const DistrictNewsLetterPage()) // Built in PDF -> Talk to Kneisel
          ]),
          _buttonRow([
            _pageButton(context, const Text("Important Forms"), const ImportantFormsPage())
          ])
        ]
      )
    );
  }
}

Widget _pullyBar() { // The little grippy bar (like Google Maps!!)
  return Column(children: [
    const SizedBox(height: 12),
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 45,
          height: 5,
          decoration: BoxDecoration( // The grippy bar itself
            color: Colors.grey[300],
            borderRadius: const BorderRadius.all(Radius.circular(12.0))),
        ),
      ],
    ),
    const SizedBox(height: 5)
  ]);
}

Widget _buttonRow(List<Widget> widgs) { // Simplification of ButtonBarSuper with premade size / format styling
  return ButtonBarSuper(
    wrapType: WrapType.fit,
    wrapFit: WrapFit.divided,
    spacing: 10,
    children: widgs
  );
}

Widget _snackButton(BuildContext context, Widget inside, String text) { // Button that makes a SnackBar popup appear
  return ElevatedButton(
    style: ElevatedButton.styleFrom( minimumSize: Size.fromHeight(Slidey .buttonHeight)), // We need this stupid style thing because I think the ListView and/or the panel itself is fucking with the normal ButtonBar height setter...
    onPressed: () {
      ScaffoldMessenger.of(context)..removeCurrentSnackBar()..showSnackBar(SnackBar( content: Text(text), duration: const Duration(seconds: 1)));
    }, // Text to be diplayed in SnackBar upon button press
    child: inside // What the button displays
  );
}

Widget _pageButton(BuildContext context, Widget inside, Widget page) { // Button that opens a Flutter page
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      minimumSize: Size.fromHeight(Slidey.buttonHeight), // We need this stupid style thing because I think the ListView and/or the panel itself is fucking with the normal ButtonBar height setter...
    ),
    onPressed: () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => page));
    }, // Opens provided Flutter page upon button press
    child: inside // Provided name of the button
  );
}

Widget _linkButton(BuildContext context, Widget inside, String link, String errorMessage) { // Button that opens a provided url
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      minimumSize: Size.fromHeight(Slidey.buttonHeight), // We need this stupid style thing because I think the ListView and/or the panel itself is fucking with the normal ButtonBar height setter...
    ),
    onPressed: () async {
      if (!await launchUrl(Uri.parse(link))) {
        throw "Could not reach $errorMessage at this time.";
      }
    }, // Attempts to open provided url upon button press
    child: inside // What the button displays
  );
}
