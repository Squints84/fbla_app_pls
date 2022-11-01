import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'custom_icons_icons.dart';
import 'school_identities.dart';
import 'calendar_tab.dart';
import 'extra.dart';
import 'panel.dart';

void main() => runApp(const MyApp());

PanelController _pc = PanelController();
Slidey slide = Slidey();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // Application name
      title: 'UCVTS App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        canvasColor: Colors.blue[50],
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
      ),
      // A widget which will be started on application startup
      home: const MyHomePage(title: 'Union County\nVocational-Technical Schools')
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String school = "AIT";

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          leading: Transform.scale(
            scale: 2,
            child: IconButton(
              icon: const ImageIcon(AssetImage('assets/UCVTS.png')),
              onPressed: () async {
                if (!await launchUrl(Uri.parse('https://www.ucvts.org/'))) {
                  throw 'Could not reach UCVTS.org at this time.';
                }
              },
            )
          ),
          centerTitle: true,
          title: FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(widget.title,
              style: const TextStyle(decoration: TextDecoration.underline),
              textAlign: TextAlign.center
            )
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.check_box),
              tooltip: 'Fact  Checker',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text.rich(TextSpan(
                      style: TextStyle(fontSize: 20),
                      children: <TextSpan>[
                        TextSpan(text: '^ The above message is '),
                        TextSpan(
                          text: 'TRUE',
                          style: TextStyle(
                            color: Color(0xff00ff08),
                            fontWeight: FontWeight.bold
                          )
                        ),
                        TextSpan(text: '!!!')
                      ]
                    ))
                  )
                ));
              },
            )
          ]
        ),
        bottomNavigationBar: SafeArea(
          child: Container(
            color: const Color(0xff2196f3),
            child: TabBar(
              onTap: (int i){
                i == 1 ? _pc.hide() : _pc.show();
              }, 
              tabs: const [
              Tab(icon: Icon(Icons.house)),
              Tab(icon: Icon(Icons.calendar_month)),
              Tab(icon: Icon(CustomIcons.picture)), // *person in desk but person is just a silhoutte*
              Tab(icon: Icon(Icons.assignment_late)) // wassup
              ]
            )
          ),
        ),
        body: Stack(children: <Widget>[
          TabBarView(physics: const NeverScrollableScrollPhysics(), children: [
            // The displays of the different tabs, in order (VERY IMPORTANT)
            SingleChildScrollView(child:
              ExtraStuff.centerAlign([
                ExtraStuff.weLoveAIT,
                const SizedBox(height: 30),
                const SizedBox(height: 280, child: UpcomingEvents()),
                const SizedBox(height: 30),
                const Text("We Love Clubs!!!", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Column(children: List.generate(6, (i) => Text("\nCLUB TITLE - ${"Description " * 12}\n")).toList()),
                const SizedBox(height: 29 + 5)
              ]),
            ),
            const CalendarTab(),
            ExtraStuff.centerAlign([
              const Icon(CustomIcons.ucvts),
              Text("${DateTime.now().year.toString()}-${DateTime.now().month.toString()}-${DateTime.now().day.toString()}"),
              const Text("\n\nUCVTS Logo",style: TextStyle(color: SchoolColors.UCVTS)),
              const Text("\n\nMagnet more like bad",style: TextStyle(color: SchoolColors.Magnet))
            ]),
            ExtraStuff.centerAlign([
              Text('tabBar Height = 29\n\nOG Panel Height = ${screenHeight * 0.8}\n vs.\nError Height = ${(29 + 22 + (Slidey.buttonHeight * 4) + 40)}'),
              const Text("\n\nIT'S ALIIIIIIIVE v29"),
              Text('Panel Width = ${MediaQuery.of(context).size.width}'),
              const SizedBox(height: 30),
              Image.asset('assets/Dole.jpg', alignment: Alignment.center)
            ])
          ]),
          SlidingUpPanel(
            controller: _pc,
            minHeight: 29,
            maxHeight: (29 + 22 + (Slidey.buttonHeight * 4) + 40), // Height of the gripbar (minus some padding) + height of the buttons + height of the seperators between the buttons
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(18.0),
              topRight: Radius.circular(18.0)
            ),
            color: const Color(0xfff2f2f2), // I only colored it so you can see the difference between the phone border and the panel
            onPanelOpened: () {setState(() {Slidey.opened = true;});},
            onPanelClosed: () {setState(() {Slidey.opened = false;});},
            panelBuilder: (ScrollController sc) => slide.panel(_pc,sc)
          )
        ])
      )
    );
  }
}
/*
screenHeight * 0.7,
vs 
(29 + 22 + (Slidey.buttonHeight * 4) + 40),
*/