import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/utils/app_logger.dart';
import 'package:talker_flutter/talker_flutter.dart';

class LogViewerPage extends StatelessWidget {
  const LogViewerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return TalkerScreen(talker: AppLogger.instance);
  }
}
