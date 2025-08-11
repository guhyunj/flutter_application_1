import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

import 'app/data/enums.dart';
import 'app/data/models/menu_info.dart';
import 'app/views/homepage.dart';

// https://github.com/afzalali15/flutter_alarm_clock

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Flutter Local Notifications 플러그인을 Android 전용 설정으로 초기화합니다.
  ///
  /// Android 플랫폼용 초기화 설정을 생성하고 알림 응답에 대한 콜백 핸들러로
  /// 플러그인을 구성합니다. 알림이 탭되고 페이로드가 포함된 경우,
  /// 페이로드 내용이 디버그 콘솔에 출력됩니다.
  ///
  /// 알림 시스템이 제대로 작동하는 데 필요한 비동기 설정 작업을 수행하므로
  /// 초기화는 반드시 await로 기다려야 합니다..
  var initializationSettingsAndroid = AndroidInitializationSettings(
    'codex_logo',
  );
  var initializationSettingsDarwin = DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );
  var initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsDarwin,
  );
  // await flutterLocalNotificationsPlugin.initialize(
  //   initializationSettings,
  //   onDidReceiveNotificationResponse:
  //       (NotificationResponse notificationResponse) async {
  //         final String? payload = notificationResponse.payload;
  //         if (payload != null) {
  //           debugPrint('notification payload: ' + payload);
  //         }
  //       },
  // );
  runApp(
    MaterialApp(
      title: "Flutter Alarm Clock",
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ChangeNotifierProvider<MenuInfo>(
        create: (context) => MenuInfo(MenuType.clock),
        child: HomePage(),
      ),
    ),
  );
}
