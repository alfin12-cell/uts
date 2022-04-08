import 'package:flutter/material.dart';
import 'package:jadwal_sholat/screen/contoh.dart';
import 'package:jadwal_sholat/screen/home.dart';
import 'package:jadwal_sholat/tema.dart';
import 'package:provider/provider.dart';

import 'notifikasi.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: Consumer<ThemeNotifier>(
        builder: (context, ThemeNotifier notifier, child) {
          return MaterialApp(
            title: 'Jadwal Sholat',
            theme: notifier.darkTheme ? gelap : terang,
            home: const Home(),
          );
        },
      ),
    );
  }
}
