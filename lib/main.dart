import 'package:breastscan/models/analiz_gecmis.dart';
import 'package:breastscan/screens/ana_ekran.dart';
import 'package:flutter/material.dart';
import 'screens/kayit_ol.dart';
import 'screens/oturum_ac.dart';
import 'screens/ana_sayfa.dart';
import 'screens/yukleme_sayfa.dart';
import 'screens/sonuc_sayfa.dart';
import 'screens/gecmis_analiz.dart';
import 'screens/profil_sayfa.dart';
import 'package:firebase_core/firebase_core.dart';

List<AnalizGecmisi> analizGecmisListesi = [];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BreastScan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF282F4C),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const AnaEkran(),
        '/kayit': (context) => const KayitOlSayfa(),
        '/oturum': (context) => const OturumAcSayfa(),
        '/anasayfa': (context) => const AnaSayfa(),
        '/yukleme': (context) => const MamografiYuklemeSayfasi(),
        '/sonuc': (context) => const SonucSayfa(imagePath: '', resultText: ''),
        '/gecmis': (context) => const GecmisAnaliz(),
        '/profil': (context) => const ProfilSayfa(),
      },
    );
  }
}
