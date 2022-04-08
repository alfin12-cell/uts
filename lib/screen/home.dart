import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:jadwal_sholat/screen/loading.dart';
import 'package:provider/provider.dart';
import 'package:svg_icon/svg_icon.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../tema.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool notif1 = true;
  bool notif2 = true;
  bool notif3 = true;
  bool notif4 = true;
  bool notif5 = true;
  final String PoppinsBold = 'Poppins-Bold';
  final String Bold = 'PoppinsBold';
  final String fontbold = 'PoppinsBoldnormal';
  // ignore: prefer_typing_uninitialized_variables
  late var loading;
  // ignore: prefer_typing_uninitialized_variables
  late var datasubuh;
  late var datadzuhur;
  late var dataashar;
  late var datamaghrib;
  late var dataisya;
  late var datatanggal;
  late var font = TextStyle(
    fontSize: 19,
  );
  late var judul = TextStyle(
      fontSize: 21, fontWeight: FontWeight.w500, color: Colors.grey[700]);

  void ambilData() async {
    Response response = await get(Uri.parse(
        'https://api.banghasan.com/sholat/format/json/jadwal/kota/775/tanggal/2022-03-09'));

    Map data = jsonDecode(response.body);
    print(data);
    String subuh = data['jadwal']['data']['subuh'];
    String dzuhur = data['jadwal']['data']['dzuhur'];
    String ashar = data['jadwal']['data']['ashar'];
    String maghrib = data['jadwal']['data']['maghrib'];
    String isya = data['jadwal']['data']['isya'];
    String tanggal = data['jadwal']['data']['tanggal'];

    setState(() {
      datasubuh = Text(subuh, style: font);
      datadzuhur = Text(dzuhur, style: font);
      dataashar = Text(ashar, style: font);
      datamaghrib = Text(maghrib, style: font);
      dataisya = Text(isya, style: font);
      datatanggal = Text(tanggal, style: judul);
    });
  }

  int _selectedTabIndex = 0;
  void _onNavBarTapped(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  late AndroidInitializationSettings androidInitializationSettings;
  late IOSInitializationSettings iosInitializationSettings;
  late InitializationSettings initializationSettings;

  @override
  void initState() {
    super.initState();
    initializing();
    super.initState();
    loading = const Loading();
    datasubuh = loading;
    datadzuhur = loading;
    dataashar = loading;
    datamaghrib = loading;
    dataisya = loading;
    datatanggal = const LoadingTanggal();
    ambilData();
    print('tunggu sebentar ...');
  }

  void initializing() async {
    androidInitializationSettings = AndroidInitializationSettings('app_icon');
    iosInitializationSettings = IOSInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload) => judul);
    initializationSettings = InitializationSettings(
        android: androidInitializationSettings, iOS: iosInitializationSettings);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (payload) => Bold);
  }

  void notifikasi_shubuh() async {
    await notification(02, 28, 'Shubub');
  }

  void notifikasi_dhuhur() async {
    await notification(02, 12, 'Dzuhur');
  }

  void notifikasi_ashar() async {
    await notification(02, 06, 'Ashar');
  }

  void notifikasi_maghrib() async {
    await notification(02, 06, 'Maghrib');
  }

  void notifikasi_isya() async {
    await notification(02, 06, 'Isya');
  }

  Future<void> notification(int jam, int menit, String sholat) async {
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails(
            'second channel ID', 'second Channel title',
            priority: Priority.high,
            importance: Importance.max,
            ticker: 'test');

    IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails();

    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: iosNotificationDetails);
    await flutterLocalNotificationsPlugin.schedule(
        1,
        'Waktu Sholat ' + sholat,
        'Selamat Beribadah',
        DateTime(2022, 4, 8, jam, menit),
        notificationDetails);
  }

  Future onSelectNotification(String payLoad) async {
    if (payLoad != null) {
      print(payLoad);
    }

    // we can set navigator to navigate another screen
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(body),
      actions: <Widget>[
        CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              print("");
            },
            child: Text("Okay")),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var font = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
    final _listPage = <Widget>[
      Column(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            width: double.infinity,
            height: size.height * 0.25,
            decoration: BoxDecoration(
                color: Colors.green[700],
                image: DecorationImage(
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.35), BlendMode.dstATop),
                    image: const AssetImage('assets/image/masjid.jpg'),
                    fit: BoxFit.cover)),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Consumer<ThemeNotifier>(
                    builder: (context, notifier, child) => Switch(
                      onChanged: (val) {
                        notifier.ubahTema();
                      },
                      value: notifier.darkTheme,
                    ),
                  ),
                  // ToggleButtonsTheme(data: data, child: child),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 10.0, bottom: 8),
                      child: Text(
                        'SholatQu',
                        style: TextStyle(
                            color: Colors.yellow[200],
                            fontFamily: fontbold,
                            fontSize: 30,
                            letterSpacing: 0.4),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              'Jadwal Sholat',
              style: TextStyle(
                fontFamily: PoppinsBold,
                fontSize: 30,
                letterSpacing: 1.5,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Padding(
                padding: EdgeInsets.all(5.0),
                child: Icon(
                  Icons.location_on_outlined,
                  size: 30,
                ),
              ),
              Text(
                "Kota Malang",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
              )
            ],
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  spreadRadius: 0.5,
                  blurRadius: 7,
                  offset: Offset(4, 6), // changes position of shadow
                ),
              ],
            ),
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          SvgIcon(
                            'assets/icon/calendar.svg',
                            width: 50,
                            height: 50,
                            color: Colors.grey[700],
                          ),
                          const SizedBox(
                            width: 10,
                            height: 30,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Padding(
                              //   padding: const EdgeInsets.all(2.0),
                              //   child: Text('', style: judul),
                              // ),
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: datatanggal,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                    'Subuh',
                                    style: font,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                    'Dzuhur',
                                    style: font,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                    'Ashar',
                                    style: font,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                    'Maghrib',
                                    style: font,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                    'Isya',
                                    style: font,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: SvgIcon(
                                    'assets/icon/Shubuh.svg',
                                    width: 30,
                                    height: 30,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: SvgIcon(
                                    'assets/icon/Dhuhur.svg',
                                    width: 30,
                                    height: 30,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: SvgIcon(
                                    'assets/icon/Ashar.svg',
                                    width: 30,
                                    height: 30,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: SvgIcon(
                                    'assets/icon/Maghrib.svg',
                                    width: 30,
                                    height: 30,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: SvgIcon(
                                    'assets/icon/Isya.svg',
                                    width: 30,
                                    height: 30,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      datasubuh,
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: GestureDetector(
                                          onTap: () {
                                            notifikasi_shubuh();
                                            setState(() {
                                              notif1 = !notif1;
                                            });
                                          },
                                          child: Icon(
                                            notif1
                                                ? Icons.notifications_none
                                                : Icons.notifications,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      datadzuhur,
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: GestureDetector(
                                          onTap: () {
                                            notifikasi_dhuhur();
                                            setState(() {
                                              notif2 = !notif2;
                                            });
                                          },
                                          child: Icon(
                                            notif2
                                                ? Icons.notifications_none
                                                : Icons.notifications,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      dataashar,
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              notifikasi_ashar();
                                              notif3 = !notif3;
                                            });
                                          },
                                          child: Icon(
                                            notif3
                                                ? Icons.notifications_none
                                                : Icons.notifications,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      datamaghrib,
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              notifikasi_maghrib();
                                              notif4 = !notif4;
                                            });
                                          },
                                          child: Icon(
                                            notif4
                                                ? Icons.notifications_none
                                                : Icons.notifications,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      dataisya,
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              notifikasi_isya();
                                              notif5 = !notif5;
                                            });
                                          },
                                          child: Icon(
                                            notif5
                                                ? Icons.notifications_none
                                                : Icons.notifications,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.green[900],
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  margin: EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                    color: Colors.yellow,
                    width: 5,
                  ))),
                  child: Text('About',
                      style: TextStyle(
                        fontSize: 30,
                        fontFamily: PoppinsBold,
                        color: Colors.white,
                        letterSpacing: 1.6,
                      )),
                ),
              ),
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 7,
                        offset: Offset(4, 6), // changes position of shadow
                      ),
                    ],
                  ),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                              child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Tugas UTS Matakuliah IOS',
                              style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 19,
                                  fontFamily: fontbold),
                            ),
                          )),
                          const Padding(
                            padding: EdgeInsets.only(bottom: 2, top: 22),
                            child: Text(
                              'Anggota : ',
                              style: TextStyle(
                                  fontWeight: FontWeight.w900, fontSize: 19),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(2),
                            child: Text(
                              '1. Moh. Alfin (19650024)',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(2),
                            child: Text(
                              '2. Muhammad Faiz Alfarros (19650028)',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 18),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(2),
                            child: Text(
                              '3. Helmi Zufan H. (19650125)',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 18),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 12),
                            child: Text(
                              'Dosen Pengampu :',
                              style:
                                  TextStyle(fontSize: 22, fontFamily: fontbold),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 4),
                            child: Text(
                              "A'la Syauqi, M.Kom",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 19),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 16, bottom: 5),
                            child: Text(
                              'Nama Aplikasi :',
                              style:
                                  TextStyle(fontSize: 22, fontFamily: fontbold),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(bottom: 60),
                            child: Text(
                              'Aplikasi Jadwal SHolat',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 19),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    ];
    final _bottomNavBarItems = <BottomNavigationBarItem>[
      const BottomNavigationBarItem(
        icon: Icon(Icons.home),
        title: Text('Home'),
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.label),
        title: Text('About'),
      ),
    ];
    final _bottomNavBar = BottomNavigationBar(
      items: _bottomNavBarItems,
      currentIndex: _selectedTabIndex,
      selectedItemColor: Colors.green[700],
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      onTap: _onNavBarTapped,
    );

    return Scaffold(
      body: Center(child: _listPage[_selectedTabIndex]),
      bottomNavigationBar: _bottomNavBar,
    );
  }
}
