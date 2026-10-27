import 'package:flutter/material.dart';

import '../models/prescription.dart';
import 'heating_sheet.dart';

/// Oyuncunun bir istasyonda kendisinin yaptığı iş: sırası gelince ne yazar,
/// düğmede ne olur. Şimdilik yalnız su banyosunda termometre var.
({String prompt, String button, IconData icon}) stationAction(LabStation station) => (
      prompt: '${station.label}: fazlar ısındı. Sıcaklığı sen ayarla.',
      button: 'Sıcaklığı ayarla',
      icon: Icons.thermostat_rounded,
    );

/// İstasyonun oyuncu penceresini açar (su banyosu: termometre).
Future<void> openStationAction(BuildContext context, LabStation station, String magistralName) =>
    openHeating(context, magistralName: magistralName);
