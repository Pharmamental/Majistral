import 'package:flutter/material.dart';

import '../data/orders.dart';
import '../models/prescription.dart';
import 'heating_sheet.dart';
import 'weighing_sheet.dart';

/// Oyuncunun bir istasyonda kendisinin yaptığı iş: sırası gelince ne yazar,
/// düğmede ne olur.
({String prompt, String button, IconData icon}) stationAction(LabStation station) => switch (station) {
      LabStation.terazi => (
          prompt: 'Terazi hazır. Miktarları hesapla ve tart.',
          button: 'Tartımı yap',
          icon: Icons.scale_rounded,
        ),
      _ => (
          prompt: '${station.label}: fazlar ısındı. Sıcaklığı sen ayarla.',
          button: 'Sıcaklığı ayarla',
          icon: Icons.thermostat_rounded,
        ),
    };

/// İstasyonun oyuncu penceresini açar (terazi: tartım, su banyosu: termometre).
Future<void> openStationAction(BuildContext context, LabStation station, String magistralName) {
  if (station == LabStation.terazi) {
    final order = prescriptionOrders.firstWhere((o) => o.magistralName == magistralName);
    return openWeighing(context, order);
  }
  return openHeating(context, magistralName: magistralName);
}
