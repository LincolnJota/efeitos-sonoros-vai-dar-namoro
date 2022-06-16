import 'dart:io';

import 'package:efeitos_sonoros_vai_dar_namoro/app/modules/home_page_page.dart';
import 'package:efeitos_sonoros_vai_dar_namoro/app/modules/splash_screen_page.dart';
import 'package:efeitos_sonoros_vai_dar_namoro/app/modules/utils/ad_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    final initFuture = MobileAds.instance.initialize();
    RequestConfiguration config = RequestConfiguration(
        testDeviceIds: ['0C6E706ADEF1FF1A568CDADDD28F3359']);
    MobileAds.instance.updateRequestConfiguration(config);
    final adState = AdState(initFuture);

    runApp(Provider.value(
      value: adState,
      builder: (context, child) => const MyApp(),
    ));
  } else {
    runApp(const MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Efeitos sonoros vai dar namoro',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 5, 1, 22),
        backgroundColor: const Color.fromARGB(255, 5, 1, 22),
        textTheme: GoogleFonts.abelTextTheme(),
        primarySwatch: Colors.pink,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreenPage(),
        '/inicio': (context) => const HomePage(),
      },
    );
  }
}
