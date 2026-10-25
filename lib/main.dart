import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: const _BevelBorder(
              borderRadius: _radiusLg,
              side: BorderSide(color: Color(0x40000000), width: 5),
            ),
            elevation: 0,
            shadowColor: Colors.transparent,
            padding: const EdgeInsets.symmetric(horizontal: _spaceXl, vertical: _spaceMd),
            textStyle: const TextStyle(fontWeight: FontWeight.w800, letterSpacing: 0.3),
          ),
        ),
      ),
      home: const RootPageView(),
    );
  }
}

// Design tokens: shared color, spacing, radius and type scale used across
// every screen so new UI stays visually consistent with the rest of the app.
const Color _kiremitColor = Color(0xFFB7410E);
const Color _creamColor = Color(0xFFF3E5C8);

const double _fontCaption = 11.0;
const double _fontBody = 13.0;
const double _fontTitle = 15.0;
const double _fontHeading = 20.0;

const double _spaceXs = 4.0;
const double _spaceSm = 8.0;
const double _spaceMd = 12.0;
const double _spaceLg = 16.0;
const double _spaceXl = 20.0;
const double _space2xl = 24.0;

const double _radiusSm = 10.0;
const double _radiusLg = 20.0;

/// Rounded-rectangle shape that fills a solid band along the bottom and
/// right edges only, giving buttons a flat, hard-edged "3D bezel" — as if a
/// second, darker copy of the button sits behind it and peeks out on the
/// side away from the (top-left) light source. `side.color` is drawn as a
/// translucent overlay so it darkens whatever background color the button
/// actually uses, rather than a fixed tone that would clash with it.
class _BevelBorder extends OutlinedBorder {
  const _BevelBorder({required this.borderRadius, super.side = BorderSide.none});

  final double borderRadius;

  @override
  ShapeBorder scale(double t) => this;

  @override
  _BevelBorder copyWith({BorderSide? side, double? borderRadius}) {
    return _BevelBorder(
      borderRadius: borderRadius ?? this.borderRadius,
      side: side ?? this.side,
    );
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) => getOuterPath(rect);

  double _clampedRadius(Rect rect) =>
      borderRadius < rect.shortestSide / 2 ? borderRadius : rect.shortestSide / 2;

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final r = _clampedRadius(rect);
    return Path()..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(r)));
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    if (side.style == BorderStyle.none || side.width <= 0) return;
    canvas.drawPath(
      _bevelBandPath(rect, _clampedRadius(rect), side.width),
      Paint()..color = side.color..style = PaintingStyle.fill,
    );
  }
}

/// The bottom+right bezel band as a fillable [Path]: the outer rounded-rect
/// minus an inner rounded-rect inset by [bandWidth] on the bottom and right
/// (flush on top/left). A rounded inner shape — rather than a square clip —
/// makes the band hug the true corner curve all the way round, since the
/// corner's rounded tip pokes out past where a straight-edged band would
/// reach. Shared by [_BevelBorder] (for `ElevatedButton`s) and
/// [_BevelPainter] (for plain `Container`s that aren't buttons).
Path _bevelBandPath(Rect rect, double radius, double bandWidth) {
  final outer = Path()..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(radius)));
  final innerRect = Rect.fromLTRB(
    rect.left,
    rect.top,
    rect.right - bandWidth,
    rect.bottom - bandWidth,
  );
  final inner = Path()..addRRect(RRect.fromRectAndRadius(innerRect, Radius.circular(radius)));
  return Path.combine(PathOperation.difference, outer, inner);
}

/// Paints the same bottom+right bezel band as [_BevelBorder], for widgets
/// (like `Container`-based tab buttons) that aren't `ElevatedButton`s and so
/// can't use the theme's shape. Draw as a `CustomPaint(foregroundPainter:)`
/// wrapping the already-decorated widget.
class _BevelPainter extends CustomPainter {
  const _BevelPainter({
    required this.borderRadius,
    this.color = const Color(0x40000000),
    this.width = 4,
  });

  final double borderRadius;
  final Color color;
  final double width;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final r = borderRadius < rect.shortestSide / 2 ? borderRadius : rect.shortestSide / 2;
    canvas.drawPath(_bevelBandPath(rect, r, width), Paint()..color = color..style = PaintingStyle.fill);
  }

  @override
  bool shouldRepaint(covariant _BevelPainter oldDelegate) =>
      oldDelegate.borderRadius != borderRadius ||
      oldDelegate.color != color ||
      oldDelegate.width != width;
}

/// Pill-shaped back button reused across sub-screens.
class _BackButton extends StatelessWidget {
  const _BackButton({
    required this.onPressed,
    this.foreground = Colors.black87,
    this.background = const Color(0x14000000),
  });

  final VoidCallback onPressed;
  final Color foreground;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background,
      borderRadius: BorderRadius.circular(24),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: _spaceLg, vertical: _spaceSm),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.arrow_back_rounded, color: foreground, size: 18),
              const SizedBox(width: _spaceSm),
              Text(
                'Geri',
                style: TextStyle(
                  color: foreground,
                  fontWeight: FontWeight.w700,
                  fontSize: _fontBody,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Circular icon button used for the two feature entry points on the home page.
class _HomeCircleButton extends StatelessWidget {
  const _HomeCircleButton({
    required this.color,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final Color color;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.35), width: 2),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.55),
                  blurRadius: 16,
                  spreadRadius: 1,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 26),
          ),
          const SizedBox(height: _spaceSm),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: _fontCaption,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// Home screen widget that bursts a cross-flare animation each time the
/// button next to it is pressed.
class _StarPulseWidget extends StatefulWidget {
  const _StarPulseWidget();

  @override
  State<_StarPulseWidget> createState() => _StarPulseWidgetState();
}

class _StarPulseWidgetState extends State<_StarPulseWidget> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _flareLength;
  late final Animation<double> _flareOpacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 650));

    // Cross-flare burst: a bright center point pops in, its
    // 4 arms shoot outward with a sharp, fast acceleration, then the arms
    // snap back in quickly while the center point lingers and fades gently.
    _flareLength = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.easeOutExpo)),
        weight: 25,
      ),
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 10),
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 0.0).chain(CurveTween(curve: Curves.easeIn)),
        weight: 25,
      ),
      TweenSequenceItem(tween: ConstantTween(0.0), weight: 40),
    ]).animate(_controller);
    _flareOpacity = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.easeOut)),
        weight: 10,
      ),
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 35),
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 0.0).chain(CurveTween(curve: Curves.easeOut)),
        weight: 55,
      ),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _pulse() {
    _controller.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (context, _) => CustomPaint(
            size: const Size(64, 64),
            painter: _CrossFlarePainter(
              lengthFrac: _flareLength.value,
              opacity: _flareOpacity.value,
            ),
          ),
        ),
        const SizedBox(width: _spaceMd),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: _kiremitColor,
            foregroundColor: Colors.white,
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(_spaceMd),
          ),
          onPressed: _pulse,
          child: const Icon(Icons.add, size: 20),
        ),
      ],
    );
  }
}

/// Draws a 4-point cross-flare: a bright core with sharp blades radiating
/// out along the up/right/down/left axes (plus thinner diagonal spikes for
/// sparkle), each fading from opaque white at the center to transparent at
/// its tip. [lengthFrac] scales how far the blades currently reach (0 =
/// collapsed to the core, 1 = fully extended); [opacity] fades the whole
/// flare in and out.
class _CrossFlarePainter extends CustomPainter {
  const _CrossFlarePainter({required this.lengthFrac, required this.opacity});

  final double lengthFrac;
  final double opacity;

  Path _blade(Offset center, double angle, double length, double width) {
    final dir = Offset(cos(angle), sin(angle));
    final perp = Offset(-dir.dy, dir.dx) * (width / 2);
    final tip = center + dir * length;
    return Path()
      ..moveTo(center.dx + perp.dx, center.dy + perp.dy)
      ..lineTo(tip.dx, tip.dy)
      ..lineTo(center.dx - perp.dx, center.dy - perp.dy)
      ..close();
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (opacity <= 0) return;
    final center = size.center(Offset.zero);
    final armLength = size.shortestSide * 0.62 * lengthFrac;
    final coreGrow = 0.5 + 0.5 * lengthFrac;

    if (armLength > 0) {
      final armWidth = size.shortestSide * 0.09 * (0.35 + 0.65 * lengthFrac);
      final glowShader = RadialGradient(
        colors: [Colors.white.withOpacity(0.9 * opacity), Colors.white.withOpacity(0.0)],
      ).createShader(Rect.fromCircle(center: center, radius: armLength));
      final bladePaint = Paint()..shader = glowShader;
      for (var i = 0; i < 4; i++) {
        canvas.drawPath(_blade(center, i * (pi / 2), armLength, armWidth), bladePaint);
      }
      final spikePaint = Paint()..color = Colors.white.withOpacity(0.45 * opacity);
      for (var i = 0; i < 4; i++) {
        canvas.drawPath(
          _blade(center, pi / 4 + i * (pi / 2), armLength * 0.42, armWidth * 0.4),
          spikePaint,
        );
      }
    }

    // soft glow plus a bright pinpoint at the very center
    canvas.drawCircle(
      center,
      size.shortestSide * 0.16 * coreGrow,
      Paint()
        ..color = Colors.white.withOpacity(0.35 * opacity)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );
    canvas.drawCircle(center, size.shortestSide * 0.05 * coreGrow, Paint()..color = Colors.white.withOpacity(0.95 * opacity));
  }

  @override
  bool shouldRepaint(covariant _CrossFlarePainter oldDelegate) =>
      oldDelegate.lengthFrac != lengthFrac || oldDelegate.opacity != opacity;
}

const List<Color> _colorScreenColors = [
  Colors.red,
  Colors.orange,
  Colors.yellow,
  Colors.green,
  Colors.blue,
  Colors.teal,
];

class RootPageView extends StatefulWidget {
  const RootPageView({super.key});

  @override
  State<RootPageView> createState() => _RootPageViewState();
}

