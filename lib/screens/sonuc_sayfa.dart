import 'package:breastscan/screens/yukleme_sayfa.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class SonucSayfa extends StatelessWidget {
  final String imagePath;
  final String resultText;

  const SonucSayfa({
    super.key,
    required this.imagePath,
    required this.resultText,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasImage = imagePath.isNotEmpty && File(imagePath).existsSync();

    return Scaffold(
      backgroundColor: const Color(0xFF282F4C),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 10,
              left: 15,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                iconSize: 37,
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MamografiYuklemeSayfasi(),
                    ),
                  );
                },
              ),
            ),
            const Positioned(
              top: 80,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  'Analiz Sonucu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 200,
              left: 46,
              right: 46,
              child: Container(
                height: 337,
                decoration: BoxDecoration(
                  color: const Color(0xFFD9D9D9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child:
                    hasImage
                        ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(File(imagePath), fit: BoxFit.cover),
                        )
                        : const Center(
                          child: Text(
                            'Görsel yüklenemedi',
                            style: TextStyle(
                              color: Color(0xFF282F4C),
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
              ),
            ),
            const Positioned(
              top: 560,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  'Sonuç:',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 620,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  resultText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 700,
              left: 75,
              right: 75,
              child: GestureDetector(
                onTap: () async {
                  final now = DateTime.now();
                  final formattedDate =
                      "${now.day.toString().padLeft(2, '0')}.${now.month.toString().padLeft(2, '0')}.${now.year}";

                  final user = FirebaseAuth.instance.currentUser;
                  if (user == null) return;

                  try {
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(user.uid)
                        .collection('analyses')
                        .add({
                          'result': resultText,
                          'date': formattedDate,
                          'imagePath': imagePath,
                        });

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MamografiYuklemeSayfasi(),
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Firestore Hatası: $e")),
                    );
                  }
                },
                child: Container(
                  height: 63,
                  decoration: BoxDecoration(
                    color: const Color(0x99998DB6),
                    borderRadius: BorderRadius.circular(23),
                  ),
                  child: const Center(
                    child: Text(
                      'Tamam',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
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
