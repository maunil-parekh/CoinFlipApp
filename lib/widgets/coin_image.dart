import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../screens/home_screen.dart';

class CoinImage extends StatelessWidget {
  final CoinFace face;
  final double size;

  const CoinImage({super.key, required this.face, this.size = 220});

  @override
  Widget build(BuildContext context) {
    final asset = face == CoinFace.heads ? 'assets/heads.svg' : 'assets/tails.svg';
    return SizedBox(
      width: size,
      height: size,
      child: SvgPicture.asset(asset, fit: BoxFit.contain),
    );
  }
}
