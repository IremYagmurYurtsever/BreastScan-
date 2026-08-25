import 'package:breastscan/screens/ana_ekran.dart';
import 'package:breastscan/screens/oturum_ac.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class KayitOlSayfa extends StatefulWidget {
  const KayitOlSayfa({super.key});

  @override
  State<KayitOlSayfa> createState() => _KayitOlSayfaState();
}

class _KayitOlSayfaState extends State<KayitOlSayfa> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          builder: (context) => const AnaEkran(),
                        ),
                      );
                    },
                  ),
                ),

                // "Hoşgeldiniz" yazısı
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
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
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
                    decoration: BoxDecoration(
                      color: const Color(0xFFD9D9D9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
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
                    decoration: BoxDecoration(
                      color: const Color(0xFFD9D9D9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
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

                // KAYIT OL butonu
                Positioned(
                  top: 450,
                  left: 70,
                  right: 70,
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD9D9D9),
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: TextButton(
                      onPressed: () async {
                        final email = emailController.text.trim();
                        final password = passwordController.text.trim();

                        if (email.isEmpty || password.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Email veya parola eksik!"),
                            ),
                          );
                          return;
                        }

                        try {
                          await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                                email: email,
                                password: password,
                              );

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const OturumAcSayfa(),
                            ),
                          );
                        } on FirebaseAuthException catch (e) {
                          String mesaj = "Bir hata oluştu.";
                          if (e.code == 'weak-password') {
                            mesaj = "Parola çok zayıf.";
                          } else if (e.code == 'email-already-in-use') {
                            mesaj = "Bu email zaten kullanılıyor.";
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
                      },
                      child: const Text(
                        'KAYIT OL',
                        style: TextStyle(
                          color: Color(0xFF817A7A),
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),

                // "Zaten hesabım var. Oturum aç" yazısı
                Positioned(
                  bottom: 220,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const OturumAcSayfa(),
                          ),
                        );
                      },
                      child: Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Zaten hesabım var. ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            TextSpan(
                              text: 'Oturum aç',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                              ),
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
        ),
      ),
    );
  }
}
