import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/app/alarm_helper.dart';
import 'package:flutter_application_1/app/data/theme_data.dart';
import 'package:intl/intl.dart';

import '../data/models/alarm_info.dart';
import '../utils/app_logger.dart';

class AlarmPage extends StatefulWidget {
  const AlarmPage({super.key});

  @override
  State<AlarmPage> createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  DateTime? _alarmTime;
  late String _alarmTImeString;
  bool _isRepeating = false;
  AlarmHelper _alarmHelper = AlarmHelper();
  Future<List<AlarmInfo>>? _alarms;
  List<AlarmInfo>? _currentAlarms;

  @override
  void initState() {
    _alarmTime = DateTime.now();
    _alarmHelper.initializeDatabase().then((value) {
      AppLogger.debug("-----database iniialized", "ALARM_PAGE");
      loadAlarms();
    });
    super.initState();
  }

  void loadAlarms() {
    _alarms = _alarmHelper.getAlarms();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 64),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Alarm",
            style: TextStyle(
              fontFamily: "avenir",
              fontWeight: FontWeight.w700,
              color: CustomColors.primaryTextColor,
              fontSize: 24,
            ),
          ),
          Expanded(
            child: FutureBuilder<List<AlarmInfo>>(
              future: _alarms,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  _currentAlarms = snapshot.data;
                  return ListView();
                } else {
                  Center(child: Text("Only 5 alarms are allowed!"));
                }
                return Center(
                  child: Text(
                    "loading...",
                    style: TextStyle(color: Colors.white),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
