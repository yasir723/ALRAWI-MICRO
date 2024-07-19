<h1 align=center >Alrawi Micro</h1>
<div align=center >
  
![Banner](https://github.com/user-attachments/assets/da9966c9-e521-4068-9fc5-f692ee18dedb)
</div>

## Mikroişlemciler için PWM ve Timer Hesaplayıcı

Bu **Flutter** uygulaması, mikroişlemci tabanlı sistemlerdeki `PWM` (Pulse Width Modulation) ve timer için `ARR` (Auto-Reload Register), `PSC` (Prescaler) ve `CCR` (Capture/Compare Register) değerlerini kolayca hesaplamanızı sağlar.

## Özellikler
- ARR Hesaplama: Auto-Reload Register değerini hesaplar.
- PSC Hesaplama: Prescaler değerini hesaplar.
- CCR Hesaplama: PWM için Capture/Compare Register değerini belirler.
- Kullanıcı Dostu Arayüz: Kullanıcı dostu ve sezgisel arayüz.
- Gerçek Zamanlı Güncellemeler: Değerleri girer girmez anında sonuçlar.

## Sayfalar
- Ana Sayfa
- TIM
- PWM

## Ana Sayfa

Ana sayfa, kullanıcıyı karşılayan iki büyük düğmeden oluşur: `TIM` ve `PWM` hesaplamaları için.
<div align=center >
  <img src="https://github.com/user-attachments/assets/7bb62a90-6f56-4111-a967-e95c5cbf50bc" width = 50%>
</div>

### TIM Sayfası

TIM hesaplama sayfasında, kullanıcılar frekans `Hz` veya periyot `ms` değerlerini girerek ilgili `ARR` ve `PSC` değerlerini hesaplayabilirler. 

Örnek: `10Hz` frekans veya `100ms` periyot için hesaplama.

#### Frekans Girişi (10Hz)

- **Frekans (Hz)**: 10
- **Signal Period (s)**: 1 / 10 = 0.1 saniye
- **Timer Period (ms)**: 0.1 / 2 * 1000 = 50 ms
- **Timer Clock**: 72000
- **Sonuç**: Timer Period * Timer Clock = 50 * 72000 = 3600000

`ARR` ve `PSC` değerleri üzerinde işlem yaparken daha kolay olması için 7200 ile 65536 arasında bir aralıkta hesaplanır. Örneğin, 7200 - i şeklinde bir değeri seçerek, `PSC`'yi aşağıdaki gibi hesaplarız:
- **ARR**: 7200
- **PSC**: 500
- **Zaman Periyodu**: 50 ms

#### Periyot Girişi (100ms)

- **Periyot (ms)**: 100
- **Frekans (Hz)**: 1000 / (100 * 2) = 5 Hz

Aynı frekans hesabı yöntemi kullanılarak `ARR` ve `PSC` değerleri hesaplanabilir:

- **ARR**: 7200
- **PSC**: 1000
- **Zaman Periyodu**: 100 ms
<div align=center >
  <img src="https://github.com/user-attachments/assets/27d6558f-6e91-4ced-8141-24019cba6a23" width = 32% >
  <img src="https://github.com/user-attachments/assets/45bd50aa-86f2-4b01-a7a2-e4626f5a23a8" width = 32% >
  <img src="https://github.com/user-attachments/assets/db23813d-10f2-4270-b515-aa4ba6fc7fac" width = 32% >
</div>

TIM hesaplama işlemi, girilen değere göre ilgili frekans veya periyot değerlerini `ARR` ve `PSC`'ye dönüştürür ve sonucu ekranda gösterir.

### PWM Sayfası

PWM hesaplama sayfasında, kullanıcılar frekans `Hz` ve görev döngüsü `%` değerlerini girerek `ARR`, `PSC` ve `CCR1` değerlerini hesaplayabilirler. 

Örnek: `10Hz` frekans ve `%20` görev döngüsü için hesaplama.

#### Giriş Değerleri: 10Hz, %20

- **Frekans (Hz)**: 10
- **Görev Döngüsü (%)**: 20
- **Signal Period (s)**: 1 / 10 = 0.1 saniye
- **Timer Period (ms)**: 0.1 * 1000 = 100 ms
- **Timer Clock**: 72000
- **Sonuç**: Timer Period * Timer Clock = 100 * 72000 = 7200000

`ARR` ve `PSC` değerleri, 7200 ile 65536 arasında bir aralıkta hesaplanır. Örneğin, 7200 - i şeklinde bir değeri seçerek, `PSC`'yi aşağıdaki gibi hesaplarız:
- **ARR**: 7200
- **PSC**: 1000
- **CCR1**: ARR * Görev Döngüsü = 7200 * 0.2 = 1440
- **Zaman Periyodu**: 100 ms

  
<div align=center >
</div>
<div align=center >
  <img src="https://github.com/user-attachments/assets/7459de72-5962-42bf-b7d7-c2968b67e58b" width = 49%>
  <img src="https://github.com/user-attachments/assets/ee9ae341-e243-4ddb-8e55-30579caf85d7" width = 49%>
</div>

PWM hesaplama işlemi, girilen frekans ve görev döngüsüne göre `ARR`, `PSC` ve `CCR1` değerlerini hesaplar ve sonucu ekranda gösterir.
