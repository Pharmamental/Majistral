import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// Koyu ceviz tezgâh: üstte raf kenarı (açık üst yüz, koyu ön yüz, altına
/// düşen gölge), altında yatay tahtalar. Reçeteler raf kenarına bantla
/// yapıştırılıp asılır (2026-10-27).
class CounterTop extends StatelessWidget {
  const CounterTop({super.key, required this.child});

  /// Raf kenarının yüksekliği; asılan kartların bandı bu kenara biner.
  static const double lip = 15;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(height: 5, color: AppColors.counterLip),
        Container(height: lip - 5, color: AppColors.counterEdge),
        Expanded(
          child: ColoredBox(
            color: AppColors.counterPlanks.first,
            child: _Backdrop(painter: _WalnutPainter(), child: child),
          ),
        ),
      ],
    );
  }
}

/// Tezgâh dokusu kendi katmanında bir kez çizilir ve saklanır; üstündeki
/// içerik (saniyede bir yenilenen sayaçlar, kaydırılan kartlar) değişince doku
/// yeniden çizilmez. Telefonda tarayıcıda kasmanın sebebi buydu (2026-10-28).
class _Backdrop extends StatelessWidget {
  const _Backdrop({required this.painter, required this.child});

  final CustomPainter painter;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // Kartların bandı raf kenarına taşar; kırpılmaz.
    return Stack(
      fit: StackFit.expand,
      clipBehavior: Clip.none,
      children: [
        RepaintBoundary(child: CustomPaint(painter: painter, isComplex: true)),
        RepaintBoundary(child: child),
      ],
    );
  }
}

/// Laboratuvarın koyu gri arduvaz tezgâhı: ceviz tezgâhla aynı kenar, üstü
/// ince benekli taş (Tuğrul, 2026-10-27).
class LabBench extends StatelessWidget {
  const LabBench({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(height: 5, color: AppColors.labBenchLip),
        Container(height: CounterTop.lip - 5, color: AppColors.labBenchEdge),
        Expanded(
          child: ColoredBox(
            color: AppColors.labBench,
            child: _Backdrop(painter: _SlatePainter(), child: child),
          ),
        ),
      ],
    );
  }
}

/// Taşın benekleri: açık ve koyu küçük noktalar, sabit tohumla; üstte kenarın
/// gölgesi.
class _SlatePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rnd = math.Random(5);
    final dot = Paint();
    for (var i = 0; i < size.width * size.height / 40; i++) {
      dot.color = (rnd.nextBool() ? Colors.white : Colors.black).withValues(alpha: 0.04 + rnd.nextDouble() * 0.06);
      canvas.drawCircle(
        Offset(rnd.nextDouble() * size.width, rnd.nextDouble() * size.height),
        0.6 + rnd.nextDouble(),
        dot,
      );
    }
    final shade = Rect.fromLTWH(0, 0, size.width, 12);
    canvas.drawRect(
      shade,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.black.withValues(alpha: 0.25), Colors.black.withValues(alpha: 0)],
        ).createShader(shade),
    );
  }

  @override
  bool shouldRepaint(_SlatePainter oldDelegate) => false;
}

/// Market tezgâhı: üstte bordo-beyaz çizgili tente, altında lifli kum tezgâh
/// (Tuğrul, 2026-10-27). Liste tentenin kumaşının altından başlar.
class MarketStall extends StatelessWidget {
  const MarketStall({super.key, required this.child});

  /// Tentenin düz kumaş kısmı; liste bunun altından başlar.
  static const double _awningBody = 18;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.marketBench,
      child: Stack(
        children: [
          Positioned.fill(
            child: _Backdrop(
              painter: _KraftPainter(),
              child: Padding(padding: const EdgeInsets.only(top: _awningBody + AppSpace.sm), child: child),
            ),
          ),
          const Positioned(
            left: 0,
            right: 0,
            top: 0,
            height: _awningBody + 16,
            child: RepaintBoundary(child: CustomPaint(painter: _AwningPainter(body: _awningBody))),
          ),
        ],
      ),
    );
  }
}

/// Tente: dönüşümlü bordo ve beyaz şeritler, altı yarım daire saçak, altına
/// düşen gölge; üst kenarda borunun koyu çizgisi.
class _AwningPainter extends CustomPainter {
  const _AwningPainter({required this.body});

