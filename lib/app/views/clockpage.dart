import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/utils/app_logger.dart';
import 'package:intl/intl.dart';

import '../data/theme_data.dart';
import 'clockview.dart';

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

    AppLogger.debug('ClockPage rendering at ${now.toString()}', 'CLOCK_PAGE');

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 64),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            flex: 1,
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
          Flexible(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DigitalClockWidget(),
                Text(
                  formattedDate,
                  style: TextStyle(
                    fontFamily: "avenir",
                    fontWeight: FontWeight.bold,
                    color: CustomColors.primaryTextColor,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            flex: 4,
            fit: FlexFit.tight,
            child: Align(
              alignment: Alignment.center,
              child: ClockView(size: MediaQuery.of(context).size.height / 4),
            ),
          ),
        ],
      ),
    );
  }
}

class DigitalClockWidget extends StatefulWidget {
  const DigitalClockWidget({super.key});

  @override
  State<StatefulWidget> createState() {
    return DigitalClockWidgetState();
  }
}

class DigitalClockWidgetState extends State<DigitalClockWidget> {
  var formattedTime = DateFormat("HH:mm").format(DateTime.now());
  late Timer timer;

  @override
  Widget build(BuildContext context) {
    AppLogger.debug('digital clock updated');
    return Text(
      formattedTime,
      style: TextStyle(
        fontFamily: "avenir",
        color: CustomColors.primaryTextColor,
        fontSize: 64,
      ),
    );
  }
}
