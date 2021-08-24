import 'package:flutter_flouter/src/route_information.dart';
import 'package:flutter/widgets.dart';

/// a [PageBuilder] take the route information and return a [Page]
typedef PageBuilder = Page Function(FlouterRouteInformation);
