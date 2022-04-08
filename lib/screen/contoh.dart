import 'package:flutter/material.dart';

class contoh extends StatelessWidget {
  const contoh({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: double.infinity,
            height: size.height * 0.3,
            color: Colors.red,
            child: SafeArea(
              child: Column(
                children: const [Text('jadwal Sholat'), Text('Kota Malang')],
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            left: 0,
            right: 0,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              // color: Colors.black,
              height: 100,
              child: Card(
                child: Column(
                  children: const [],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
