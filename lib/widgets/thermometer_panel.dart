import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../theme/tokens.dart';
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

  @override
  Widget build(BuildContext context) {
    const range = _maxTemp - _minTemp;
    final tempFrac = ((_temperature - _minTemp) / range).clamp(0.0, 1.0);
    final steadyFrac = (_steadyElapsed.inMilliseconds / _requiredSteady.inMilliseconds).clamp(0.0, 1.0);
    final muted = Colors.black.withValues(alpha: 0.65);

    return Container(
      width: 260,
      padding: const EdgeInsets.all(AppSpace.xl),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: AppFont.heading,
              fontWeight: FontWeight.w800,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: AppSpace.md),
          Text(
            '${_temperature.round()}°',
            style: TextStyle(
              fontSize: AppFont.heading,
              fontWeight: FontWeight.w800,
              color: _mercuryColor(),
            ),
          ),
          const SizedBox(height: AppSpace.sm),
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
          const SizedBox(height: AppSpace.lg),
          if (!_success) ...[
            Text(
              _statusText(),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: AppFont.body, color: muted),
            ),
            const SizedBox(height: AppSpace.md),
            SizedBox(
              height: 10,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: LinearProgressIndicator(
                  value: steadyFrac,
                  backgroundColor: Colors.black12,
                  valueColor: const AlwaysStoppedAnimation(Colors.green),
                ),
              ),
            ),
            const SizedBox(height: AppSpace.lg),
            Listener(
              onPointerDown: (_) => setState(() => _isHolding = true),
              onPointerUp: (_) => setState(() => _isHolding = false),
              onPointerCancel: (_) => setState(() => _isHolding = false),
              child: Container(
                key: const Key('flame-button'),
                width: 100,
                height: 100,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withValues(alpha: _isHolding ? 0.6 : 0.35),
                      blurRadius: _isHolding ? 26 : 14,
                      spreadRadius: _isHolding ? 2 : 0,
                    ),
                  ],
                ),
                child: const Icon(Icons.local_fire_department, color: Colors.white, size: 40),
              ),
            ),
            const SizedBox(height: AppSpace.sm),
            Text(
              'Basılı tut: ısıt · bırak: soğut',
              style: TextStyle(fontSize: AppFont.caption, color: Colors.black.withValues(alpha: 0.5)),
            ),
          ] else ...[
            const Icon(Icons.check_circle, color: Colors.green, size: 40),
            const SizedBox(height: AppSpace.sm),
            Text(
              _statusText(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: AppFont.title,
                fontWeight: FontWeight.w700,
                color: AppColors.ink,
              ),
            ),
            const SizedBox(height: AppSpace.md),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.kiremit,
                  foregroundColor: Colors.white,
                ),
                onPressed: _retry,
                child: const Text('Tekrar Dene'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
