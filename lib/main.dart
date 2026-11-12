import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const CloudPrototipApp());
}

class CloudPrototipApp extends StatelessWidget {
  const CloudPrototipApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kişisel Cloud Prototip',
      theme: ThemeData.dark(),
      home: const PrototipAnaSayfa(),
    );
  }
}

class PrototipAnaSayfa extends StatefulWidget {
  const PrototipAnaSayfa({super.key});

  @override
  State<PrototipAnaSayfa> createState() => _PrototipAnaSayfaState();
}

class _PrototipAnaSayfaState extends State<PrototipAnaSayfa> {
  // Bilgisayarın ürettiği 6 haneli eşleşme kodu
  String pcUretilenKod = "123456";
  
  // Telefon tarafı durumları
  bool telefonAktifMi = false;
  bool eslesmeBasariliMi = false;
  final TextEditingController _kodController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _yeniKodUret();
  }

  void _yeniKodUret() {
    final random = Random();
    setState(() {
      pcUretilenKod = (100000 + random.nextInt(900000)).toString();
      eslesmeBasariliMi = false;
    });
  }

  void _koduDogrula() {
    if (_kodController.text.trim() == pcUretilenKod) {
      setState(() {
        eslesmeBasariliMi = true;
        telefonAktifMi = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Eşleşme Başarılı! Cihazlar birbirine bağlandı."),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      setState(() {
        eslesmeBasariliMi = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Hatalı Kod! Bilgisayardaki 6 haneli kodu kontrol et."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.grey[900],
          title: const Text("Cloud Prototip Testi"),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.phone_iphone), text: "Telefon Ekranı"),
              Tab(icon: Icon(Icons.computer), text: "PC (iCloud) Ekranı"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // 1. SEKME: TELEFON UYGULAMASI (Simsiyah ekran, Aç/Kapa ve API Kodu)
            _telefonEkrani(),

            // 2. SEKME: BİLGİSAYAR UYGULAMASI (6 haneli kod + Galeri & Parolalar)
            _bilgisayarEkrani(),
          ],
        ),
      ),
    );
  }

  Widget _telefonEkrani() {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Açık / Kapalı Düğmesi (Yeşil / Kırmızı)
          GestureDetector(
            onTap: () {
              if (!eslesmeBasariliMi) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Önce aşağıdaki kutuya 6 haneli API kodunu girmelisin!"),
                  ),
                );
                return;
              }
              setState(() {
                telefonAktifMi = !telefonAktifMi;
              });
            },
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: telefonAktifMi ? Colors.green : Colors.red,
                boxShadow: [
                  BoxShadow(
                    color: (telefonAktifMi ? Colors.green : Colors.red).withOpacity(0.5),
                    blurRadius: 25,
                    spreadRadius: 5,
                  )
                ],
              ),
              child: const Icon(
                Icons.power_settings_new,
                size: 64,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            telefonAktifMi ? "DURUM: ÇALIŞIYOR" : "DURUM: KAPALI",
            style: TextStyle(
              color: telefonAktifMi ? Colors.greenAccent : Colors.redAccent,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 48),

          // API Key / 6 Haneli Eşleşme Kodu Kutucuğu
          TextField(
            controller: _kodController,
            keyboardType: TextInputType.number,
            maxLength: 6,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24, letterSpacing: 8, color: Colors.white),
            decoration: InputDecoration(
              hintText: "6 Haneli Kod",
              hintStyle: TextStyle(color: Colors.grey[600], letterSpacing: 2, fontSize: 16),
              filled: true,
              fillColor: Colors.grey[900],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: _koduDogrula,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
            ),
            child: const Text("Eşleştir / Bağlan", style: TextStyle(fontSize: 16, color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _bilgisayarEkrani() {
    return Container(
      color: const Color(0xFF121212),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          // PC Tarafı 6 Haneli Kod Gösterimi
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Eşleşme Kodu (API Key):", style: TextStyle(color: Colors.grey)),
                    const SizedBox(height: 4),
                    Text(
                      pcUretilenKod,
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: 6),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: _yeniKodUret,
                  icon: const Icon(Icons.refresh, color: Colors.blueAccent),
                  tooltip: "Yeni Kod Üret",
                )
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Ana Ekrandaki 2 Uygulama (Galeri ve Parolalar)
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              children: [
                _uygulamaIkonu(
                  baslik: "Galeri",
                  ikon: Icons.photo_library,
                  renk: Colors.orangeAccent,
                  aktifMi: eslesmeBasariliMi && telefonAktifMi,
                ),
                _uygulamaIkonu(
                  baslik: "Parolalar",
                  ikon: Icons.vpn_key,
                  renk: Colors.blueAccent,
                  aktifMi: eslesmeBasariliMi && telefonAktifMi,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _uygulamaIkonu({
    required String baslik,
    required IconData ikon,
    required Color renk,
    required bool aktifMi,
  }) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(baslik),
            content: Text(
              aktifMi
                  ? "Bağlantı aktif! Telefondan $baslik verileri çekilmeye hazır."
                  : "Cihaz bağlı değil veya telefon uygulaması kapalı (Kırmızı).",
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text("Tamam"))
            ],
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: aktifMi ? Colors.green.withOpacity(0.5) : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: renk.withOpacity(0.2),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(ikon, size: 48, color: renk),
            ),
            const SizedBox(height: 12),
            Text(baslik, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text(
              aktifMi ? "Bağlı" : "Bekleniyor",
              style: TextStyle(fontSize: 12, color: aktifMi ? Colors.greenAccent : Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}