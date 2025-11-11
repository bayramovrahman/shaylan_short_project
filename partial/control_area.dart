import 'package:flutter/material.dart';
import 'package:shaylan_agent/database/functions/user.dart';
import 'package:shaylan_agent/models/static_data.dart';
import 'package:shaylan_agent/models/user.dart';
import 'package:shaylan_agent/partial/kollektor_gridview.dart';
import 'package:shaylan_agent/partial/merchandisergrivet.dart';
import 'package:shaylan_agent/partial/supervisor_gridview.dart';
import 'package:shaylan_agent/partial/tradingagentgritview.dart';
import 'package:shaylan_agent/partial/warehouse_manager_gridview.dart';

class ControlArea extends StatefulWidget {
  const ControlArea({super.key});

  @override
  State<ControlArea> createState() => _ControlAreaState();
}

class _ControlAreaState extends State<ControlArea> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: FutureBuilder<User>(
        future: getUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.connectionState == ConnectionState.done) {
            User user = snapshot.data!;
            Widget gridviewWidget = const SizedBox();

            switch (user.jobTitle) {
              case UserJobTtitle.ekspeditor:
                gridviewWidget = const MerchandaiserGrivew();
                break;
              case UserJobTtitle.ammarcy:
                gridviewWidget = const WarehouseManagerGridview();
                break;
              case UserJobTtitle.superwayzer:
                gridviewWidget = const SupervisorGridview();
                break;
              case UserJobTtitle.sahamcaMudir:
                gridviewWidget = const SupervisorGridview();
                break;
              case UserJobTtitle.targowy:
                gridviewWidget = const TradingAgentGrivew();
                break;
              case UserJobTtitle.kollektor:
                gridviewWidget = const KollektorGridview();
                break;
              default:
                gridviewWidget = const SizedBox();
            }

            return gridviewWidget;
          } else {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
        },
      ),
    );
  }
}