class _RootPageViewState extends State<RootPageView> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  void _goToPage(int index) {
    final distance = (index - _currentIndex).abs().clamp(1, 6);
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 500 * distance),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) => _currentIndex = index,
        children: [
          HomePage(onColorSelected: _goToPage),
          for (final color in _colorScreenColors)
            ColorPage(color: color, onBack: () => _goToPage(0)),
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.onColorSelected});

  final ValueChanged<int> onColorSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _creamColor,
      child: Stack(
        children: [
          const Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 24.0, top: 24.0),
              child: _StarPulseWidget(),
            ),
          ),
          Align(
            alignment: const Alignment(1.0, 0.0),
            child: Padding(
              padding: const EdgeInsets.only(right: 24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _HomeCircleButton(
                    color: _kiremitColor,
                    icon: Icons.storefront_outlined,
                    label: 'Market',
                    onTap: () {
                      Navigator.of(context).push(_marketScreenRoute());
                    },
                  ),
                  const SizedBox(height: _spaceXl),
                  _HomeCircleButton(
                    color: Colors.purple,
                    icon: Icons.receipt_long_outlined,
                    label: 'Siparişler',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const OrdersScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: _spaceXl),
                  _HomeCircleButton(
                    color: Colors.teal,
                    icon: Icons.emoji_events_outlined,
                    label: 'Profil',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const ProfileScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: _spaceXl),
                  _HomeCircleButton(
                    color: Colors.indigo,
                    icon: Icons.coronavirus_outlined,
                    label: 'Hastalık',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const DiseaseScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    for (var i = 0; i < _colorScreenColors.length; i++)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: GestureDetector(
                          onTap: () => onColorSelected(i + 1),
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: _colorScreenColors[i],
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                              boxShadow: [
                                BoxShadow(
                                  color: _colorScreenColors[i].withOpacity(0.6),
                                  blurRadius: 8,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ColorPage extends StatelessWidget {
  const ColorPage({super.key, required this.color, required this.onBack});

  final Color color;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color, Color.lerp(color, Colors.black, 0.25)!],
        ),
      ),
      child: SafeArea(
        child: Stack(
          children: [
            if (color == Colors.orange) const Center(child: _MortarOrderPanel()),
            if (color == Colors.red) const Center(child: _ThermometerPanel()),
            if (color == Colors.green) const Center(child: _CapsuleFillingPanel()),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: _BackButton(
                  onPressed: onBack,
                  foreground: Colors.black87,
                  background: Colors.white.withOpacity(0.35),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Card shown on the red screen: hold the flame button to heat a
/// thermometer up, release to let it cool. Keeping the temperature inside
/// the ideal band for a few seconds straight succeeds.
class _ThermometerPanel extends StatefulWidget {
  const _ThermometerPanel();

  @override
  State<_ThermometerPanel> createState() => _ThermometerPanelState();
}

class _ThermometerPanelState extends State<_ThermometerPanel> with SingleTickerProviderStateMixin {
  static const double _minTemp = 0.0;
  static const double _maxTemp = 100.0;
  static const double _idealMin = 80.0;
  static const double _idealMax = 90.0;
  static const double _heatRatePerSecond = 22.0;
  static const double _coolRatePerSecond = 14.0;
  static const Duration _requiredSteady = Duration(seconds: 4);

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
      if (_isHolding) {
        _temperature = (_temperature + _heatRatePerSecond * dtSeconds).clamp(_minTemp, _maxTemp);
      } else {
        _temperature = (_temperature - _coolRatePerSecond * dtSeconds).clamp(_minTemp, _maxTemp);
      }
      final inRange = _temperature >= _idealMin && _temperature <= _idealMax;
      if (inRange) {
        _steadyElapsed += dt;
        if (_steadyElapsed >= _requiredSteady) {
          _success = true;
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

  static const double _coldToWarmTemp = 30.0;
  static const double _warmToHotTemp = 45.0;

  // Continuous blue → orange → red ramp driven by the actual temperature,
  // rather than a hard switch, so the liquid color eases through each band
  // instead of snapping the instant a threshold is crossed.
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
    if (_temperature < _idealMin) return 'Soğuk, basılı tutarak ısıt';
    if (_temperature > _idealMax) return 'Çok sıcak, bırakıp soğut';
    return 'İdeal aralıkta! Sabit tut...';
  }

  @override
  Widget build(BuildContext context) {
    final tempFrac = ((_temperature - _minTemp) / (_maxTemp - _minTemp)).clamp(0.0, 1.0);
    final idealMinFrac = (_idealMin - _minTemp) / (_maxTemp - _minTemp);
    final idealMaxFrac = (_idealMax - _minTemp) / (_maxTemp - _minTemp);
    final steadyFrac =
        (_steadyElapsed.inMilliseconds / _requiredSteady.inMilliseconds).clamp(0.0, 1.0);

    return Container(
      width: 260,
      padding: const EdgeInsets.all(_spaceXl),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.94),
        borderRadius: BorderRadius.circular(_radiusLg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Isı Ayarı',
            style: TextStyle(
              fontSize: _fontHeading,
              fontWeight: FontWeight.w800,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: _spaceMd),
          Text(
            '${_temperature.round()}°',
            style: TextStyle(
              fontSize: _fontHeading,
              fontWeight: FontWeight.w800,
              color: _mercuryColor(),
            ),
          ),
          const SizedBox(height: _spaceSm),
          SizedBox(
            width: 96,
            height: 210,
            child: CustomPaint(
              painter: _ThermometerPainter(
                value: tempFrac,
                idealMinFrac: idealMinFrac,
                idealMaxFrac: idealMaxFrac,
                idealMinLabel: '${_idealMin.round()}°',
                idealMaxLabel: '${_idealMax.round()}°',
                color: _mercuryColor(),
              ),
            ),
          ),
          const SizedBox(height: _spaceLg),
          if (!_success) ...[
            Text(
              _statusText(),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: _fontBody, color: Colors.black.withOpacity(0.65)),
            ),
            const SizedBox(height: _spaceMd),
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
            const SizedBox(height: _spaceLg),
            Listener(
              onPointerDown: (_) => setState(() => _isHolding = true),
              onPointerUp: (_) => setState(() => _isHolding = false),
              onPointerCancel: (_) => setState(() => _isHolding = false),
              child: Container(
                width: 100,
                height: 100,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withOpacity(_isHolding ? 0.6 : 0.35),
                      blurRadius: _isHolding ? 26 : 14,
                      spreadRadius: _isHolding ? 2 : 0,
                    ),
                  ],
                ),
                child: const Icon(Icons.local_fire_department, color: Colors.white, size: 40),
              ),
            ),
            const SizedBox(height: _spaceSm),
            Text(
              'Basılı tut: ısıt · bırak: soğut',
              style: TextStyle(fontSize: _fontCaption, color: Colors.black.withOpacity(0.5)),
            ),
          ] else ...[
            const Icon(Icons.check_circle, color: Colors.green, size: 40),
            const SizedBox(height: _spaceSm),
            Text(
              _statusText(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: _fontTitle,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: _spaceMd),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _kiremitColor,
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

class _ThermometerPainter extends CustomPainter {
  _ThermometerPainter({
    required this.value,
    required this.idealMinFrac,
    required this.idealMaxFrac,
    required this.idealMinLabel,
    required this.idealMaxLabel,
    required this.color,
  });

  final double value;
  final double idealMinFrac;
  final double idealMaxFrac;
  final String idealMinLabel;
  final String idealMaxLabel;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final bulbRadius = size.width * 0.28;
    final glassWidth = bulbRadius * 1.15;
    final channelWidth = glassWidth * 0.42;
    final tubeTop = bulbRadius * 0.7;
    final centerX = bulbRadius + 10; // nudged right within the canvas
    final bulbCenter = Offset(centerX, size.height - bulbRadius - 4);
    final tubeBottom = bulbCenter.dy - bulbRadius * 0.35;

    final glassRect = Rect.fromLTWH(centerX - glassWidth / 2, tubeTop, glassWidth, tubeBottom - tubeTop);
    final glassRRect = RRect.fromRectAndRadius(glassRect, Radius.circular(glassWidth / 2));
    final channelRect = Rect.fromLTWH(
      centerX - channelWidth / 2,
      tubeTop + 5,
      channelWidth,
      tubeBottom - tubeTop - 5,
    );
    final channelRRect = RRect.fromRectAndRadius(channelRect, Radius.circular(channelWidth / 2));

    // The tube (rounded rect) and bulb (circle) overlap at the neck; union
    // them into one silhouette so the shadow/fill/outline are seamless
    // instead of showing a double-drawn seam where the two shapes meet.
    final glassPath = Path.combine(
      PathOperation.union,
      Path()..addRRect(glassRRect),
      Path()..addOval(Rect.fromCircle(center: bulbCenter, radius: bulbRadius)),
    );

    // soft drop shadow beneath the glass body
    canvas.drawPath(
      glassPath.shift(const Offset(0, 3)),
      Paint()
        ..color = Colors.black.withOpacity(0.12)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
    );

    // glass body
    canvas.drawPath(glassPath, Paint()..color = Colors.white);

    // ideal-range band across the glass
    final bandTop = channelRect.top + channelRect.height * (1 - idealMaxFrac);
    final bandBottom = channelRect.top + channelRect.height * (1 - idealMinFrac);
    canvas.drawRect(
      Rect.fromLTRB(glassRect.left, bandTop, glassRect.right, bandBottom),
      Paint()..color = Colors.green.withOpacity(0.16),
    );
    final bandLinePaint = Paint()
      ..color = Colors.green.withOpacity(0.6)
      ..strokeWidth = 1.2;
    canvas.drawLine(Offset(glassRect.left, bandTop), Offset(glassRect.right, bandTop), bandLinePaint);
    canvas.drawLine(Offset(glassRect.left, bandBottom), Offset(glassRect.right, bandBottom), bandLinePaint);

    // empty mercury channel
    canvas.drawRRect(channelRRect, Paint()..color = const Color(0xFFE7E7EC));

    // tick marks along the right edge
    final tickPaint = Paint()
      ..color = Colors.black38
      ..strokeWidth = 1.2;
    for (var t = 0; t <= 10; t++) {
      final frac = t / 10;
      final y = tubeBottom - (tubeBottom - tubeTop) * frac;
      final isMajor = t % 5 == 0;
      final tickLength = isMajor ? 7.0 : 3.5;
      canvas.drawLine(
        Offset(glassRect.right, y),
        Offset(glassRect.right + tickLength, y),
        tickPaint,
      );
    }

    // mercury fill: union the risen portion of the channel with the bulb
    // into one shape, so the mercury tapers smoothly from tube into bulb
    // instead of showing a seam where the two separately-drawn shapes met.
    final fillTop = channelRect.top + channelRect.height * (1 - value);
    final fillRect = Rect.fromLTRB(channelRect.left, fillTop, channelRect.right, channelRect.bottom);
    final bulbFillRadius = bulbRadius * 0.72;
    final bulbFillCircle = Rect.fromCircle(center: bulbCenter, radius: bulbFillRadius);
    final channelFillPath = Path.combine(
      PathOperation.intersect,
      Path()..addRRect(channelRRect),
      Path()..addRect(fillRect),
    );
    final mercuryPath = Path.combine(
      PathOperation.union,
      channelFillPath,
      Path()..addOval(bulbFillCircle),
    );
    final mercuryBounds = Rect.fromLTRB(
      channelRect.left,
      fillTop,
      channelRect.right,
      bulbFillCircle.bottom,
    );
    canvas.drawPath(
      mercuryPath,
      Paint()
        ..shader = LinearGradient(
          colors: [color.withOpacity(0.85), color, color.withOpacity(0.85)],
        ).createShader(mercuryBounds),
    );

    // glossy highlight on the bulb, as a soft radial sheen rather than a
    // flat dot, to read more like a lit sphere
    canvas.drawCircle(
      bulbCenter,
      bulbFillRadius,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.35, -0.35),
          radius: 0.9,
          colors: [Colors.white.withOpacity(0.45), Colors.white.withOpacity(0.0)],
          stops: const [0.0, 0.7],
        ).createShader(bulbFillCircle),
    );

    // glass reflection stripe running down the tube
    final highlightRect = Rect.fromLTWH(
      glassRect.left + glassRect.width * 0.16,
      tubeTop + 4,
      glassRect.width * 0.16,
      glassRect.height - 8,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(highlightRect, Radius.circular(highlightRect.width / 2)),
      Paint()..color = Colors.white.withOpacity(0.55),
    );

    // glass outline — one continuous stroke around the unioned silhouette
    canvas.drawPath(
      glassPath,
      Paint()
        ..color = Colors.black38
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    // degree labels for the ideal band
    _drawLabel(canvas, idealMaxLabel, Offset(glassRect.right + 10, bandTop));
    _drawLabel(canvas, idealMinLabel, Offset(glassRect.right + 10, bandBottom));
  }

  void _drawLabel(Canvas canvas, String text, Offset anchor) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.black54),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(canvas, Offset(anchor.dx, anchor.dy - painter.height / 2));
  }

  @override
  bool shouldRepaint(covariant _ThermometerPainter oldDelegate) =>
      oldDelegate.value != value ||
      oldDelegate.idealMinFrac != idealMinFrac ||
      oldDelegate.idealMaxFrac != idealMaxFrac ||
      oldDelegate.color != color;
}

/// Card shown on the green screen: a timing/rhythm minigame. Capsules pass
/// one at a time along a track; the player must tap "Bastır" right as the
/// capsule crosses the green hit zone. Better timing fills more capsules
/// without error.
class _CapsuleFillingPanel extends StatefulWidget {
  const _CapsuleFillingPanel();

  @override
  State<_CapsuleFillingPanel> createState() => _CapsuleFillingPanelState();
}

class _CapsuleFillingPanelState extends State<_CapsuleFillingPanel>
    with SingleTickerProviderStateMixin {
  static const int _totalCapsules = 10;
  static const double _hitZoneMin = 0.25;
  static const double _hitZoneMax = 0.85;
  static const double _perfectWindow = 0.035;
  static const double _goodWindow = 0.09;
  static const double _missAutoWindow = 0.14;
  static const Duration _baseTravelDuration = Duration(milliseconds: 1500);
  static const double _speedGrowthPerCapsule = 1.05;
  static const Duration _spawnGap = Duration(milliseconds: 450);
  static const int _requiredHits = 7;

  final Random _random = Random();
  late final Ticker _ticker;
  Duration _lastElapsed = Duration.zero;
  Duration _gapElapsed = Duration.zero;

  double _progress = 0.0;
  double _hitZoneFrac = 0.72;
  double _speedMultiplier = 1.0;
  bool _capsuleActive = false;
  bool _capsuleResolved = false;
  int _capsulesDone = 0;
  int _hitCount = 0;
  double _scoreSum = 0.0;
  String? _lastResult;
  Color _lastResultColor = Colors.black54;
  bool _finished = false;
  bool _success = false;

  @override
  void initState() {
    super.initState();
    _spawnNext();
    _ticker = createTicker(_onTick)..start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void _spawnNext() {
    _progress = 0.0;
    _hitZoneFrac = _hitZoneMin + _random.nextDouble() * (_hitZoneMax - _hitZoneMin);
    _speedMultiplier = pow(_speedGrowthPerCapsule, _capsulesDone).toDouble();
    _capsuleActive = true;
    _capsuleResolved = false;
    _lastResult = null;
  }

  void _resolveCapsule(String label, double score, Color color) {
    _capsuleResolved = true;
    _capsuleActive = false;
    _capsulesDone += 1;
    _scoreSum += score;
    if (score > 0) _hitCount += 1;
    _lastResult = label;
    _lastResultColor = color;
    _gapElapsed = Duration.zero;
    if (_capsulesDone >= _totalCapsules) {
      _finished = true;
      _success = _hitCount >= _requiredHits;
    }
  }

  void _onTick(Duration elapsed) {
    final dt = elapsed - _lastElapsed;
    _lastElapsed = elapsed;
    if (_finished) return;
    setState(() {
      if (_capsuleActive) {
        _progress += (dt.inMicroseconds / _baseTravelDuration.inMicroseconds) * _speedMultiplier;
        if (_progress - _hitZoneFrac > _missAutoWindow || _progress >= 1.0) {
          _resolveCapsule('Kaçırdın', 0.0, Colors.redAccent);
        }
      } else {
        _gapElapsed += dt;
        if (_gapElapsed >= _spawnGap) {
          _spawnNext();
        }
      }
    });
  }

  void _onPress() {
    if (_finished || !_capsuleActive || _capsuleResolved) return;
    final distance = (_progress - _hitZoneFrac).abs();
    String label;
    double score;
    Color color;
    if (distance <= _perfectWindow) {
      label = 'Mükemmel';
      score = 1.0;
      color = Colors.green;
    } else if (distance <= _goodWindow) {
      label = 'İyi';
      score = 0.5;
      color = Colors.orange;
    } else {
      label = 'Kaçırdın';
      score = 0.0;
      color = Colors.redAccent;
    }
    setState(() => _resolveCapsule(label, score, color));
  }

  void _retry() {
    setState(() {
      _capsulesDone = 0;
      _hitCount = 0;
      _scoreSum = 0.0;
      _finished = false;
      _success = false;
      _gapElapsed = Duration.zero;
      _spawnNext();
    });
  }

  Widget _buildCapsuleIcon() {
    return SizedBox(
      width: 60,
      height: 60,
      child: Image.asset('assets/images/Capsule.webp', fit: BoxFit.contain),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hitFraction = (_hitCount / _totalCapsules).clamp(0.0, 1.0);
    final requiredFraction = _requiredHits / _totalCapsules;

    return Container(
      width: 300,
      padding: const EdgeInsets.all(_spaceXl),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.94),
        borderRadius: BorderRadius.circular(_radiusLg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Kapsül Doldurma',
            style: TextStyle(
              fontSize: _fontHeading,
              fontWeight: FontWeight.w800,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: _spaceSm),
          if (!_finished) ...[
            Text(
              'Kapsül hedef bölgeye gelince "Bastır"a dokun',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: _fontCaption, color: Colors.black.withOpacity(0.6)),
            ),
            const SizedBox(height: _spaceLg),
            SizedBox(
              height: 60,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final trackWidth = constraints.maxWidth;
                  final hitCenterX = trackWidth * _hitZoneFrac;
                  final hitBandWidth = trackWidth * _goodWindow * 2;
                  final capsuleX = (trackWidth * _progress).clamp(0.0, trackWidth) - 30;
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        height: 46,
                        margin: const EdgeInsets.symmetric(vertical: 7),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE7E7EC),
                          borderRadius: BorderRadius.circular(23),
                        ),
                      ),
                      Positioned(
                        left: hitCenterX - hitBandWidth / 2,
                        top: 7,
                        bottom: 7,
                        width: hitBandWidth,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.28),
                            border: Border.symmetric(
                              vertical: BorderSide(color: Colors.green.withOpacity(0.7), width: 1.5),
                            ),
                          ),
                        ),
                      ),
                      if (_capsuleActive)
                        Positioned(
                          left: capsuleX,
                          top: 0,
                          child: _buildCapsuleIcon(),
                        ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: _spaceMd),
            Text(
              _lastResult ?? 'Hazır ol...',
              style: TextStyle(
                fontSize: _fontBody,
                fontWeight: FontWeight.w700,
                color: _lastResult == null ? Colors.black.withOpacity(0.4) : _lastResultColor,
              ),
            ),
            const SizedBox(height: _spaceMd),
            SizedBox(
              height: 28,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final markerX = constraints.maxWidth * requiredFraction;
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(9),
                          child: SizedBox(
                            height: 18,
                            child: LinearProgressIndicator(
                              value: hitFraction,
                              backgroundColor: Colors.black12,
                              valueColor: const AlwaysStoppedAnimation(Colors.green),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: markerX - 1,
                        bottom: 3,
                        child: Container(
                          width: 2,
                          height: 12,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                      ),
                      Positioned(
                        left: markerX - 11,
                        top: -2,
                        child: Icon(Icons.arrow_drop_down, size: 22, color: _kiremitColor),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: _spaceXs),
            Text(
              'Kapsül: $_capsulesDone / $_totalCapsules',
              style: TextStyle(fontSize: _fontCaption, color: Colors.black.withOpacity(0.6)),
            ),
            const SizedBox(height: _spaceLg),
            GestureDetector(
              onTap: _onPress,
              child: Container(
                width: 100,
                height: 100,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: Colors.green.withOpacity(0.4), blurRadius: 16, spreadRadius: 1),
                  ],
                ),
                child: const Icon(Icons.touch_app, color: Colors.white, size: 40),
              ),
            ),
          ] else ...[
            Icon(
              _success ? Icons.check_circle : Icons.error_outline,
              color: _success ? Colors.green : Colors.orange,
              size: 40,
            ),
            const SizedBox(height: _spaceSm),
            Text(
              _success ? 'Kapsüller başarıyla dolduruldu!' : 'Yeterince kapsül dolmadı.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: _fontTitle,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: _spaceXs),
            Text(
              'İsabet: $_hitCount / $_totalCapsules (gerekli: $_requiredHits)',
              style: TextStyle(fontSize: _fontBody, color: Colors.black.withOpacity(0.6)),
            ),
            const SizedBox(height: _spaceMd),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _kiremitColor,
                  foregroundColor: Colors.white,
                ),
                onPressed: _retry,
                child: const Text('Yeni Parti'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

enum _MortarState { idle, preparing, done }

/// Card shown on the orange screen: prepare a magistral order in a mortar.
/// Tapping "Siparişi Hazırla" starts a 10-minute shimmering timer; a button
/// next to the bar opens a mouse-spinning minigame that, on success, drops
/// the remaining time down to 10 seconds.
class _MortarOrderPanel extends StatefulWidget {
  const _MortarOrderPanel();

  @override
  State<_MortarOrderPanel> createState() => _MortarOrderPanelState();
}

class _MortarOrderPanelState extends State<_MortarOrderPanel>
    with SingleTickerProviderStateMixin {
  static const Duration _prepareDuration = Duration(minutes: 10);
  static const Duration _minigameReward = Duration(seconds: 10);

  _MortarState _state = _MortarState.idle;
  late final AnimationController _shimmerController;
  Timer? _ticker;
  DateTime? _startTime;
  Duration _totalDuration = _prepareDuration;
  Duration _remaining = _prepareDuration;
  double _progress = 0.0;
  bool _boosted = false;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _shimmerController.dispose();
    super.dispose();
  }

  void _startPreparing() {
    setState(() {
      _state = _MortarState.preparing;
      _startTime = DateTime.now();
      _totalDuration = _prepareDuration;
      _remaining = _prepareDuration;
      _progress = 0.0;
      _boosted = false;
    });
    _shimmerController.repeat();
    _ticker = Timer.periodic(const Duration(milliseconds: 200), (_) => _tick());
  }

  void _tick() {
    final startTime = _startTime;
    if (startTime == null) return;
    final elapsed = DateTime.now().difference(startTime);
    final remaining = _totalDuration - elapsed;
    if (remaining <= Duration.zero) {
      _ticker?.cancel();
      _shimmerController.stop();
      setState(() {
        _state = _MortarState.done;
        _progress = 1.0;
        _remaining = Duration.zero;
      });
    } else {
      setState(() {
        _progress = (elapsed.inMilliseconds / _totalDuration.inMilliseconds).clamp(0.0, 1.0);
        _remaining = remaining;
      });
    }
  }

  Future<void> _openMinigame() async {
    final success = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        fullscreenDialog: true,
        builder: (_) => const _MashButtonMinigame(),
      ),
    );
    final startTime = _startTime;
    if (success == true && startTime != null && _state == _MortarState.preparing) {
      final elapsed = DateTime.now().difference(startTime);
      setState(() {
        _totalDuration = elapsed + _minigameReward;
        _boosted = true;
      });
    }
  }

  void _resetToIdle() {
    setState(() {
      _state = _MortarState.idle;
      _startTime = null;
      _totalDuration = _prepareDuration;
      _remaining = _prepareDuration;
      _progress = 0.0;
      _boosted = false;
    });
  }

  String _formatRemaining(Duration d) {
    final minutes = d.inMinutes;
    final seconds = d.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(_spaceXl),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.94),
        borderRadius: BorderRadius.circular(_radiusLg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipOval(
            child: SizedBox(
              width: 130,
              height: 130,
              child: Image.asset('assets/images/Havan_normal.webp', fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: _spaceLg),
          const Text(
            'Majistral Hazırlama',
            style: TextStyle(
              fontSize: _fontHeading,
              fontWeight: FontWeight.w800,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: _spaceMd),
          if (_state == _MortarState.idle) ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _kiremitColor,
                  foregroundColor: Colors.white,
                ),
                onPressed: _startPreparing,
                child: const Text('Siparişi Hazırla'),
              ),
            ),
            const SizedBox(height: _spaceSm),
            Text(
              '10 dakikada hazırlanacak',
              style: TextStyle(fontSize: _fontCaption, color: Colors.black.withOpacity(0.6)),
            ),
          ] else if (_state == _MortarState.preparing) ...[
            Row(
              children: [
                Expanded(child: SizedBox(height: 18, child: _buildProgressBar())),
                const SizedBox(width: _spaceSm),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: _spaceMd, vertical: _spaceSm),
                  ),
                  onPressed: _openMinigame,
                  child: const Icon(Icons.bolt, size: 18),
                ),
              ],
            ),
            const SizedBox(height: _spaceSm),
            Text(
              'Kalan süre: ${_formatRemaining(_remaining)}',
              style: TextStyle(fontSize: _fontCaption, color: Colors.black.withOpacity(0.6)),
            ),
          ] else ...[
            const Icon(Icons.check_circle, color: Colors.green, size: 40),
            const SizedBox(height: _spaceSm),
            const Text(
              'Sipariş hazır!',
              style: TextStyle(
                fontSize: _fontTitle,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: _spaceMd),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _kiremitColor,
                  foregroundColor: Colors.white,
                ),
                onPressed: _resetToIdle,
                child: const Text('Yeni Sipariş'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    final barColor = _boosted ? Colors.green : Colors.orange;
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.15),
        borderRadius: BorderRadius.circular(9),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(9),
        child: AnimatedBuilder(
          animation: Listenable.merge([_shimmerController]),
          builder: (context, child) {
            return ShaderMask(
              blendMode: BlendMode.srcATop,
              shaderCallback: (bounds) {
                final t = -0.5 + _shimmerController.value * 2.0;
                return LinearGradient(
                  colors: [
                    barColor,
                    barColor,
                    Colors.white.withOpacity(0.35),
                    barColor,
                    barColor,
                  ],
                  stops: [
                    (t - 0.25).clamp(0.0, 1.0),
                    (t - 0.12).clamp(0.0, 1.0),
                    t.clamp(0.0, 1.0),
                    (t + 0.12).clamp(0.0, 1.0),
                    (t + 0.25).clamp(0.0, 1.0),
                  ],
                  begin: const Alignment(-1.0, -1.0),
                  end: const Alignment(1.0, 1.0),
                ).createShader(bounds);
              },
              child: LinearProgressIndicator(
                value: _progress,
                backgroundColor: Colors.transparent,
                valueColor: AlwaysStoppedAnimation(barColor),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Minigame: tap the button as fast as possible to fill the bar. The bar
/// slowly drains on its own whenever the player isn't tapping. Filling it
/// all the way succeeds and pops `true`.
class _MashButtonMinigame extends StatefulWidget {
  const _MashButtonMinigame();

  @override
  State<_MashButtonMinigame> createState() => _MashButtonMinigameState();
}

class _MashButtonMinigameState extends State<_MashButtonMinigame> {
  static const double _tapIncrement = 0.09;
  static const double _decayPerTick = 0.02;
  static const Duration _tickInterval = Duration(milliseconds: 100);

  double _progress = 0.0;
  bool _finished = false;
  Timer? _decayTimer;

  @override
  void initState() {
    super.initState();
    _decayTimer = Timer.periodic(_tickInterval, (_) => _decay());
  }

  @override
  void dispose() {
    _decayTimer?.cancel();
    super.dispose();
  }

  void _decay() {
    if (_finished || _progress <= 0) return;
    setState(() {
      _progress = (_progress - _decayPerTick).clamp(0.0, 1.0);
    });
  }

  void _onTap() {
    if (_finished) return;
    setState(() {
      _progress = (_progress + _tapIncrement).clamp(0.0, 1.0);
    });
    if (_progress >= 1.0) {
      _finished = true;
      _decayTimer?.cancel();
      Future.microtask(() {
        if (mounted) Navigator.of(context).pop(true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black87,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Hızlıca Bas!',
              style: TextStyle(
                fontSize: _fontHeading,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: _spaceMd),
            SizedBox(
              width: 240,
              height: 22,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(11),
                child: LinearProgressIndicator(
                  value: _progress,
                  backgroundColor: Colors.white24,
                  valueColor: const AlwaysStoppedAnimation(Colors.orangeAccent),
                ),
              ),
            ),
            const SizedBox(height: _spaceXl),
            GestureDetector(
              onTap: _onTap,
              child: Container(
                width: 140,
                height: 140,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.5),
                      blurRadius: 24,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(Icons.touch_app, color: Colors.white, size: 48),
              ),
            ),
            const SizedBox(height: _spaceLg),
            const Text(
              'Basmayı bırakırsan çubuk yavaşça boşalır',
              style: TextStyle(color: Colors.white70, fontSize: _fontBody),
            ),
            const SizedBox(height: _spaceXl),
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Vazgeç', style: TextStyle(color: Colors.white54)),
            ),
          ],
        ),
      ),
    );
  }
}

const List<_ShopItemData> _activeIngredients = [
  _ShopItemData(
    name: 'Salisilik Asit',
    description: 'Keratolitik etki, sedef ve egzama tedavisinde kullanılır',
    icon: Icons.science_outlined,
    color: Color(0xFF5D4037),
    buttonLabel: 'Satın Al',
    price: 150,
  ),
  _ShopItemData(
    name: 'Mentol',
    description: 'Soğutucu ve kaşıntı giderici etki sağlar',
    icon: Icons.ac_unit,
    color: Color(0xFF00ACC1),
    buttonLabel: 'Satın Al',
    price: 100,
  ),
  _ShopItemData(
    name: 'Çinko Oksit',
    description: 'Cilt koruyucu ve kurutucu bariyer oluşturur',
    icon: Icons.shield_outlined,
    color: Color(0xFF757575),
    buttonLabel: 'Satın Al',
    price: 120,
  ),
  _ShopItemData(
    name: 'Borik Asit',
    description: 'Antifungal ve hafif antiseptik etkilidir',
    icon: Icons.bug_report_outlined,
    color: Color(0xFF6D4C41),
    buttonLabel: 'Satın Al',
    price: 130,
  ),
  _ShopItemData(
    name: 'Hidrokortizon',
    description: 'Anti-inflamatuar steroid, kaşıntı ve iltihabı azaltır',
    icon: Icons.healing_outlined,
    color: Color(0xFFAD1457),
    buttonLabel: 'Satın Al',
    price: 250,
  ),
  _ShopItemData(
    name: 'Lidokain',
    description: 'Lokal anestezik, bölgesel uyuşturma sağlar',
    icon: Icons.vaccines_outlined,
    color: Color(0xFF1565C0),
    buttonLabel: 'Satın Al',
    price: 300,
  ),
  _ShopItemData(
    name: 'Klotrimazol',
    description: 'Geniş spektrumlu antifungal etkin madde',
    icon: Icons.coronavirus_outlined,
    color: Color(0xFF00838F),
    buttonLabel: 'Satın Al',
    price: 220,
  ),
  _ShopItemData(
    name: 'Benzoil Peroksit',
    description: 'Akne tedavisinde antibakteriyel etki gösterir',
    icon: Icons.face_retouching_natural_outlined,
    color: Color(0xFFEF6C00),
    buttonLabel: 'Satın Al',
    price: 180,
  ),
  _ShopItemData(
    name: 'Üre',
    description: 'Nemlendirici ve hafif keratolitik etki sağlar',
    icon: Icons.water_drop_outlined,
    color: Color(0xFF7CB342),
    buttonLabel: 'Satın Al',
    price: 90,
  ),
  _ShopItemData(
    name: 'Kamfor',
    description: 'Analjezik ve rahatlatıcı etki gösterir',
    icon: Icons.spa_outlined,
    color: Color(0xFF8E24AA),
    buttonLabel: 'Satın Al',
    price: 110,
  ),
];

Route<void> _marketScreenRoute() {
  return PageRouteBuilder<void>(
    transitionDuration: const Duration(milliseconds: 550),
    reverseTransitionDuration: const Duration(milliseconds: 350),
    pageBuilder: (context, animation, secondaryAnimation) => const MarketScreen(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
      return FadeTransition(
        opacity: curved,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.55, end: 1.0).animate(curved),
          child: child,
        ),
      );
    },
  );
}

enum _MarketTab { hizlandirmalar, cihazlarVeAletler, yeniVakalar, etkenMaddeler }

extension on _MarketTab {
  String get label {
    switch (this) {
      case _MarketTab.hizlandirmalar:
        return 'Hızlandırmalar';
      case _MarketTab.cihazlarVeAletler:
        return 'Cihazlar ve Aletler';
      case _MarketTab.yeniVakalar:
        return 'Yeni Vakalar';
      case _MarketTab.etkenMaddeler:
        return 'Etken maddeler';
    }
  }

  Color get color {
    switch (this) {
      case _MarketTab.hizlandirmalar:
        return const Color(0xFF14555A); // Derin Deniz Mavisi/Teal
      case _MarketTab.cihazlarVeAletler:
        return const Color(0xFF96682E); // Bronz/Ocra
      case _MarketTab.yeniVakalar:
        return const Color(0xFF6E2B3E); // Koyu Bordo
      case _MarketTab.etkenMaddeler:
        return const Color(0xFF355E3B); // Av Yeşili
    }
  }
}

class MarketScreen extends StatefulWidget {
  const MarketScreen({super.key});

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  static const _contentColor = _creamColor;

  _MarketTab _selectedTab = _MarketTab.hizlandirmalar;
  late final List<int> _acceleratorInventory;
  late final List<int> _activeIngredientInventory;

  @override
  void initState() {
    super.initState();
    final random = Random();
    _acceleratorInventory = List.generate(
      _accelerators.length,
      (_) => random.nextInt(20) + 1,
    );
    _activeIngredientInventory = List.generate(
      _activeIngredients.length,
      (_) => random.nextInt(20) + 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _creamColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(_spaceSm),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(_radiusLg),
              border: Border.all(color: const Color(0xFF3A3A3A), width: 7),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.7),
                  blurRadius: 30,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(13.0),
              child: Container(
                color: _contentColor,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
                      child: Row(
                        children: [
                          _BackButton(onPressed: () => Navigator.of(context).pop()),
                          const SizedBox(width: 12),
                          const Text(
                            'Market',
                            style: TextStyle(
                              fontSize: _fontHeading,
                              fontWeight: FontWeight.w800,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: _spaceMd),
                    Row(
                      children: [
                        for (final tab in _MarketTab.values)
                          Expanded(
                            child: _MarketTabButton(
                              label: tab.label,
                              color: tab.color,
                              selected: _selectedTab == tab,
                              onTap: () => setState(() => _selectedTab = tab),
                            ),
                          ),
                      ],
                    ),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        color: _contentColor,
                        child: _buildTabContent(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTab) {
      case _MarketTab.hizlandirmalar:
        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 20.0),
          itemCount: _accelerators.length,
          itemBuilder: (context, index) {
            return _ShopItemTile(
              data: _accelerators[index],
              inventory: _acceleratorInventory[index],
            );
          },
        );
      case _MarketTab.etkenMaddeler:
        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 20.0),
          itemCount: _activeIngredients.length,
          itemBuilder: (context, index) {
            return _ShopItemTile(
              data: _activeIngredients[index],
              inventory: _activeIngredientInventory[index],
            );
          },
        );
      case _MarketTab.cihazlarVeAletler:
        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 20.0),
          itemCount: _deviceGroups.length,
          itemBuilder: (context, index) {
            return _DeviceGroupSection(group: _deviceGroups[index]);
          },
        );
      case _MarketTab.yeniVakalar:
        return Center(
          child: Text(
            'Yakında eklenecek',
            style: TextStyle(
              color: Colors.black.withOpacity(0.6),
              fontSize: _fontTitle,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
    }
  }
}

class _ShopItemData {
  const _ShopItemData({
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    this.buttonLabel = 'Kullan',
    this.cardColor,
    this.imagePath,
    this.price = 0,
  });

  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final String buttonLabel;
  final Color? cardColor;
  final String? imagePath;
  final int price;
}

const List<_ShopItemData> _accelerators = [
  _ShopItemData(
    name: 'Mekanik Kol',
    description: 'Herhangi bir hazırlama sürecini 1 saat hızlandır',
    icon: Icons.precision_manufacturing_outlined,
    color: Color(0xFFEF6C00),
  ),
  _ShopItemData(
    name: 'Kristal Toz',
    description: 'Herhangi bir hazırlama sürecini 2 saat hızlandır',
    icon: Icons.auto_awesome_outlined,
    color: Color(0xFF8E24AA),
  ),
  _ShopItemData(
    name: 'Vakumlu Filtre',
    description: 'Herhangi bir hazırlama sürecini 4 saat hızlandır',
    icon: Icons.filter_alt_outlined,
    color: Color(0xFF00838F),
  ),
  _ShopItemData(
    name: 'Reklam İzle',
    description: 'Herhangi bir hazırlama sürecini 30 dakika hızlandır',
    icon: Icons.play_circle_outline,
    color: Color(0xFF2E7D32),
    buttonLabel: 'İzle - 0/3',
    cardColor: Color(0xFF2E7D32),
  ),
];

const Color _rustyColor = Color(0xFF8D6E52);
const Color _goodConditionColor = Color(0xFF607D8B);

class _DeviceGroup {
  const _DeviceGroup({required this.name, required this.tiers});

  final String name;
  final List<_ShopItemData> tiers;
}

const List<_DeviceGroup> _deviceGroups = [
  _DeviceGroup(
    name: 'Hassas Terazi',
    tiers: [
      _ShopItemData(
        name: 'Paslı',
        description: 'Tartım hassasiyeti düşük, hazırlama sürecini 15 dakika hızlandırır',
        icon: Icons.scale_outlined,
        color: _rustyColor,
        price: 200,
      ),
      _ShopItemData(
        name: 'İyi durumda',
        description: 'Tartım hassasiyeti iyi, hazırlama sürecini 45 dakika hızlandırır',
        icon: Icons.scale_outlined,
        color: _goodConditionColor,
        price: 1000,
      ),
      _ShopItemData(
        name: 'En gelişmiş',
        description: 'Dijital hassasiyet, hazırlama sürecini 1.5 saat hızlandırır',
        icon: Icons.scale_outlined,
        color: Color(0xFF00ACC1),
        price: 3000,
      ),
    ],
  ),
  _DeviceGroup(
    name: 'Unguator',
    tiers: [
      _ShopItemData(
        name: 'Paslı',
        description: 'Pomat karışımı yavaş, hazırlama sürecini 20 dakika hızlandırır',
        icon: Icons.blender_outlined,
        color: _rustyColor,
        price: 200,
      ),
      _ShopItemData(
        name: 'İyi durumda',
        description: 'Pomat karışımı dengeli, hazırlama sürecini 1 saat hızlandırır',
        icon: Icons.blender_outlined,
        color: _goodConditionColor,
        price: 1000,
      ),
      _ShopItemData(
        name: 'En gelişmiş',
        description: 'Otomatik pomat karışımı, hazırlama sürecini 2 saat hızlandırır',
        icon: Icons.blender_outlined,
        color: Color(0xFF7B1FA2),
        price: 3000,
      ),
    ],
  ),
  _DeviceGroup(
    name: 'Havan ve Havaneli',
    tiers: [
      _ShopItemData(
        name: 'Paslı',
        description: 'Öğütme verimi düşük, hazırlama sürecini 10 dakika hızlandırır',
        icon: Icons.grain_outlined,
        color: _rustyColor,
        price: 200,
        imagePath: 'assets/images/havan_old.webp',
      ),
      _ShopItemData(
        name: 'İyi durumda',
        description: 'Öğütme verimi iyi, hazırlama sürecini 30 dakika hızlandırır',
        icon: Icons.grain_outlined,
        color: _goodConditionColor,
        price: 1000,
        imagePath: 'assets/images/Havan_normal.webp',
      ),
      _ShopItemData(
        name: 'En gelişmiş',
        description: 'Hassas partikül öğütme, hazırlama sürecini 1 saat hızlandırır',
        icon: Icons.grain_outlined,
        color: Color(0xFFF9A825),
        imagePath: 'assets/images/Havan_Modern.jpg',
        price: 3000,
      ),
    ],
  ),
  _DeviceGroup(
    name: 'Kapsül Doldurma Makinesi',
    tiers: [
      _ShopItemData(
        name: 'Paslı',
        description: 'Doldurma hızı düşük, hazırlama sürecini 20 dakika hızlandırır',
        icon: Icons.medication_outlined,
        color: _rustyColor,
        price: 200,
      ),
      _ShopItemData(
        name: 'İyi durumda',
        description: 'Doldurma hızı iyi, hazırlama sürecini 1 saat hızlandırır',
        icon: Icons.medication_outlined,
        color: _goodConditionColor,
        price: 1000,
      ),
      _ShopItemData(
        name: 'En gelişmiş',
        description: 'Otomatik seri doldurma, hazırlama sürecini 2.5 saat hızlandırır',
        icon: Icons.medication_outlined,
        color: Color(0xFF2E7D32),
        price: 3000,
      ),
    ],
  ),
  _DeviceGroup(
    name: 'Laminer Kabin',
    tiers: [
      _ShopItemData(
        name: 'Paslı',
        description: 'Hava akışı zayıf, hazırlama sürecini 30 dakika hızlandırır',
        icon: Icons.air_outlined,
        color: _rustyColor,
        price: 200,
      ),
      _ShopItemData(
        name: 'İyi durumda',
        description: 'Hava akışı stabil, hazırlama sürecini 1.5 saat hızlandırır',
        icon: Icons.air_outlined,
        color: _goodConditionColor,
        price: 1000,
      ),
      _ShopItemData(
        name: 'En gelişmiş',
        description: 'ISO 5 steril hava akışı, hazırlama sürecini 3 saat hızlandırır',
        icon: Icons.air_outlined,
        color: Color(0xFF1565C0),
        price: 3000,
      ),
    ],
  ),
  _DeviceGroup(
    name: 'Otoklav',
    tiers: [
      _ShopItemData(
        name: 'Paslı',
        description: 'Sterilizasyon yavaş, hazırlama sürecini 15 dakika hızlandırır',
        icon: Icons.thermostat_outlined,
        color: _rustyColor,
        price: 200,
      ),
      _ShopItemData(
        name: 'İyi durumda',
        description: 'Sterilizasyon dengeli, hazırlama sürecini 45 dakika hızlandırır',
        icon: Icons.thermostat_outlined,
        color: _goodConditionColor,
        price: 1000,
      ),
      _ShopItemData(
        name: 'En gelişmiş',
        description: 'Hızlı ve tam sterilizasyon, hazırlama sürecini 2 saat hızlandırır',
        icon: Icons.thermostat_outlined,
        color: Color(0xFFC62828),
        price: 3000,
      ),
    ],
  ),
];

class _DeviceGroupSection extends StatelessWidget {
  const _DeviceGroupSection({required this.group});

  final _DeviceGroup group;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: _spaceXl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: double.infinity,
            child: Text(
              group.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: _fontHeading,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: _spaceMd),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final tier in group.tiers)
                  Padding(
                    padding: const EdgeInsets.only(right: _spaceMd),
                    child: _DeviceTierCard(tier: tier),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DeviceTierCard extends StatelessWidget {
  const _DeviceTierCard({required this.tier});

  final _ShopItemData tier;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 195,
      padding: const EdgeInsets.all(_spaceLg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_radiusLg),
        border: tier.cardColor != null
            ? Border.all(color: tier.cardColor!, width: 3)
            : Border.all(color: Colors.black.withOpacity(0.1), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (tier.imagePath != null)
            ClipOval(
              child: SizedBox(
                width: 90,
                height: 90,
                child: Image.asset(tier.imagePath!, fit: BoxFit.cover),
              ),
            )
          else
            Container(
              width: 60,
              height: 60,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: tier.color.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(tier.icon, color: tier.color, size: 30),
            ),
          const SizedBox(height: _spaceMd),
          Text(
            tier.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: _fontTitle,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: _spaceSm),
          Text(
            tier.description,
            textAlign: TextAlign.center,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.black.withOpacity(0.65),
              fontSize: _fontBody,
            ),
          ),
          const SizedBox(height: _spaceSm),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: _spaceMd, vertical: _spaceXs),
            decoration: BoxDecoration(
              color: _creamColor,
              borderRadius: BorderRadius.circular(_radiusLg),
            ),
            child: Text(
              '${tier.price} Gold',
              style: const TextStyle(
                fontSize: _fontCaption,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: _spaceMd),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _kiremitColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: _spaceSm),
                textStyle: const TextStyle(fontSize: _fontBody, fontWeight: FontWeight.w800),
              ),
              onPressed: () {},
              child: const Text('Satın Al'),
            ),
          ),
        ],
      ),
    );
  }
}

