import 'package:breastscan/screens/ana_sayfa.dart';
import 'package:breastscan/screens/sonuc_sayfa.dart';
import 'package:breastscan/widgets/mamogafi_yukle_butonu.dart';
import 'package:breastscan/widgets/metadata_yukle_butonu.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MamografiYuklemeSayfasi extends StatefulWidget {
  const MamografiYuklemeSayfasi({super.key});

  @override
  State<MamografiYuklemeSayfasi> createState() =>
      _MamografiYuklemeSayfasiState();
}

class _MamografiYuklemeSayfasiState extends State<MamografiYuklemeSayfasi> {
  String? selectedImagePath;
  String? selectedMetadataPath;
  String? selectedMetadataName;

  Future<void> pickImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null && result.files.single.path != null) {
      setState(() {
        selectedImagePath = result.files.single.path!;
      });
    }
  }

  Future<void> pickMetadata() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv', 'json'],
    );
    if (result != null && result.files.single.path != null) {
      setState(() {
        selectedMetadataPath = result.files.single.path!;
        selectedMetadataName = result.files.single.name;
      });
    }
  }

  void analyzeIfReady() async {
    if (selectedImagePath == null || selectedMetadataPath == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Lütfen hem mamografi görseli hem de metadata seçin."),
        ),
      );
      return;
    }
    final startTime = DateTime.now(); // ⏱️ BAŞLANGIÇ ZAMANI

    try {
      var uri = Uri.parse("http://10.0.2.2:8000/predict");

      var request =
          http.MultipartRequest('POST', uri)
            ..files.add(
              await http.MultipartFile.fromPath('image', selectedImagePath!),
            )
            ..files.add(
              await http.MultipartFile.fromPath(
                'metadata',
                selectedMetadataPath!,
              ),
            );

      var response = await request.send();
      final endTime = DateTime.now(); // ⏱️ BİTİŞ ZAMANI
      final duration = endTime.difference(startTime).inMilliseconds / 1000.0;
      print(
        "✅ Analiz süresi: ${duration.toStringAsFixed(2)} saniye",
      ); // 🔍 DEBUG

      if (!mounted) return;

      if (response.statusCode == 200) {
        final respStr = await response.stream.bytesToString();
        final data = json.decode(respStr);
        final resultCode = data['result'];

        String resultText;
        if (resultCode == 1 || resultCode == '1') {
          resultText = "Kötü Huylu Tümör";
        } else {
          resultText = "İyi Huylu Tümör";
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (context) => SonucSayfa(
                  imagePath: selectedImagePath!,
                  resultText: resultText,
                ),
          ),
        );
      } else {
        throw Exception("API Hatası: ${response.statusCode}");
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Hata: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF282F4C),
      body: SafeArea(
        child: Stack(
          children: [
            // Geri Butonu
            Positioned(
              top: 10,
              left: 15,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                iconSize: 37,
                onPressed:
                    () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const AnaSayfa()),
                    ),
              ),
            ),

            // Başlık
            const Positioned(
              top: 80,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  'MAMOGRAFİ\n TESPİTİ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            // Mamografi Yükleme Butonu
            Positioned(
              top: 240,
              left: 43,
              right: 43,
              child: MamografiYukleButonu(
                selectedImagePath: selectedImagePath,
                onTap: pickImage,
              ),
            ),

            // Metadata Yükleme Butonu
            Positioned(
              top: 420,
              left: 43,
              right: 43,
              child: MetadataYukleButonu(
                onPressed: pickMetadata,
                fileName: selectedMetadataName,
              ),
            ),

            // Analiz Butonu
            Positioned(
              bottom: 125,
              left: 70,
              right: 70,
              child: ElevatedButton(
                onPressed: analyzeIfReady,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD9D9D9),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Analiz Yap',
                  style: TextStyle(
                    color: Color(0xFF282F4C),
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
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
