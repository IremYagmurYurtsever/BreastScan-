import 'package:breastscan/screens/kayit_ol.dart';
import 'package:flutter/material.dart';

class AnaEkran extends StatelessWidget {
  const AnaEkran({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF282F4C),
      body: Stack(
        children: [
          // Başlık (BreastScan)
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: const Center(
              child: Text(
                'BreastScan',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 60,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          // Slogan
          Positioned(
            top: 180,
            left: 0,
            right: 0,
            child: const Center(
              child: Text(
                '"Erken Teşhis, Güvende Gelecek"',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          // Logo
          Positioned(
            top: 220,
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset(
                'assets/images/logo.png',
                width: 350,
                height: 350,
                fit: BoxFit.contain,
              ),
            ),
          ),

          // Başlayın Butonu
          Positioned(
            bottom: 150,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              const KayitOlSayfa(), // Kayıt ol sayfasını gerçekleştir
                    ),
                  );
                },
                child: Container(
                  width: 280,
                  height: 63,
                  decoration: BoxDecoration(
                    color: const Color(0x99998DB6),
                    borderRadius: BorderRadius.circular(23),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'Başlayın >',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
