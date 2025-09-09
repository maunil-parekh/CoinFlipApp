import 'dart:math';
import 'package:flutter/material.dart';
import '../widgets/coin_image.dart';

enum CoinFace { heads, tails }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _rand = Random();
  CoinFace _face = CoinFace.heads;
  final List<CoinFace> _history = [];

  void _flip() {
    setState(() {
      _face = _rand.nextBool() ? CoinFace.heads : CoinFace.tails;
      _history.insert(0, _face);
      if (_history.length > 10) _history.removeLast();
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Coin Flip')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Expanded(
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
                  child: CoinImage(
                    key: ValueKey(_face),
                    face: _face,
                    size: MediaQuery.of(context).size.width * 0.6,
                  ),
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
              onPressed: _flip,
              label: const Text('Flip'),
              icon: const Icon(Icons.refresh),
            ),
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Last 10 flips', style: textTheme.titleMedium),
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
