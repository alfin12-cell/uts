import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer(
        child: Container(
          height: 25,
          width: 70,
          decoration: BoxDecoration(
              color: Colors.grey, borderRadius: BorderRadius.circular(5)),
        ),
        gradient: const LinearGradient(colors: [Colors.grey, Colors.white]));
  }
}

class LoadingTanggal extends StatelessWidget {
  const LoadingTanggal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer(
        child: Container(
          height: 30,
          width: 150,
          decoration: BoxDecoration(
              color: Colors.grey, borderRadius: BorderRadius.circular(10)),
        ),
        gradient: const LinearGradient(colors: [Colors.white, Colors.grey]));
  }
}
