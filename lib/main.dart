import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ALRAWI MICRO',
      theme: ThemeData(
        primaryColor: Color(0xff8441c2),
        scaffoldBackgroundColor: Color(0xFF0D1117),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double buttonSize = screenWidth * 0.5;
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'images/logo.png', // Burada logo dosyanızın yolunu belirtin
          height: 80,
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TimCalculationScreen()));
              },
              child: Text('TIM', style: TextStyle(fontSize: 25.0)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                padding: EdgeInsets.symmetric(vertical: 14.0),
                foregroundColor: Colors.white,
                fixedSize: Size(buttonSize, buttonSize), // Buton boyutu
                shape: CircleBorder(), // D
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PwmCalculationScreen()));
              },
              child: Text('PWM', style: TextStyle(fontSize: 25.0)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                padding: EdgeInsets.symmetric(vertical: 14.0),
                foregroundColor: Colors.white,
                fixedSize: Size(buttonSize, buttonSize), // Buton boyutu
                shape: CircleBorder(), // D
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TimCalculationScreen extends StatefulWidget {
  @override
  _TimCalculationScreenState createState() => _TimCalculationScreenState();
}

class _TimCalculationScreenState extends State<TimCalculationScreen> {
  TextEditingController _inputController = TextEditingController();
  String _result = 'Sonucu burada göreceksin 😊';

  List<dynamic> calculateArrPscByFreq(double desiredFreq,
      {int timerClock = 72000}) {
    double signalPeriod = 1 / desiredFreq;
    double timerPeriod = signalPeriod / 2 * 1000;

    double result = timerPeriod * timerClock;
    int MAX = 65536;

    for (int i = 0; i < MAX; i += 10) {
      double ARR = 7200.0 - i;
      double PSC = result / ARR;
      if (ARR < MAX && PSC < MAX) {
        return [ARR, PSC, timerPeriod];
      }
    }

    return [null, null, null];
  }

  List<dynamic> calculateArrPscByTime(double desiredTime) {
    double desiredFreq =
        1000 / (desiredTime * 2); // Milisaniye cinsinden zamanı frekansa çevir
    return calculateArrPscByFreq(desiredFreq);
  }

  String validateInput(String input) {
    input = input.trim().toLowerCase();
    if (input.endsWith('hz')) {
      return 'hz';
    } else if (input.endsWith('ms')) {
      return 'ms';
    }
    return '';
  }

  void _calculateARRPSC(String input) {
    String type = validateInput(input);
    if (type.isNotEmpty) {
      double? value = double.tryParse(input.substring(0, input.length - 2));
      if (value != null) {
        if (value < 0.8) {
          setState(() {
            _result = 'Düşük frekanslar desteklenemiyor';
          });
        } else if (type == 'hz') {
          List<dynamic> result = calculateArrPscByFreq(value);
          setState(() {
            _result = result[0] != null && result[1] != null
                ? 'ARR: ${result[0]}\n PSC: ${result[1]}\n T: ${result[2]} ms'
                : 'Uygun ARR ve PSC değerleri bulunamadı.';
          });
        } else if (type == 'ms') {
          List<dynamic> result = calculateArrPscByTime(value);
          setState(() {
            _result = result[0] != null && result[1] != null
                ? 'ARR: ${result[0]}, PSC: ${result[1]}, T: ${result[2]} ms'
                : 'Uygun ARR ve PSC değerleri bulunamadı.';
          });
        }
      } else {
        setState(() {
          _result = 'Geçersiz giriş';
        });
      }
    } else {
      setState(() {
        _result = 'Geçersiz giriş';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TIM Calculation',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _inputController,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                labelText: 'Enter Frequency (Hz) or Period (ms)',
                labelStyle: TextStyle(color: Colors.grey),
                hintText: 'e.g., 50Hz or 20ms',
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.access_time, color: Colors.grey),
                fillColor: Colors.white,
                filled: true,
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                String input = _inputController.text.trim();
                _calculateARRPSC(input);
              },
              child: Text('Hesapla', style: TextStyle(fontSize: 25.0)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                padding: EdgeInsets.symmetric(vertical: 14.0),
                foregroundColor: Colors.white,
              ),
            ),
            SizedBox(height: 20.0),
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Color(0xffe9e7f4),
                border: Border.all(color: Theme.of(context).primaryColor),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Text(
                _result,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PwmCalculationScreen extends StatefulWidget {
  @override
  _PwmCalculationScreenState createState() => _PwmCalculationScreenState();
}

class _PwmCalculationScreenState extends State<PwmCalculationScreen> {
  TextEditingController _inputController = TextEditingController();
  String _result = 'Sonucu burada göreceksin 😊';

  // Implement the PWM calculation logic here
  List<dynamic> calculatePwm(double desiredFreq, double dutyCycle,
      {int timerClock = 72000}) {
    double signalPeriod = 1 / desiredFreq; // Sinyal periyodu (saniye cinsinden)
    double timerPeriodMs =
        signalPeriod * 1000; // Zamanlayıcı periyodu (milisaniye cinsinden)
    double result = timerPeriodMs * timerClock; // Zamanlayıcı işareti periyodu

    int MAX = 65536;
    double ARR = 0;
    double PSC = 0;
    double CCR1 = 0;

    // Başlangıçta ARR'nin 7200 olup olmadığını kontrol edelim
    for (int i = 0; i < MAX; i++) {
      ARR = 7200.0 - i;
      PSC = result / ARR;

      // ARR ve PSC değerlerini kontrol edelim
      if (ARR > 0 && ARR < MAX && PSC >= 1 && PSC < MAX) {
        // PSC değerinin tam sayı veya çok yakın bir tam sayı olup olmadığını kontrol edelim
        if ((PSC - PSC.floor()) < 0.001) {
          CCR1 = ARR * dutyCycle;
          return [
            ARR.toInt(),
            PSC.toInt(),
            CCR1.toInt(),
            timerPeriodMs.toInt()
          ];
        }
      }
    }

    return [null, null, null, null];
  }

  void _calculatePWM(String input) {
    List<String> parts = input.split(',');
    if (parts.length == 2) {
      double? desiredFreq = double.tryParse(parts[0].trim());
      double? dutyCycle = double.tryParse(parts[1].trim());

      if (desiredFreq != null && dutyCycle != null) {
        if (desiredFreq < 0.8) {
          setState(() {
            _result = 'Düşük frekanslar desteklenemiyor';
          });
        } else {
          List<dynamic> result = calculatePwm(desiredFreq, dutyCycle / 100);
          setState(() {
            _result = result[0] != null &&
                    result[1] != null &&
                    result[2] != null
                ? 'ARR: ${result[0]}\n PSC: ${result[1]}\n CCR1: ${result[2]}\n T: ${result[3]} ms'
                : 'Uygun ARR, PSC ve CCR1 değerleri bulunamadı.';
          });
        }
      } else {
        setState(() {
          _result = 'Geçersiz giriş';
        });
      }
    } else {
      setState(() {
        _result = 'Geçersiz giriş';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PWM Calculation',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _inputController,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                labelText: 'Enter Frequency (Hz), Duty Cycle (%)',
                labelStyle: TextStyle(color: Colors.grey),
                hintText: 'e.g., 50, 50',
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.access_time, color: Colors.grey),
                fillColor: Colors.white,
                filled: true,
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                String input = _inputController.text.trim();
                _calculatePWM(input);
              },
              child: Text('Hesapla', style: TextStyle(fontSize: 25.0)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                padding: EdgeInsets.symmetric(vertical: 14.0),
                foregroundColor: Colors.white,
              ),
            ),
            SizedBox(height: 20.0),
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Color(0xffe9e7f4),
                border: Border.all(color: Theme.of(context).primaryColor),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Text(
                _result,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
