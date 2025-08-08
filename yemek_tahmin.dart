import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'tahmin_sonuc.dart';
import 'gradient_background.dart';

class GirisimOnerisiSayfasi extends StatefulWidget {
  @override
  _GirisimOnerisiSayfasiState createState() => _GirisimOnerisiSayfasiState();
}

class _GirisimOnerisiSayfasiState extends State<GirisimOnerisiSayfasi> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  int? kayitli;
  int? mevcut;
  int? izinli;
  int haftasonu = 0;
  int? dusuk;
  int? yuksek;
  int tavuk = 0;
  int et = 0;
  int ogun = 0;
  int tatli = 0;

  bool _isValid = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    super.dispose();
  }

  void _nextPage() {
    if (_currentIndex < 9) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentIndex++;
        _isValid = _validateCurrentQuestion();
      });
    } else {
      _sendData();
    }
  }

  void _previousPage() {
    if (_currentIndex > 0) {
      _pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentIndex--;
        _isValid = _validateCurrentQuestion();
      });
    }
  }

  bool _validateCurrentQuestion() {
    switch (_currentIndex) {
      case 0: return kayitli != null && kayitli! >= 0;
      case 1: return mevcut != null && mevcut! >= 0;
      case 2: return izinli != null && izinli! >= 0;
      case 3: return true;
      case 4: return dusuk != null && dusuk! >= -50 && dusuk! <= 50;
      case 5: return yuksek != null && yuksek! >= -50 && yuksek! <= 60;
      case 6: return true;
      case 7: return true;
      case 8: return true;
      case 9: return true;
      default: return false;
    }
  }

  void _handleInput(void Function(int?) setter, String value) {
    final parsedValue = int.tryParse(value);
    setter(parsedValue);
    setState(() {
      _isValid = _validateCurrentQuestion();
    });
  }

  void _handleRadioInput(void Function(int) setter, int value) {
    setter(value);
    setState(() {
      _isValid = _validateCurrentQuestion();
    });
  }

  Future<void> _sendData() async {
    final url = Uri.parse('http://192.168.1.8:5000/tahmin');
    final body = jsonEncode({
      "kayitli": kayitli,
      "mevcut": mevcut,
      "izinli": izinli,
      "haftasonu": haftasonu,
      "dusuk": dusuk,
      "yuksek": yuksek,
      "tavuk": tavuk,
      "et": et,
      "ogun": ogun,
      "tatli": tatli,
    });

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        int girisimDegeri = decoded['giris_durumu'];
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SonucSayfasi(tahminiOgrenciSayisi: girisimDegeri),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Hata: ${response.body}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Bağlantı hatası: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      _buildNumericQuestion("Kayıtlı öğrenci sayısını giriniz.", Icons.school, (v) => _handleInput((val) => kayitli = val, v)),
      _buildNumericQuestion("Mevcut öğrenci sayısını giriniz.", Icons.people, (v) => _handleInput((val) => mevcut = val, v)),
      _buildNumericQuestion("İzinli öğrenci sayısını giriniz.", Icons.exit_to_app, (v) => _handleInput((val) => izinli = val, v)),
      _buildRadioQuestion("Haftasonu mu?", Icons.weekend, ["Hayır (0)", "Evet (1)"], haftasonu, (v) => _handleRadioInput((val) => haftasonu = val, v), isTatli: false),
      _buildNumericQuestion("Günün en düşük sıcaklığını giriniz.", Icons.trending_down, (v) => _handleInput((val) => dusuk = val, v)),
      _buildNumericQuestion("Günün en yüksek sıcaklığını giriniz.", Icons.trending_up, (v) => _handleInput((val) => yuksek = val, v)),
      _buildRadioQuestion("Tavuklu yemek var mı?", Icons.set_meal, ["Hayır (0)", "Evet (1)"], tavuk, (v) => _handleRadioInput((val) => tavuk = val, v), isTatli: false),
      _buildRadioQuestion("Etli yemek var mı?", Icons.dining, ["Hayır (0)", "Evet (1)"], et, (v) => _handleRadioInput((val) => et = val, v), isTatli: false),
      _buildOgunQuestion(),
      _buildRadioQuestion("Tatlı var mı?", Icons.cake, ["Hayır (0)", "Evet (1)"], tatli, (v) => _handleRadioInput((val) => tatli = val, v), isTatli: true),
    ];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text("Yemek Sayısı Tahmini", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: GradientBackground(
        child: Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: Column(
            children: [
              LinearProgressIndicator(
                value: (_currentIndex + 1) / 10,
                backgroundColor: Colors.white.withOpacity(0.3),
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                minHeight: 4,
              ),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: NeverScrollableScrollPhysics(),
                  children: pages,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNumericQuestion(String question, IconData icon, Function(String) onChanged) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 50, color: Colors.white),
          SizedBox(height: 20),
          Text(
            question,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),
          Container(
            width: 200,
            child: TextField(
              keyboardType: TextInputType.number,
              onChanged: onChanged,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                filled: true,
                fillColor: Colors.white.withOpacity(0.9),
                hintText: "Değer girin",
                contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              ),
            ),
          ),
          SizedBox(height: 40),
          _buildNavigationButtons(),
        ],
      ),
    );
  }

  Widget _buildRadioQuestion(String question, IconData icon, List<String> options, int value, Function(int) onChanged, {bool isTatli = false}) {
    bool disableEvet = isTatli && ogun == 1 && et == 0 && tavuk == 0;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 50, color: Colors.white),
          SizedBox(height: 20),
          Text(
            question,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),
          Column(
            children: options.asMap().entries.map((entry) {
              int index = entry.key;
              String text = entry.value;
              bool isDisabled = disableEvet && index == 1;

              return RadioListTile<int>(
                title: Text(text,
                    style: TextStyle(color: isDisabled ? Colors.white.withOpacity(0.5) : Colors.white)),
                value: index,
                groupValue: value,
                onChanged: isDisabled
                    ? null
                    : (int? value) {
                  if (value != null) onChanged(value);
                },
                activeColor: Colors.white,
              );
            }).toList(),
          ),
          if (disableEvet)
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                "Kahvaltıda tatlı olmayacağı için seçilemez",
                style: TextStyle(color: Colors.white.withOpacity(0.7), fontStyle: FontStyle.italic),
              ),
            ),
          SizedBox(height: 40),
          _buildNavigationButtons(),
        ],
      ),
    );
  }

  Widget _buildOgunQuestion() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.format_list_numbered, size: 50, color: Colors.white),
          SizedBox(height: 20),
          Text(
            "Kahvaltı mı akşam yemeği mi?",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),
          Column(
            children: [
              RadioListTile<int>(
                title: Text("Akşam (0)", style: TextStyle(color: Colors.white)),
                value: 0,
                groupValue: ogun,
                onChanged: (int? value) {
                  if (value != null) {
                    setState(() {
                      ogun = value;
                      _isValid = _validateCurrentQuestion();
                    });
                  }
                },
                activeColor: Colors.white,
              ),
              RadioListTile<int>(
                title: Text("Kahvaltı (1)", style: TextStyle(color: (et == 1 || tavuk == 1) ? Colors.white.withOpacity(0.5) : Colors.white)),
                value: 1,
                groupValue: ogun,
                onChanged: (et == 1 || tavuk == 1)
                    ? null
                    : (int? value) {
                  if (value != null) {
                    setState(() {
                      ogun = value;
                      _isValid = _validateCurrentQuestion();
                    });
                  }
                },
                activeColor: Colors.white,
              ),
              if (et == 1 || tavuk == 1)
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    "Et/Tavuk olduğunda sadece Akşam Yemeği seçilebilir",
                    style: TextStyle(color: Colors.white.withOpacity(0.7), fontStyle: FontStyle.italic),
                  ),
                ),
            ],
          ),
          SizedBox(height: 40),
          _buildNavigationButtons(),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (_currentIndex > 0)
          _buildNavigationButton("Geri", _previousPage, Icons.arrow_back),
        SizedBox(width: 20),
        ElevatedButton.icon(
          icon: Icon(_currentIndex == 9 ? Icons.send : Icons.arrow_forward),
          label: Text(_currentIndex == 9 ? "Sonuçları Gönder" : "İleri"),
          style: ElevatedButton.styleFrom(
            backgroundColor: _isValid ? Colors.white : Colors.white.withOpacity(0.5),
            foregroundColor: Colors.blue[800],
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: _isValid
              ? () {
            FocusScope.of(context).unfocus();
            _nextPage();
          }
              : () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Lütfen geçerli bir değer giriniz")),
            );
          },
        ),
      ],
    );
  }

  Widget _buildNavigationButton(String text, VoidCallback onPressed, IconData icon) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue[800],
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}