class _ShopItemTile extends StatelessWidget {
  const _ShopItemTile({required this.data, this.inventory});

  final _ShopItemData data;
  final int? inventory;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: _spaceLg),
      padding: const EdgeInsets.all(_spaceLg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_radiusLg),
        border: data.cardColor != null
            ? Border.all(color: data.cardColor!, width: 2)
            : Border.all(color: Colors.black.withOpacity(0.1), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: data.color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(data.icon, color: data.color, size: 22),
          ),
          const SizedBox(width: _spaceMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.name,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: _fontTitle,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: _spaceXs),
                Text(
                  data.description,
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.65),
                    fontSize: _fontBody,
                  ),
                ),
                if (inventory != null) ...[
                  const SizedBox(height: _spaceSm),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: _spaceSm, vertical: _spaceXs),
                    decoration: BoxDecoration(
                      color: _creamColor,
                      borderRadius: BorderRadius.circular(_radiusLg),
                    ),
                    child: Text(
                      'Sahip Olunan : ${inventory}x',
                      style: const TextStyle(
                        fontSize: _fontCaption,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: _spaceSm),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: _spaceLg, vertical: _spaceMd),
              textStyle: const TextStyle(fontSize: _fontBody, fontWeight: FontWeight.w800),
              elevation: 6,
              shadowColor: Colors.black.withOpacity(0.16),
            ).copyWith(
              // A soft warm-apricot-to-kiremit gradient ties the button into
              // the card's cream/white palette instead of a flat, saturated
              // block of color. backgroundBuilder just wraps the button's
              // already-built Material, so the theme's bevel band and this
              // elevation shadow still paint normally on top of it.
              backgroundBuilder: (context, states, child) => DecoratedBox(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFE08A4B), _kiremitColor],
                  ),
                  borderRadius: BorderRadius.circular(_radiusLg),
                ),
                child: child,
              ),
            ),
            onPressed: () {},
            child: Text(data.buttonLabel),
          ),
        ],
      ),
    );
  }
}

