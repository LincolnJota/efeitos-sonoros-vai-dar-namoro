import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ShareUtils {
  ShareUtils._();

  static Future<void> shareAudio(String sound) async {
    final bytes = await rootBundle.load('assets/audio/$sound.mp3');
    final list = bytes.buffer.asUint8List();

    final tempDir = await getTemporaryDirectory();
    final file = await File('${tempDir.path}/$sound.mp3').create();
    file.writeAsBytesSync(list);
    Share.shareFiles([(file.path)]);
  }

  static Future<void> shareApp() async {
    Share.share(
      'Baixe os efeitos sonoros do programa Vai dar namoro: https://play.google.com/store/apps/details?id=com.capiense.efeitos_sonoros_vai_dar_namoro',
    );
  }
}
