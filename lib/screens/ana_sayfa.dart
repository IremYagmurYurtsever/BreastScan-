import 'package:breastscan/screens/gecmis_analiz.dart';
import 'package:breastscan/screens/oturum_ac.dart';
import 'package:breastscan/screens/profil_sayfa.dart';
import 'package:breastscan/screens/yukleme_sayfa.dart';
import 'package:flutter/material.dart';

class AnaSayfa extends StatelessWidget {
  const AnaSayfa({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF282F4C),
      body: SafeArea(
        child: Stack(
          children: [
            // Geri butonu
            Positioned(
              top: 10,
              left: 15,
              child: IconButton(
                iconSize: 37,
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const OturumAcSayfa(),
                    ),
                  );
                },
              ),
            ),

            // Profil butonu (sağ üst)
            Positioned(
              top: 10,
              right: 15,
              child: IconButton(
                iconSize: 32,
                icon: const Icon(Icons.person, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfilSayfa(),
                    ),
                  );
                },
              ),
            ),

            // Mamografi Tespiti Yazısı
            const Positioned(
              top: 90,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  'MAMOGRAFİ\n TESPİTİ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            // Mamografi Yükleme Alanı (fotoğraf yükleme için)
            Positioned(
              top: 260,
              left: 43,
              right: 43,
              child: GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MamografiYuklemeSayfasi(),
                    ),
                  );
                },
                child: Container(
                  height: 250,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD9D9D9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.camera_alt,
                        size: 50,
                        color: Color(0xFF282F4C),
                        shadows: [
                          Shadow(
                            blurRadius: 4,
                            color: Colors.black26,
                            offset: Offset(1, 2),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Mamografi yükle',
                        style: TextStyle(
                          color: Color(0xFF282F4C),
                          fontSize: 28,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          shadows: [
                            Shadow(
                              blurRadius: 4,
                              color: Colors.black26,
                              offset: Offset(1, 2),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Geçmiş Analizler Yazısı (tıklanabilir)
            Positioned(
              bottom: 170,
              left: 0,
              right: 0,
              child: GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const GecmisAnaliz(),
                    ),
                  );
                },
                child: const Center(
                  child: Text(
                    'Geçmiş Analizler',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                      shadows: [
                        Shadow(
                          blurRadius: 4,
                          color: Colors.black26,
                          offset: Offset(1, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
