import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'yemek_tahmin.dart';
import 'gradient_background.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      textTheme: GoogleFonts.poppinsTextTheme(),
    ),
    home: AnaSayfa(),
  ));
}

class AnaSayfa extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                // UYGULAMA LOGOSU
                Hero(
                  tag: 'appLogo',
                  child: Image.asset(
                    'assets/plate.png',
                    height: 150,
                  ),
                ),
                const SizedBox(height: 30),

                // BAŞLIK
                Text(
                  "Yemek Adet Tahmini",
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Makina Öğrenimi Projesi",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.9),
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 30),

                // BİLGİ BUTONU
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Icon(Icons.info_outline, color: Colors.white),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => UygulamaRehberi()),
                      );
                    },
                  ),
                ),

                // AÇIKLAMA KARTI
                Container(
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Color(0xFF1E88E5).withOpacity(0.2), // Daha canlı mavi tonu
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1.5,
                    ),
                    gradient: LinearGradient( // Gradient efekti ekledim
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF42A5F5).withOpacity(0.25),
                        Color(0xFF1976D2).withOpacity(0.15),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blueGrey.withOpacity(0.1),
                        blurRadius: 12,
                        spreadRadius: 2,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.set_meal,
                          size: 40,
                          color: Colors.white.withOpacity(0.9)), // İkon rengi daha belirgin
                      const SizedBox(height: 15),
                      Text(
                        "Bu uygulama, makina öğrenmesi algoritmaları kullanarak:\n\n"
                            "• Yurt ve öğünler ile ilgili genel verileri analiz eder\n"
                            "• Yemek yiyecek öğrenci sayısını tahmin eder\n"
                        ,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.white,
                          height: 1.5,
                          fontWeight: FontWeight.w500, // Yazı kalınlığı arttı
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // BAŞLAT BUTONU
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    minimumSize: const Size(200, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                    shadowColor: Colors.blue.withOpacity(0.3),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => GirisimOnerisiSayfasi()),
                    );
                  },
                  icon: const Icon(Icons.arrow_right, size: 24),
                  label: const Text("Tahmine başla",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// YENİ EKLENEN UYGULAMA REHBERİ SAYFASI
class UygulamaRehberi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Uygulama Rehberi"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              icon: Icons.analytics,
              title: "Nasıl Çalışır?",
              content: "Bu proje, KYK yemekhanesinden toplanan değişkenli verilerle beslenen bir makine öğrenmesi modeline sahiptir. Kullanıcıdan alınan parametreler API aracılığıyla modele gönderilir ve model, gün içindeki tahmini yemek yiyen kişi sayısını hesaplar.",
            ),

            _buildSection(
              icon: Icons.input,
              title: "Gerekli Veriler",
              content: "• Kayıtlı öğrenci sayısı\n• Günlük mevcut öğrenci sayısı\n• İzinli öğrenci sayısı\n"
                  "• Haftasonu mu?\n• Günün en düşük sıcaklığı\n• Günün en yüksek sıcaklığı\n• Yemekte tavuk var mı?\n• Yemekte et var mı?\n• Kahvaltı mı akşam yemeği mi?\n • Tatlı var mı?",
            ),

            _buildSection(
              icon: Icons.info,
              title: "Tahmin",
              content: "Günlük öğüne göre yemek yiyecek öğrenci sayısını tahmin etmek ",
            ),

            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                child: Text("Ana Sayfaya Dön"),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required IconData icon, required String title, required String content}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.blue),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(content),
          ],
        ),
      ),
    );
  }
}