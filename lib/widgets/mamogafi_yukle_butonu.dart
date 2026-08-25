import 'dart:io';
import 'package:flutter/material.dart';

class MamografiYukleButonu extends StatelessWidget {
  final String? selectedImagePath;
  final VoidCallback onTap;

  const MamografiYukleButonu({
    super.key,
    required this.selectedImagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage =
        selectedImagePath != null && File(selectedImagePath!).existsSync();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 150,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFD9D9D9),
          borderRadius: BorderRadius.circular(12),
        ),
        child:
            hasImage
                ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    File(selectedImagePath!),
                    fit: BoxFit.cover,
                  ),
                )
                : const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.image_outlined,
                        size: 50,
                        color: Color(0xFF282F4C),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Mamografi Görüntüsü Yükle",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF282F4C),
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
      ),
    );
  }
}
