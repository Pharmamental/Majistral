import 'package:game/logic/job_store.dart';
import 'package:game/models/prep_job.dart';
import 'package:game/models/prescription.dart';

/// Duvardaki ilk [order] reçetesini alır.
Future<PrepJob> take(JobStore store, PrescriptionOrder order) async =>
    (await store.accept(store.wall.firstWhere((w) => w.magistralName == order.magistralName)))!;

/// Tezgâhtaki ilk [order] işi; yoksa null.
PrepJob? jobOf(JobStore store, PrescriptionOrder order) {
  for (final j in store.jobs) {
    if (j.magistralName == order.magistralName) return j;
  }
  return null;
}
