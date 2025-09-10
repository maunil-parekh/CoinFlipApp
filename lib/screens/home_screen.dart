import 'dart:math';
import 'package:flutter/material.dart';
import '../widgets/coin_image.dart';

enum CoinFace { heads, tails }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final _rand = Random();
  CoinFace _face = CoinFace.heads;
  final List<CoinFace> _history = [];

  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isFlipping = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 2 * pi).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _face = _rand.nextBool() ? CoinFace.heads : CoinFace.tails;
          _history.insert(0, _face);
          if (_history.length > 10) _history.removeLast();
          _isFlipping = false;
        });
      }
    });
  }

  void _toss() {
    if (_isFlipping) return;
    setState(() => _isFlipping = true);
    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final coinSize = MediaQuery.of(context).size.width * 0.6;

    return Scaffold(
      appBar: AppBar(title: const Text('Coin Toss')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Expanded(
              child: Center(
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    final isHalfWay = _animation.value > pi;
                    final displayFace = isHalfWay ? (_face == CoinFace.heads ? CoinFace.tails : CoinFace.heads) : _face;

                    return Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001) // Perspective
                        ..rotateY(_animation.value),
                      child: CoinImage(
                        key: ValueKey(displayFace),
                        face: displayFace,
                        size: coinSize,
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _face == CoinFace.heads ? 'Heads' : 'Tails',
              style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _toss,
              label: const Text('Toss'),
              icon: const Icon(Icons.refresh),
            ),
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Last 10 tosses', style: textTheme.titleMedium),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 50,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _history.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, i) {
                  final f = _history[i];
                  return Chip(
                    label: Text(f == CoinFace.heads ? 'Heads' : 'Tails'),
                    avatar: CircleAvatar(
                      child: Text(f == CoinFace.heads ? 'H' : 'T'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}