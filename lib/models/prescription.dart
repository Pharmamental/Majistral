import 'package:flutter/material.dart';

class PrescriptionStep {
  const PrescriptionStep(this.label, {this.icon, this.imagePath});

  final String label;
  final IconData? icon;
  final String? imagePath;
}

class PrescriptionOrder {
  const PrescriptionOrder({
    required this.doctorName,
    required this.doctorBranch,
    required this.patientName,
    required this.magistralName,
    required this.purpose,
    required this.chemicals,
    required this.steps,
  });

  final String doctorName;
  final String doctorBranch;
  final String patientName;
  final String magistralName;
  final String purpose;
  final List<String> chemicals;
  final List<PrescriptionStep> steps;
}