class _MarketTabButton extends StatelessWidget {
  const _MarketTabButton({
    required this.label,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final onColor = color.computeLuminance() > 0.5 ? Colors.black87 : Colors.white;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 56,
        margin: const EdgeInsets.symmetric(horizontal: _spaceXs),
        child: CustomPaint(
          foregroundPainter: _BevelPainter(borderRadius: _radiusSm),
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: _spaceXs),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(_radiusSm),
              border: Border.all(
                color: selected ? onColor : Colors.transparent,
                width: 2,
              ),
            ),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: onColor,
                fontSize: _fontCaption,
                fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PrescriptionStep {
  const _PrescriptionStep(this.label, {this.icon, this.imagePath});

  final String label;
  final IconData? icon;
  final String? imagePath;
}

class _PrescriptionOrder {
  const _PrescriptionOrder({
    required this.patientName,
    required this.magistralName,
    required this.purpose,
    required this.chemicals,
    required this.steps,
  });

  final String patientName;
  final String magistralName;
  final String purpose;
  final List<String> chemicals;
  final List<_PrescriptionStep> steps;
}

const List<_PrescriptionOrder> _prescriptionOrders = [
  _PrescriptionOrder(
    patientName: 'Ahmet Yılmaz',
    magistralName: 'Mentollü Ağrı Kesici Jel',
    purpose: 'Kas ve eklem ağrılarını hafifletme',
    chemicals: ['Mentol', 'Karbomer', 'Etanol', 'Distile Su'],
    steps: [
      _PrescriptionStep('Soğutma', imagePath: 'assets/images/Sogutma_ikon.webp'),
      _PrescriptionStep('Isıtma', imagePath: 'assets/images/Burn_icon.webp'),
      _PrescriptionStep('Maserasyon', imagePath: 'assets/images/Maserasyon_ikon.webp'),
    ],
  ),
  _PrescriptionOrder(
    patientName: 'Ayşe Demir',
    magistralName: 'Çinko Oksit Pişik Kremi',
    purpose: 'Bebeklerde pişik önleyici bariyer krem',
    chemicals: ['Çinko Oksit', 'Gliserin', 'Vazelin'],
    steps: [
      _PrescriptionStep('Tartım', icon: Icons.scale_outlined),
      _PrescriptionStep('Karıştırma', icon: Icons.autorenew),
      _PrescriptionStep('Homojenizasyon', icon: Icons.blur_on),
      _PrescriptionStep('Paketleme', icon: Icons.inventory_2_outlined),
    ],
  ),
  _PrescriptionOrder(
    patientName: 'Mehmet Kaya',
    magistralName: 'Borik Asit Kapsülü',
    purpose: 'Antifungal etkili majistral kapsül',
    chemicals: ['Borik Asit', 'Laktoz', 'Nişasta'],
    steps: [
      _PrescriptionStep('Eleme', icon: Icons.filter_alt_outlined),
      _PrescriptionStep('Tartım', icon: Icons.scale_outlined),
      _PrescriptionStep('Kalıp', imagePath: 'assets/images/Kalıp_ikon.webp'),
      _PrescriptionStep('Kapsül Doldurma', icon: Icons.medication_outlined),
      _PrescriptionStep('Sterilizasyon', icon: Icons.thermostat_outlined),
    ],
  ),
];

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _creamColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
              child: Row(
                children: [
                  _BackButton(onPressed: () => Navigator.of(context).pop()),
                  const SizedBox(width: 12),
                  const Text(
                    'Siparişler',
                    style: TextStyle(
                      fontSize: _fontHeading,
                      fontWeight: FontWeight.w800,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 20.0),
                itemCount: _prescriptionOrders.length,
                itemBuilder: (context, index) {
                  return _PrescriptionOrderCard(order: _prescriptionOrders[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PrescriptionOrderCard extends StatelessWidget {
  const _PrescriptionOrderCard({required this.order});

  final _PrescriptionOrder order;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: _spaceLg),
      padding: const EdgeInsets.all(_spaceLg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_radiusLg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _kiremitColor.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person_outline, color: _kiremitColor),
              ),
              const SizedBox(width: _spaceMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.patientName,
                      style: const TextStyle(
                        fontSize: _fontTitle,
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      'Hasta',
                      style: TextStyle(fontSize: _fontCaption, color: Colors.black.withOpacity(0.54)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: _space2xl),
          Text(
            order.magistralName,
            style: const TextStyle(
              fontSize: _fontTitle,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: _spaceXs),
          Text(
            order.purpose,
            style: TextStyle(fontSize: _fontBody, color: Colors.black.withOpacity(0.65)),
          ),
          const SizedBox(height: _spaceMd),
          Text(
            'Gerekli kimyasallar',
            style: TextStyle(
              fontSize: _fontCaption,
              fontWeight: FontWeight.w700,
              color: Colors.black.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: _spaceSm),
          Wrap(
            spacing: _spaceSm,
            runSpacing: _spaceSm,
            children: [
              for (final chemical in order.chemicals)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: _spaceSm, vertical: _spaceXs),
                  decoration: BoxDecoration(
                    color: _creamColor,
                    borderRadius: BorderRadius.circular(_radiusLg),
                  ),
                  child: Text(
                    chemical,
                    style: const TextStyle(
                      fontSize: _fontCaption,
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: _spaceMd),
          Text(
            'Adımlar',
            style: TextStyle(
              fontSize: _fontCaption,
              fontWeight: FontWeight.w700,
              color: Colors.black.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: _spaceSm),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (var i = 0; i < order.steps.length; i++) ...[
                  _PrescriptionStepIcon(step: order.steps[i]),
                  if (i != order.steps.length - 1)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: _spaceSm),
                      child: Icon(
                        Icons.arrow_forward_rounded,
                        size: 18,
                        color: Colors.black.withOpacity(0.35),
                      ),
                    ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PrescriptionStepIcon extends StatelessWidget {
  const _PrescriptionStepIcon({required this.step});

  final _PrescriptionStep step;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipOval(
          child: SizedBox(
            width: 80,
            height: 80,
            child: step.imagePath != null
                ? Image.asset(step.imagePath!, fit: BoxFit.cover)
                : Container(
                    color: _kiremitColor.withOpacity(0.12),
                    alignment: Alignment.center,
                    child: Icon(step.icon, color: _kiremitColor, size: 40),
                  ),
          ),
        ),
        const SizedBox(height: _spaceXs),
        SizedBox(
          width: 80,
          child: Text(
            step.label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: _fontCaption,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}

class _ProfileStat {
  const _ProfileStat({required this.label, required this.value, required this.icon});

  final String label;
  final String value;
  final IconData icon;
}

class _AchievementData {
  const _AchievementData({
    required this.title,
    required this.description,
    this.unlocked = false,
  });

  final String title;
  final String description;
  final bool unlocked;
}

const List<_AchievementData> _achievements = [
  _AchievementData(
    title: 'İlk Reçete',
    description: 'İlk siparişini hazırla',
  ),
  _AchievementData(
    title: 'Usta Eczacı',
    description: '10 majistral hazırla',
  ),
  _AchievementData(
    title: 'Cihaz Koleksiyoncusu',
    description: 'Tüm cihazları en gelişmiş seviyeye çıkar',
  ),
];

class _ChemicalInventoryItem {
  const _ChemicalInventoryItem({
    required this.name,
    required this.icon,
    required this.color,
  });

  final String name;
  final IconData icon;
  final Color color;
}

const List<_ChemicalInventoryItem> _basicChemicals = [
  _ChemicalInventoryItem(
    name: 'Distile Su',
    icon: Icons.water_drop_outlined,
    color: Color(0xFF1565C0),
  ),
  _ChemicalInventoryItem(
    name: 'Etanol',
    icon: Icons.local_fire_department_outlined,
    color: Color(0xFF6D4C41),
  ),
  _ChemicalInventoryItem(
    name: 'Gliserin',
    icon: Icons.opacity,
    color: Color(0xFF00838F),
  ),
  _ChemicalInventoryItem(
    name: 'Vazelin',
    icon: Icons.spa_outlined,
    color: Color(0xFF757575),
  ),
];

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final List<int> _ownedIngredientQuantities;

  @override
  void initState() {
    super.initState();
    final random = Random();
    _ownedIngredientQuantities = List.generate(
      _activeIngredients.length,
      (_) => random.nextInt(20) + 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    final stats = [
      _ProfileStat(
        label: 'Kayıtlı Sipariş',
        value: '${_prescriptionOrders.length}',
        icon: Icons.receipt_long_outlined,
      ),
      _ProfileStat(
        label: 'Cihaz Modeli',
        value: '${_deviceGroups.length}',
        icon: Icons.precision_manufacturing_outlined,
      ),
      _ProfileStat(
        label: 'Hızlandırma Çeşidi',
        value: '${_accelerators.length}',
        icon: Icons.bolt_outlined,
      ),
    ];

    final chemicalTiles = [
      for (final chemical in _basicChemicals)
        _ChemicalInventoryTile(
          name: chemical.name,
          icon: chemical.icon,
          color: chemical.color,
          quantityLabel: '∞',
        ),
      for (var i = 0; i < _activeIngredients.length; i++)
        _ChemicalInventoryTile(
          name: _activeIngredients[i].name,
          icon: _activeIngredients[i].icon,
          color: _activeIngredients[i].color,
          quantityLabel: '${_ownedIngredientQuantities[i]}x',
        ),
    ];

    return Scaffold(
      backgroundColor: _creamColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(_spaceLg, _spaceLg, _spaceLg, 0),
              child: Row(
                children: [
                  _BackButton(onPressed: () => Navigator.of(context).pop()),
                  const SizedBox(width: _spaceMd),
                  const Text(
                    'Profil',
                    style: TextStyle(
                      fontSize: _fontHeading,
                      fontWeight: FontWeight.w800,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(_spaceLg),
                children: [
                  Row(
                    children: [
                      for (var i = 0; i < stats.length; i++) ...[
                        Expanded(child: _ProfileStatCard(stat: stats[i])),
                        if (i != stats.length - 1) const SizedBox(width: _spaceSm),
                      ],
                    ],
                  ),
                  const SizedBox(height: _spaceXl),
                  const Text(
                    'Başarımlar',
                    style: TextStyle(
                      fontSize: _fontTitle,
                      fontWeight: FontWeight.w800,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: _spaceMd),
                  for (final achievement in _achievements)
                    _AchievementTile(achievement: achievement),
                  const SizedBox(height: _spaceXl),
                  const Text(
                    'Envanterdeki Kimyasallar',
                    style: TextStyle(
                      fontSize: _fontTitle,
                      fontWeight: FontWeight.w800,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: _spaceMd),
                  for (var i = 0; i < chemicalTiles.length; i += 2)
                    Padding(
                      padding: const EdgeInsets.only(bottom: _spaceSm),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: chemicalTiles[i]),
                          const SizedBox(width: _spaceSm),
                          if (i + 1 < chemicalTiles.length)
                            Expanded(child: chemicalTiles[i + 1])
                          else
                            const Spacer(),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileStatCard extends StatelessWidget {
  const _ProfileStatCard({required this.stat});

  final _ProfileStat stat;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: _spaceLg, horizontal: _spaceSm),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_radiusLg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(stat.icon, color: _kiremitColor, size: 24),
          const SizedBox(height: _spaceSm),
          Text(
            stat.value,
            style: const TextStyle(
              fontSize: _fontHeading,
              fontWeight: FontWeight.w800,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: _spaceXs),
          Text(
            stat.label,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: _fontCaption, color: Colors.black.withOpacity(0.6)),
          ),
        ],
      ),
    );
  }
}

class _AchievementTile extends StatelessWidget {
  const _AchievementTile({required this.achievement});

  final _AchievementData achievement;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: _spaceMd),
      padding: const EdgeInsets.all(_spaceLg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_radiusLg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: (achievement.unlocked ? _kiremitColor : Colors.grey).withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              achievement.unlocked ? Icons.emoji_events : Icons.lock_outline,
              color: achievement.unlocked ? _kiremitColor : Colors.grey,
              size: 22,
            ),
          ),
          const SizedBox(width: _spaceMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  achievement.title,
                  style: TextStyle(
                    fontSize: _fontTitle,
                    fontWeight: FontWeight.w800,
                    color: achievement.unlocked ? Colors.black87 : Colors.black.withOpacity(0.45),
                  ),
                ),
                const SizedBox(height: _spaceXs),
                Text(
                  achievement.description,
                  style: TextStyle(
                    fontSize: _fontBody,
                    color: Colors.black.withOpacity(achievement.unlocked ? 0.65 : 0.4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChemicalInventoryTile extends StatelessWidget {
  const _ChemicalInventoryTile({
    required this.name,
    required this.icon,
    required this.color,
    required this.quantityLabel,
  });

  final String name;
  final IconData icon;
  final Color color;
  final String quantityLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(_spaceMd),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_radiusLg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: _spaceSm),
          Expanded(
            child: Text(
              name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: _fontCaption,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(width: _spaceXs),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: _spaceSm, vertical: _spaceXs),
            decoration: BoxDecoration(
              color: _creamColor,
              borderRadius: BorderRadius.circular(_radiusLg),
            ),
            child: Text(
              quantityLabel,
              style: const TextStyle(
                fontSize: _fontCaption,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum _DiseaseCategory { solunum, dermatoloji, noroloji }

extension on _DiseaseCategory {
  String get label {
    switch (this) {
      case _DiseaseCategory.solunum:
        return 'Solunum Sistemi';
      case _DiseaseCategory.dermatoloji:
        return 'Dermatoloji';
      case _DiseaseCategory.noroloji:
        return 'Nöroloji';
    }
  }

  IconData get icon {
    switch (this) {
      case _DiseaseCategory.solunum:
        return Icons.air_outlined;
      case _DiseaseCategory.dermatoloji:
        return Icons.face_retouching_natural_outlined;
      case _DiseaseCategory.noroloji:
        return Icons.psychology_outlined;
    }
  }

  Color get color {
    switch (this) {
      case _DiseaseCategory.solunum:
        return const Color(0xFF0097A7);
      case _DiseaseCategory.dermatoloji:
        return const Color(0xFFAD1457);
      case _DiseaseCategory.noroloji:
        return const Color(0xFF5E35B1);
    }
  }
}

class DiseaseScreen extends StatefulWidget {
  const DiseaseScreen({super.key});

  @override
  State<DiseaseScreen> createState() => _DiseaseScreenState();
}

class _MagistralQuizItem {
  const _MagistralQuizItem({
    required this.name,
    required this.chemicals,
    required this.category,
  });

  final String name;
  final List<String> chemicals;
  final _DiseaseCategory category;
}

const List<_MagistralQuizItem> _magistralQuizItems = [
  _MagistralQuizItem(
    name: 'Ambroksol Şurubu',
    chemicals: ['Ambroksol HCl', 'Gliserin', 'Mentol', 'Distile Su'],
    category: _DiseaseCategory.solunum,
  ),
  _MagistralQuizItem(
    name: 'Salbutamol Solüsyonu',
    chemicals: ['Salbutamol Sülfat', 'Sodyum Klorür', 'Distile Su'],
    category: _DiseaseCategory.solunum,
  ),
  _MagistralQuizItem(
    name: 'Guaifenesin Şurubu',
    chemicals: ['Guaifenesin', 'Dekstrometorfan', 'Mentol', 'Bal Özü'],
    category: _DiseaseCategory.solunum,
  ),
  _MagistralQuizItem(
    name: 'Çinko Oksit Kremi',
    chemicals: ['Çinko Oksit', 'Gliserin', 'Vazelin'],
    category: _DiseaseCategory.dermatoloji,
  ),
  _MagistralQuizItem(
    name: 'Salisilik Asit Losyonu',
    chemicals: ['Salisilik Asit', 'Etanol', 'Distile Su'],
    category: _DiseaseCategory.dermatoloji,
  ),
  _MagistralQuizItem(
    name: 'Hidrokortizon Kremi',
    chemicals: ['Hidrokortizon', 'Mentol', 'Vazelin', 'Gliserin'],
    category: _DiseaseCategory.dermatoloji,
  ),
  _MagistralQuizItem(
    name: 'Lidokain Jeli',
    chemicals: ['Lidokain', 'Karbomer', 'Etanol', 'Distile Su'],
    category: _DiseaseCategory.noroloji,
  ),
  _MagistralQuizItem(
    name: 'Kafein Merhemi',
    chemicals: ['Kafein', 'Mentol', 'Kamfor'],
    category: _DiseaseCategory.noroloji,
  ),
  _MagistralQuizItem(
    name: 'Gabapentin Kapsülü',
    chemicals: ['Gabapentin', 'Laktoz', 'Nişasta'],
    category: _DiseaseCategory.noroloji,
  ),
];

class _StreakReward {
  const _StreakReward({required this.streak, required this.reward});

  final int streak;
  final String reward;
}

const List<_StreakReward> _streakRewards = [
  _StreakReward(streak: 10, reward: '50 Gold'),
  _StreakReward(streak: 20, reward: 'Hızlandırma Kartı (30 dk)'),
  _StreakReward(streak: 40, reward: 'Nadir Kimyasal Paketi'),
  _StreakReward(streak: 50, reward: 'Altın Sertifika Rozeti'),
];

class _DiseaseScreenState extends State<DiseaseScreen> {
  final Random _random = Random();

  bool _started = false;
  int _streak = 0;
  _MagistralQuizItem? _current;
  bool? _lastCorrect;
  _DiseaseCategory? _lastCorrectCategory;
  _DiseaseCategory? _tappedCategory;
  bool _awaitingNext = false;

  void _startGame() {
    setState(() {
      _started = true;
      _streak = 0;
      _lastCorrect = null;
      _lastCorrectCategory = null;
      _tappedCategory = null;
      _awaitingNext = false;
      _current = _magistralQuizItems[_random.nextInt(_magistralQuizItems.length)];
    });
  }

  _MagistralQuizItem _pickNext({required _MagistralQuizItem exclude}) {
    if (_magistralQuizItems.length == 1) return _magistralQuizItems.first;
    _MagistralQuizItem next;
    do {
      next = _magistralQuizItems[_random.nextInt(_magistralQuizItems.length)];
    } while (identical(next, exclude));
    return next;
  }

  void _answer(_DiseaseCategory category) {
    final current = _current;
    if (current == null || _awaitingNext) return;
    final correct = category == current.category;
    setState(() {
      _lastCorrect = correct;
      _lastCorrectCategory = current.category;
      _tappedCategory = category;
      _awaitingNext = true;
      if (correct) {
        _streak += 1;
      } else {
        _streak = 0;
      }
    });
  }

  void _nextQuestion() {
    final current = _current;
    setState(() {
      _lastCorrect = null;
      _lastCorrectCategory = null;
      _tappedCategory = null;
      _awaitingNext = false;
      _current = current == null
          ? _magistralQuizItems[_random.nextInt(_magistralQuizItems.length)]
          : _pickNext(exclude: current);
    });
  }

  _AnswerButtonState _buttonStateFor(_DiseaseCategory category) {
    if (!_awaitingNext) return _AnswerButtonState.neutral;
    if (category == _lastCorrectCategory) return _AnswerButtonState.correct;
    if (category == _tappedCategory) return _AnswerButtonState.wrong;
    return _AnswerButtonState.dimmed;
  }

  void _showRewardsDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(_spaceXl),
            decoration: BoxDecoration(
              color: _creamColor,
              borderRadius: BorderRadius.circular(_radiusLg),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Ödüller',
                  style: TextStyle(
                    fontSize: _fontHeading,
                    fontWeight: FontWeight.w800,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: _spaceLg),
                for (final reward in _streakRewards) ...[
                  _RewardTile(reward: reward),
                  if (reward != _streakRewards.last) const SizedBox(height: _spaceSm),
                ],
                const SizedBox(height: _spaceLg),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _kiremitColor,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Kapat'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _creamColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, outerConstraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: outerConstraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
                        child: Row(
                          children: [
                            _BackButton(onPressed: () => Navigator.of(context).pop()),
                            const SizedBox(width: 12),
                            _RewardsBox(onTap: () => _showRewardsDialog(context)),
                            const Spacer(),
                            if (_started) _StreakBadge(streak: _streak),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16.0, _spaceSm, 16.0, 0),
                        child: _StreakProgressBar(
                          streak: _streak,
                          milestones: _streakRewards.map((r) => r.streak).toList(),
                        ),
                      ),
                      Expanded(
                        child: _started
                            ? Padding(
                                padding: const EdgeInsets.symmetric(vertical: _spaceMd),
                                child: Center(child: _buildQuizContent()),
                              )
                            : Center(child: _buildStartButton()),
                      ),
                      if (_started)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(_spaceLg, 0, _spaceLg, _space2xl),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Visibility(
                                visible: _awaitingNext,
                                maintainState: true,
                                maintainAnimation: true,
                                maintainSize: true,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: _spaceSm),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: _kiremitColor,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(vertical: _spaceMd),
                                      ),
                                      onPressed: _awaitingNext ? _nextQuestion : null,
                                      child: const Text('Sonraki'),
                                    ),
                                  ),
                                ),
                              ),
                              IntrinsicHeight(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    for (final category in _DiseaseCategory.values) ...[
                                      Expanded(
                                        child: _DiseaseCategoryButton(
                                          category: category,
                                          state: _buttonStateFor(category),
                                          onTap: () => _answer(category),
                                        ),
                                      ),
                                      if (category != _DiseaseCategory.values.last)
                                        const SizedBox(width: _spaceSm),
                                    ],
                                  ],
                                ),
                              ),
                  ],
                ),
              ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStartButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: _kiremitColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: _space2xl, vertical: _spaceLg),
        textStyle: const TextStyle(fontSize: _fontTitle, fontWeight: FontWeight.w800),
      ),
      onPressed: _startGame,
      child: const Text('Oyunu Başlat'),
    );
  }

  Widget _buildQuizContent() {
    final current = _current;
    if (current == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: _spaceXl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Bu majistral hangi sistemle ilgili?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: _fontHeading + 2,
              fontWeight: FontWeight.w900,
              color: _kiremitColor,
            ),
          ),
          const SizedBox(height: _spaceLg),
          Text(
            current.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: _fontTitle,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: _spaceMd),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: _spaceLg, vertical: _spaceXs),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(_radiusLg),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                for (var i = 0; i < current.chemicals.length; i++) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: _spaceSm),
                    child: Row(
                      children: [
                        Icon(Icons.science_outlined, size: 22, color: _kiremitColor),
                        const SizedBox(width: _spaceMd),
                        Expanded(
                          child: Text(
                            current.chemicals[i],
                            style: const TextStyle(
                              fontSize: _fontBody,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (i != current.chemicals.length - 1)
                    Divider(height: 1, color: Colors.black.withOpacity(0.08)),
                ],
              ],
            ),
          ),
          if (_lastCorrect != null) ...[
            const SizedBox(height: _spaceXl),
            if (_lastCorrect == true)
              Image.asset('assets/images/Oyun_tick.png', width: 132, height: 132)
            else ...[
              Image.asset('assets/images/Carpi.webp', width: 132, height: 132),
              const SizedBox(height: _spaceXs),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Doğru cevap: ',
                    style: TextStyle(
                      fontSize: _fontBody * 1.4,
                      color: Colors.black.withOpacity(0.6),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Icon(_lastCorrectCategory!.icon, size: 32, color: _lastCorrectCategory!.color),
                  const SizedBox(width: 8),
                  Text(
                    _lastCorrectCategory!.label,
                    style: TextStyle(
                      fontSize: _fontBody * 1.4,
                      color: Colors.black.withOpacity(0.6),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ],
      ),
    );
  }
}

class _StreakBadge extends StatelessWidget {
  const _StreakBadge({required this.streak});

  final int streak;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: _spaceMd, vertical: _spaceXs),
      decoration: BoxDecoration(
        color: _kiremitColor,
        borderRadius: BorderRadius.circular(_radiusLg),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.local_fire_department, color: Colors.white, size: 16),
          const SizedBox(width: 4),
          Text(
            'Streak: $streak',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: _fontCaption),
          ),
        ],
      ),
    );
  }
}

class _RewardsBox extends StatelessWidget {
  const _RewardsBox({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: _spaceMd, vertical: _spaceSm),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(_radiusLg),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.card_giftcard, color: _kiremitColor, size: 18),
            SizedBox(width: 6),
            Text(
              'Ödüller',
              style: TextStyle(fontSize: _fontBody, fontWeight: FontWeight.w800, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}

class _StreakProgressBar extends StatelessWidget {
  const _StreakProgressBar({required this.streak, required this.milestones});

  final int streak;
  final List<int> milestones;

  @override
  Widget build(BuildContext context) {
    final maxStreak = milestones.last;
    final progress = (streak / maxStreak).clamp(0.0, 1.0);
    const barHeight = 16.0;
    const barRadius = barHeight / 2;
    return SizedBox(
      width: double.infinity,
      height: barHeight,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          return Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: barHeight,
                decoration: BoxDecoration(
                  color: const Color(0xFFFDEFDD),
                  borderRadius: BorderRadius.circular(barRadius),
                  border: Border.all(color: const Color(0xFFFFC48A)),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(barRadius),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                  height: barHeight,
                  width: width * progress,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFFFC178), Color(0xFFFFA552)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                ),
              ),
              for (final milestone in milestones)
                Positioned(
                  left: (width * (milestone / maxStreak)).clamp(1.5, width - 1.5) - 1.5,
                  top: 3,
                  child: Container(
                    width: 3,
                    height: barHeight - 6,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _RewardTile extends StatelessWidget {
  const _RewardTile({required this.reward});

  final _StreakReward reward;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: _spaceLg, vertical: _spaceMd),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_radiusLg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _kiremitColor.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.emoji_events, color: _kiremitColor, size: 18),
          ),
          const SizedBox(width: _spaceMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${reward.streak} Streak',
                  style: const TextStyle(
                    fontSize: _fontBody,
                    fontWeight: FontWeight.w800,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  reward.reward,
                  style: TextStyle(fontSize: _fontCaption, color: Colors.black.withOpacity(0.6)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

enum _AnswerButtonState { neutral, correct, wrong, dimmed }

class _DiseaseCategoryButton extends StatelessWidget {
  const _DiseaseCategoryButton({
    required this.category,
    required this.state,
    required this.onTap,
  });

  final _DiseaseCategory category;
  final _AnswerButtonState state;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bool enabled = state == _AnswerButtonState.neutral;
    final bool highlighted =
        state == _AnswerButtonState.correct || state == _AnswerButtonState.wrong;

    Color fgColor;
    Color borderColor;
    List<Color> gradientColors;

    switch (state) {
      case _AnswerButtonState.neutral:
      case _AnswerButtonState.dimmed:
        fgColor = category.color;
        borderColor = Colors.black.withOpacity(0.1);
        gradientColors = [Colors.white, category.color.withOpacity(0.08)];
      case _AnswerButtonState.correct:
        fgColor = Colors.white;
        borderColor = const Color(0xFF2E7D32);
        gradientColors = const [Color(0xFF7BC67E), Color(0xFF2E7D32)];
      case _AnswerButtonState.wrong:
        fgColor = Colors.white;
        borderColor = const Color(0xFFD32F2F);
        gradientColors = const [Color(0xFFFF8A80), Color(0xFFD32F2F)];
    }

    return Opacity(
      opacity: state == _AnswerButtonState.dimmed ? 0.45 : 1.0,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(_radiusLg),
        elevation: 6,
        shadowColor: Colors.black.withOpacity(0.18),
        child: InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: BorderRadius.circular(_radiusLg),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: _spaceSm, horizontal: _spaceXs),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: gradientColors,
              ),
              borderRadius: BorderRadius.circular(_radiusLg),
              border: Border.all(color: borderColor, width: 2),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(category.icon, color: fgColor, size: 34),
                const SizedBox(height: _spaceXs),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    category.label,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: _fontBody,
                      fontWeight: FontWeight.w700,
                      color: highlighted ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
