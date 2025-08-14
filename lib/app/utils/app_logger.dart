import 'package:talker/talker.dart';

class AppLogger {
  static final Talker _talker = Talker(
    settings: TalkerSettings(useConsoleLogs: true, maxHistoryItems: 100),
  );

  static Talker get instance => _talker;

  static void debug(String message, [String? key]) {
    _talker.debug(message, key);
  }

  static void info(String message, [String? key]) {
    _talker.info(message, key);
  }

  static void warning(String message, [String? key]) {
    _talker.warning(message, key);
  }

  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _talker.error(message, error, stackTrace);
  }

  static void log(String message, [String? key]) {
    _talker.log(message, exception: key);
  }
}
