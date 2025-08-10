import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/data/data.dart';
import 'package:flutter_application_1/app/data/models/menu_info.dart';
import 'package:flutter_application_1/app/data/theme_data.dart';
import 'package:flutter_application_1/app/views/clockpage.dart';
import 'package:provider/provider.dart';

import '../data/enums.dart';
import 'alarmpage.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.pageBackgroundColor,
      body: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: menuItems
                .map((currentMenuInfo) => buildMenuButton(currentMenuInfo))
                .toList(),
          ),
          VerticalDivider(color: CustomColors.dividerColor, width: 1),
          Expanded(
            child: Consumer<MenuInfo>(
              builder: (BuildContext context, MenuInfo value, Widget? child) {
                if (value.menuType == MenuType.clock) {
                  return ClockPage();
                } else if (value.menuType == MenuType.alarm) {
                  return AlarmPage();
                }
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMenuButton(MenuInfo currentMenuInfo) {
    return Consumer<MenuInfo>(
      builder: (BuildContext context, MenuInfo value, Widget? child) {
        return MaterialButton(
          onPressed: () {
            // Handle button press
          },
          child: Text(currentMenuInfo.title ?? ""),
        );
      },
    );
  }
}
