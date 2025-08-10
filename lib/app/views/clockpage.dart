import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../data/theme_data.dart';

class ClockPage extends StatefulWidget {
  const ClockPage({super.key});

  @override
  _ClockPageState createState() => _ClockPageState();
}

class _ClockPageState extends State<ClockPage> {
  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    var formattedDate = DateFormat("EEE, d MMM").format(now);
    var timezoneString = now.timeZoneOffset.toString().split(".").first;
    var offsetSign = "";
    if (!timezoneString.startsWith("-")) {
      offsetSign = "+";
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 64),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            // flex: ,
            child: Text(
              "Clock",
              style: TextStyle(
                fontFamily: "avenir",
                fontWeight: FontWeight.w700,
                color: CustomColors.primaryTextColor,
                fontSize: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
