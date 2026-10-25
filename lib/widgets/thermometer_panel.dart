import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../theme/tokens.dart';
import 'chunky_button.dart';
import 'thermometer_painter.dart';

/// Hold the flame button to heat the thermometer up, release to let it cool.
/// Keeping the temperature inside the ideal band for a few seconds straight
/// succeeds. The band is set by the caller, so each preparation can ask for
/// its own real temperature range.
class ThermometerPanel extends StatefulWidget {
  const ThermometerPanel({
    super.key,
    required this.title,
    required this.idealMin,
    required this.idealMax,
    this.onSuccess,
  });

  final String title;
  final double idealMin;
  final double idealMax;
  final VoidCallback? onSuccess;

  @override
  State<ThermometerPanel> createState() => _ThermometerPanelState();
}

class _ThermometerPanelState extends State<ThermometerPanel> with SingleTickerProviderStateMixin {
  static const double _minTemp = 0.0;
  static const double _maxTemp = 100.0;
  static const double _heatRatePerSecond = 22.0;
  static const double _coolRatePerSecond = 14.0;
  static const Duration _requiredSteady = Duration(seconds: 4);
  static const double _coldToWarmTemp = 30.0;
  static const double _warmToHotTemp = 45.0;

  double _temperature = _minTemp;
  bool _isHolding = false;
  Duration _steadyElapsed = Duration.zero;
  bool _success = false;
  late final Ticker _ticker;
  Duration _lastElapsed = Duration.zero;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick)..start();
  }

  void _onTick(Duration elapsed) {
    final dt = elapsed - _lastElapsed;
    _lastElapsed = elapsed;
    if (_success) return;
    final dtSeconds = dt.inMicroseconds / 1e6;
    setState(() {
      final rate = _isHolding ? _heatRatePerSecond : -_coolRatePerSecond;
      _temperature = (_temperature + rate * dtSeconds).clamp(_minTemp, _maxTemp);
      final inRange = _temperature >= widget.idealMin && _temperature <= widget.idealMax;
      if (inRange) {
        _steadyElapsed += dt;
        if (_steadyElapsed >= _requiredSteady) {
          _success = true;
          widget.onSuccess?.call();
        }
      } else {
        _steadyElapsed = Duration.zero;
      }
    });
  }

  void _retry() {
    setState(() {
      _temperature = _minTemp;
      _isHolding = false;
      _steadyElapsed = Duration.zero;
      _success = false;
    });
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  // Continuous blue → orange → red ramp driven by the actual temperature,
  // so the liquid color eases through each band instead of snapping.
  Color _mercuryColor() {
    if (_temperature <= _coldToWarmTemp) {
      final t = (_temperature / _coldToWarmTemp).clamp(0.0, 1.0);
      return Color.lerp(Colors.blueAccent, Colors.orangeAccent, t)!;
    }
    final t = ((_temperature - _coldToWarmTemp) / (_warmToHotTemp - _coldToWarmTemp)).clamp(0.0, 1.0);
    return Color.lerp(Colors.orangeAccent, Colors.redAccent, t)!;
  }

  String _statusText() {
    if (_success) return 'Isı ideal aralıkta sabit tutuldu!';
    if (_temperature < widget.idealMin) return 'Soğuk, basılı tutarak ısıt';
    if (_temperature > widget.idealMax) return 'Çok sıcak, bırakıp soğut';
    return 'İdeal aralıkta! Sabit tut...';
  }

  // Düzen: üstte başlık ve hedef aralık, ortada termometre ve büyük sıcaklık,
  // altta (başparmak bölgesinde) durum, sabitlik çubuğu ve alev düğmesi.
  @override
  Widget build(BuildContext context) {
    const range = _maxTemp - _minTemp;
    final tempFrac = ((_temperature - _minTemp) / range).clamp(0.0, 1.0);
    final steadyFrac = (_steadyElapsed.inMilliseconds / _requiredSteady.inMilliseconds).clamp(0.0, 1.0);
    final target = '${widget.idealMin.round()}–${widget.idealMax.round()}°';

    return Container(
      padding: const EdgeInsets.all(AppSpace.xl),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: Text(widget.title, style: AppText.title(size: 22))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpace.md, vertical: AppSpace.xs),
                decoration: BoxDecoration(
                  color: AppColors.successSoft,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: Text('Hedef $target', style: AppText.label(color: AppColors.success)),
              ),
            ],
          ),
          const SizedBox(height: AppSpace.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 96,
                height: 210,
                child: CustomPaint(
                  painter: ThermometerPainter(
                    value: tempFrac,
                    idealMinFrac: (widget.idealMin - _minTemp) / range,
                    idealMaxFrac: (widget.idealMax - _minTemp) / range,
                    idealMinLabel: '${widget.idealMin.round()}°',
                    idealMaxLabel: '${widget.idealMax.round()}°',
                    color: _mercuryColor(),
                  ),
                ),
              ),
              const SizedBox(width: AppSpace.xxl),
              SizedBox(
                width: 110,
                child: Text(
                  '${_temperature.round()}°',
                  style: AppText.timer(size: 56, color: _mercuryColor()),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpace.lg),
          Text(_statusText(), textAlign: TextAlign.center, style: AppText.body(weight: FontWeight.w600)),
          const SizedBox(height: AppSpace.md),
          if (!_success) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.pill),
              child: LinearProgressIndicator(
                minHeight: 10,
                value: steadyFrac,
                backgroundColor: AppColors.successSoft,
                valueColor: const AlwaysStoppedAnimation(AppColors.success),
              ),
            ),
            const SizedBox(height: AppSpace.xl),
            Listener(
              onPointerDown: (_) => setState(() => _isHolding = true),
              onPointerUp: (_) => setState(() => _isHolding = false),
              onPointerCancel: (_) => setState(() => _isHolding = false),
              child: Semantics(
                button: true,
                label: 'Isıt: basılı tut',
                child: Container(
                  key: const Key('flame-button'),
                  width: 96,
                  height: 96,
                  alignment: Alignment.center,
                  // Tıknaz düğme gibi: altta koyu gölge, basılı tutunca kaybolur.
                  transform: Matrix4.translationValues(0, _isHolding ? 5 : 0, 0),
                  decoration: BoxDecoration(
                    color: AppColors.kiremit,
                    shape: BoxShape.circle,
                    boxShadow: [
                      if (!_isHolding) const BoxShadow(color: AppColors.kiremitDark, offset: Offset(0, 5)),
                    ],
                  ),
                  child: const Icon(Icons.local_fire_department_rounded, color: Colors.white, size: 44),
                ),
              ),
            ),
            const SizedBox(height: AppSpace.sm),
            Text('Basılı tut: ısıt · bırak: soğut', style: AppText.label(size: 12)),
          ] else ...[
            const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 44),
            const SizedBox(height: AppSpace.lg),
            SizedBox(
              width: double.infinity,
              child: ChunkyButton.secondary(label: 'Tekrar Dene', onPressed: _retry),
            ),
          ],
        ],
      ),
    );
  }
}
