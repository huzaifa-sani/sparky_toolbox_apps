import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sparky/config/route/app_routes.dart';

class HomeController extends GetxController {
  List<Map<String, dynamic>> homeItems = [
    {'name': "Ohm's Law", 'icon': Icons.bolt, 'route': AppRoutes.ohm},
    {
      'name': 'Motor Calculator',
      'icon': Icons.electric_meter,
      'route': AppRoutes.motor,
    },
    {
      'name': 'Transformer OCPD',
      'icon': Icons.transform,
      'route': AppRoutes.transform,
    },
    {'name': 'Wire Size', 'icon': Icons.cable, 'route': AppRoutes.wire},
    {'name': 'Conduit Fill', 'icon': Icons.reorder, 'route': AppRoutes.conduit},
    {'name': 'Voltage Drop', 'icon': Icons.power, 'route': AppRoutes.voltage},
    {'name': 'Dwelling Calc', 'icon': Icons.home, 'route': AppRoutes.dwelling},
    {
      'name': 'Transformer Sizing',
      'icon': Icons.electric_bolt,
      'route': AppRoutes.transformer,
    },
    {'name': 'Solar Panel Calc', 'icon': Icons.sunny, 'route': AppRoutes.solar},
  ];
}