  final double body;

  static const double _stripe = 26;

  Path _scallop(double x) => Path()
    ..moveTo(x, 0)
    ..lineTo(x + _stripe, 0)
    ..lineTo(x + _stripe, body)
    ..arcToPoint(Offset(x, body), radius: const Radius.circular(_stripe / 2))
    ..close();

  @override
  void paint(Canvas canvas, Size size) {
    final count = (size.width / _stripe).ceil();
    final all = Path();
    for (var i = 0; i < count; i++) {
      all.addPath(_scallop(i * _stripe), Offset.zero);
    }
    canvas.drawShadow(all, Colors.black, 4, false);
    for (var i = 0; i < count; i++) {
      canvas.drawPath(_scallop(i * _stripe), Paint()..color = i.isEven ? AppColors.awning : AppColors.awningLight);
    }
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, 3), Paint()..color = Colors.black.withValues(alpha: 0.18));
  }

  @override
  bool shouldRepaint(_AwningPainter oldDelegate) => oldDelegate.body != body;
}

/// Kum tezgâhın lifleri: kısa, rastgele yönlü ince çizgiler, sabit tohumla.
class _KraftPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rnd = math.Random(4);
    final p = Paint()
      ..strokeWidth = 0.8
      ..strokeCap = StrokeCap.round;
    for (var i = 0; i < size.width * size.height / 70; i++) {
      p.color = (rnd.nextBool() ? AppColors.marketBenchFleck : Colors.white)
          .withValues(alpha: 0.08 + rnd.nextDouble() * 0.12);
      final o = Offset(rnd.nextDouble() * size.width, rnd.nextDouble() * size.height);
      final a = rnd.nextDouble() * math.pi;
      final l = 1.5 + rnd.nextDouble() * 3;
      canvas.drawLine(o, o + Offset(math.cos(a) * l, math.sin(a) * l), p);
    }
  }

  @override
  bool shouldRepaint(_KraftPainter oldDelegate) => false;
}

/// Yatay tahtalar, her biri biraz farklı tonda; tahta aralarında koyu derz,
/// içinde düzensiz dalgalı damarlar. Desen sabit tohumla çizilir, her karede
/// aynı kalır.
class _WalnutPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rnd = math.Random(7);
    const h = 58.0;
    const planks = AppColors.counterPlanks;
    final grain = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    for (var i = 0; i * h < size.height; i++) {
      final top = i * h;
      canvas.drawRect(Rect.fromLTWH(0, top, size.width, h), Paint()..color = planks[i % planks.length]);
      // Damarlar: tahta boyunca hafif dalgalanan ince çizgiler.
      for (var g = 0; g < 7; g++) {
        final y0 = top + 4 + rnd.nextDouble() * (h - 8);
        final amp = 0.6 + rnd.nextDouble() * 2.2;
        final freq = 0.008 + rnd.nextDouble() * 0.02;
        final phase = rnd.nextDouble() * math.pi * 2;
        grain.color = (rnd.nextBool() ? AppColors.counterGrain : AppColors.counterGrainLight)
            .withValues(alpha: 0.18 + rnd.nextDouble() * 0.18);
        final path = Path()..moveTo(0, y0);
        for (var x = 0.0; x <= size.width; x += 6) {
          path.lineTo(x, y0 + amp * math.sin(x * freq + phase));
        }
        canvas.drawPath(path, grain);
      }
      // Derz.
      canvas.drawRect(Rect.fromLTWH(0, top, size.width, 1.5), Paint()..color = AppColors.counterSeam);
      canvas.drawRect(Rect.fromLTWH(0, top + 1.5, size.width, 1), Paint()..color = const Color(0x1AFFFFFF));
    }
    // Raf kenarının altına düşen gölge.
    final shade = Rect.fromLTWH(0, 0, size.width, 12);
    canvas.drawRect(
      shade,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.black.withValues(alpha: 0.35), Colors.black.withValues(alpha: 0)],
        ).createShader(shade),
    );
  }

  @override
  bool shouldRepaint(_WalnutPainter oldDelegate) => false;
}
