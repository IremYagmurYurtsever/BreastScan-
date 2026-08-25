import 'package:flutter/material.dart';

class MetadataYukleButonu extends StatelessWidget {
  final VoidCallback onPressed;
  final String? fileName;

  const MetadataYukleButonu({
    super.key,
    required this.onPressed,
    this.fileName,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 150,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFD9D9D9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.upload_file, size: 36, color: Color(0xFF282F4C)),
              const SizedBox(height: 10),
              Text(
                fileName != null
                    ? "Seçilen: $fileName"
                    : "Metadata Yükle (.csv/.json)",
                textAlign: TextAlign.center,
                style: const TextStyle(
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
