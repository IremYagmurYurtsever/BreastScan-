import 'package:flutter/material.dart';
import 'package:breastscan/screens/sonuc_sayfa.dart';

class AnalizYapButonu extends StatelessWidget {
  final String? imagePath;
  final String? metadataPath;

  const AnalizYapButonu({
    super.key,
    required this.imagePath,
    required this.metadataPath,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (imagePath == null || imagePath!.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Lütfen bir mamografi görseli yükleyin.'),
            ),
          );
          return;
        }

        if (metadataPath == null || metadataPath!.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Lütfen metadata dosyasını yükleyin.'),
            ),
          );
          return;
        }

        // Tüm kontroller tamam, sonuç sayfasına geç
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (context) => SonucSayfa(imagePath: imagePath!, resultText: ''),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFD9D9D9),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: const Text(
        'Analiz Yap',
        style: TextStyle(
          color: Color(0xFF282F4C),
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
