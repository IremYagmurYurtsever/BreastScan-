import 'package:breastscan/screens/ana_sayfa.dart';
import 'package:breastscan/screens/kayit_ol.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OturumAcSayfa extends StatefulWidget {
  const OturumAcSayfa({super.key});

  @override
  State<OturumAcSayfa> createState() => _OturumAcSayfaState();
}

class _OturumAcSayfaState extends State<OturumAcSayfa> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> signIn() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Email veya parola eksik!")));
      return;
    }

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Giriş başarılıysa AnaSayfa'ya git
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AnaSayfa()),
      );
    } on FirebaseAuthException catch (e) {
      String mesaj = "Bir hata oluştu.";
      if (e.code == 'user-not-found') {
        mesaj = "Böyle bir kullanıcı bulunamadı.";
      } else if (e.code == 'wrong-password') {
        mesaj = "Parola yanlış.";
      } else if (e.code == 'invalid-email') {
        mesaj = "Geçersiz email adresi.";
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(mesaj)));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Hata: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFF282F4C),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.only(bottom: 60),
            child: Stack(
              children: [
                // Geri Düğmesi
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
                          builder: (context) => const KayitOlSayfa(),
                        ),
                      );
                    },
                  ),
                ),

                // "HOŞGELDİNİZ" yazısı
                const Positioned(
                  top: 100,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      'HOŞGELDİNİZ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 35,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                ),
                // Slogan
                const Positioned(
                  top: 160,
                  left: 0,
                  right: 0,
                  child: Center(
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
                // E-posta alanı
                Positioned(
                  top: 250,
                  left: 40,
                  right: 40,
                  child: Container(
                    height: 60,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD9D9D9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.centerLeft,
                    child: TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'E-posta giriniz...',
                        hintStyle: TextStyle(
                          color: Color(0xFF817A7A),
                          fontWeight: FontWeight.w600,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),

                // Parola alanı
                Positioned(
                  top: 350,
                  left: 40,
                  right: 40,
                  child: Container(
                    height: 60,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD9D9D9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.centerLeft,
                    child: TextField(
                      controller: passwordController,
                      obscureText: true,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Parola giriniz...',
                        hintStyle: TextStyle(
                          color: Color(0xFF817A7A),
                          fontWeight: FontWeight.w600,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),

                // OTURUM AÇ butonu
                Positioned(
                  top: 450,
                  left: 70,
                  right: 70,
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD9D9D9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextButton(
                      onPressed: () {
                        signIn();
                      },
                      child: const Text(
                        'OTURUM AÇ',
                        style: TextStyle(
                          color: Color(0xFF817A7A),
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
