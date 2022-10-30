import 'package:flutter/material.dart';
import 'school_identities.dart';

class ExtraStuff {
  static Widget weLoveAIT = Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Container(
        alignment: Alignment.center,
        child: Image.asset('assets/AIT_Logo.png') //LETS GO AIT
      ),
      const SizedBox(
        height: 10,
      ),
      const Center(
        child: Text("BEST SCHOOL",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 38,
            color: SchoolColors.AIT,
            decoration: TextDecoration.underline,
            decorationStyle: TextDecorationStyle.double),
          textAlign: TextAlign.center
        )
      )
    ]
  ); // WE LOVE AIT (A widget to commemorate our love)

  static Widget centerAlign(List<Widget> widg) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: widg
    );
  }  // Self-made aligment widget so barebonesy stuff looks nice
}
