Yemekhane Adet Tahmin Uygulaması
Bu proje, yemekhane için günlük hazırlanması gereken yemek adedini tahmin etmek amacıyla geliştirilmiş bir makine öğrenmesi uygulamasıdır. Kullanıcıdan alınan verilere göre (kayıtlı öğrenci sayısı, mevcut öğrenci sayısı, izinli öğrenci sayısı, hafta sonu durumu, düşük-yüksek katılım durumu, yemek tercihleri vb.) bir AdaBoost modeli kullanarak tahminde bulunur.

İçindekiler
Proje Hakkında

Teknolojiler

Kurulum

Kullanım

API

Flutter Uygulaması

Model


Proje Hakkında
Bu proje, yemekhane yemek üretiminde israfları önlemek ve kaynak kullanımını optimize etmek için hazırlanmıştır. Python tabanlı Flask API, AdaBoost makine öğrenmesi modeli ile tahmin yapar. Flutter tabanlı mobil uygulama ise kullanıcı arayüzü sağlar, kullanıcıdan verileri alır ve API’ye gönderir.

Teknolojiler
Python 3.x

Flask (API geliştirme)

scikit-learn (AdaBoost modeli)

NumPy

Joblib (model yükleme)

Flutter (mobil uygulama geliştirme)

HTTP (API istekleri için)

Kurulum
API
Python ortamı oluşturun ve aktif edin.

Gerekli kütüphaneleri yükleyin:

pip install flask numpy scikit-learn joblib
adaboost_model.pkl dosyasını model klasörüne koyun veya uygun yol ile güncelleyin.

API’yi çalıştırın:


python app.py
Flutter Uygulaması
Flutter SDK'yı kurun.

Proje dizininde bağımlılıkları yükleyin:


flutter pub get
Uygulamayı başlatın:


flutter run
Kullanım
Mobil uygulamayı açın.

İstenilen bilgileri form aracılığıyla girin.

"Tahmin" butonuna basarak yemek adet tahminini alın.

API
URL: http://<ip_adresiniz>:5000/tahmin

Metot: POST

Gövde (JSON):


{
  "kayitli": 100,
  "mevcut": 80,
  "izinli": 5,
  "haftasonu": 0,
  "dusuk": 10,
  "yuksek": 20,
  "tavuk": 50,
  "et": 30,
  "ogun": 2,
  "tatli": 10
}
Cevap (JSON):


{
  "giris_durumu": 150
}
Flutter Uygulaması
Kullanıcıdan gerekli verileri alan, API ile haberleşen ve sonucu gösteren mobil uygulama Flutter ile geliştirilmiştir. Proje içerisinde ilgili .dart dosyaları bulunmaktadır.

Model
AdaBoost sınıflandırma modeli adaboost_model.pkl olarak kaydedilmiştir. Model, geçmiş veriler üzerinden yemek adet tahmininde kullanılmaktadır.

