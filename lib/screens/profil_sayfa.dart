import 'package:breastscan/screens/ana_sayfa.dart';
import 'package:breastscan/screens/oturum_ac.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilSayfa extends StatefulWidget {
  const ProfilSayfa({super.key});

  @override
  State<ProfilSayfa> createState() => _ProfilSayfaState();
}

class _ProfilSayfaState extends State<ProfilSayfa> {
  final TextEditingController adSoyadController = TextEditingController();
  final TextEditingController dogumTarihiController = TextEditingController();
  final TextEditingController telefonController = TextEditingController();

  String? cinsiyet;

  @override
  void initState() {
    super.initState();
    verileriYukle();
  }

  Future<void> verileriYukle() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('profile')
            .doc('info')
            .get();

    if (doc.exists) {
      final data = doc.data()!;
      setState(() {
        adSoyadController.text = data['name'] ?? '';
        dogumTarihiController.text = data['birthDate'] ?? '';
        telefonController.text = data['phoneNumber'] ?? '';
        cinsiyet = data['gender'] ?? '';
      });
    }
  }

  Future<void> bilgileriKaydet() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Oturum açılmamış.")));
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('profile')
          .doc('info')
          .set({
            'name': adSoyadController.text.trim(),
            'birthDate': dogumTarihiController.text.trim(),
            'gender': cinsiyet ?? '',
            'phoneNumber': telefonController.text.trim(),
          });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AnaSayfa()),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Hata: $e")));
    }
  }

  Widget buildCircle(
    String value,
    String? groupValue,
    Function(String) onChanged,
  ) {
    return GestureDetector(
      onTap: () => onChanged(value),
      child: CircleAvatar(
        radius: 14,
        backgroundColor:
            groupValue == value ? Colors.white : const Color(0xFFD9D9D9),
        child:
            groupValue == value
                ? const Icon(Icons.check, size: 16, color: Color(0xFF282F4C))
                : null,
      ),
    );
  }

  Widget buildLabel(String text, double top) {
    return Positioned(
      top: top,
      left: 30,
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget buildTextField(
    TextEditingController controller,
    String hint,
    double top, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Positioned(
      top: top,
      left: 48,
      right: 48,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFFD9D9D9),
          hintText: hint,
          hintStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF817A7A),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                onPressed: () => Navigator.pop(context),
              ),
            ),
            const Positioned(
              top: 60,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  'Profilim',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            buildLabel("Ad Soyad", 130),
            buildTextField(adSoyadController, "Adınızı yazınız", 180),

            buildLabel("Doğum Tarihi", 250),
            buildTextField(dogumTarihiController, "GG.AA.YYYY", 290),

            const Positioned(
              top: 360,
              left: 30,
              child: Text(
                "Cinsiyet",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Positioned(
              top: 400,
              left: 40,
              right: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      buildCircle(
                        "Kadın",
                        cinsiyet,
                        (val) => setState(() => cinsiyet = val),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        "Kadın",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      buildCircle(
                        "Erkek",
                        cinsiyet,
                        (val) => setState(() => cinsiyet = val),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        "Erkek",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      buildCircle(
                        "Diğer",
                        cinsiyet,
                        (val) => setState(() => cinsiyet = val),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        "Diğer",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            buildLabel("Telefon Numarası", 470),
            buildTextField(
              telefonController,
              "05XXXXXXXXX",
              510,
              keyboardType: TextInputType.phone,
            ),

            Positioned(
              top: 600,
              left: 69,
              right: 69,
              child: ElevatedButton(
                onPressed: bilgileriKaydet,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0x99998DB6),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(23),
                  ),
                ),
                child: const Text(
                  'Bilgileri Kaydet',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            // Çıkış Yap yazısı
            Positioned(
              top: 680, // butonun altına denk gelecek şekilde ayarlandı
              left: 0,
              right: 0,
              child: Center(
                child: TextButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => OturumAcSayfa(),
                      ), // <-- burayı güncelle
                    );
                  },
                  child: const Text(
                    "Çıkış Yap",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
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
