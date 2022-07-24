import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'models/gauge_station.dart';
import 'pages/gauge_detail_page/gauge_detail_page.dart';
import 'pages/home_page/home_page.dart';

class RouterProvider {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    if (settings.name == HomePage.routeName) return _route(HomePage());

    if (settings.name == GaugeStationDetailPage.routeName) {
      return _route(
        GaugeStationDetailPage(arguments: settings.arguments as GaugeStationDetailPageArgs),
      );
    }

    return null;
  }

  static _route(Widget child) => MaterialPageRoute(builder: (context) => child);
}
