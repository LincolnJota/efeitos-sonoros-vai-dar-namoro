import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashScreenPage extends StatefulWidget {
  final String title;
  const SplashScreenPage({Key? key, this.title = 'SplashScreenPage'})
      : super(key: key);
  @override
  SplashScreenPageState createState() => SplashScreenPageState();
}

class SplashScreenPageState extends State<SplashScreenPage> {
  void loadingComplete(BuildContext context) async {
    Navigator.pushReplacementNamed(context, '/inicio');
  }

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(
          const Duration(seconds: 5), () => loadingComplete(context));
    });
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(flex: 1, child: Container()),
            Container(
              alignment: Alignment.center,
              width: double.infinity,
              child: const AutoSizeText(
                'EFEITOS SONOROS VAI DAR NAMORO',
                minFontSize: 20,
                maxFontSize: 40,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: _size.height * 0.070),
            SpinKitDualRing(
              color: Colors.redAccent.shade400,
            ),
            SizedBox(height: _size.height * 0.025),
            const Text(
              'Carregando...',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            Expanded(child: Container()),
            SizedBox(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  'CAPIENSE TEAM',
                  style: TextStyle(
                      letterSpacing: 2,
                      color: Colors.pinkAccent.shade400,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
