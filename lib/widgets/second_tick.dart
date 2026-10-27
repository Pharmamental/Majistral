import 'dart:async';

import 'package:flutter/widgets.dart';

/// Ekranı saniyede bir yeniden çizer (sayaçlar). Sekme görünmüyorken
/// (`TickerMode` kapalı) bekler; görünür olunca hemen yenilenir. Görünmeyen
/// sekmelerin boşuna yenilenmesi telefonda kasmaya katılıyordu (2026-10-28).
mixin SecondTick<T extends StatefulWidget> on State<T> {
  Timer? _tick;
  bool _visible = true;

  @override
  void initState() {
    super.initState();
    _tick = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_visible && mounted) setState(() {});
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _visible = TickerMode.valuesOf(context).enabled;
  }

  @override
  void dispose() {
    _tick?.cancel();
    super.dispose();
  }
}
