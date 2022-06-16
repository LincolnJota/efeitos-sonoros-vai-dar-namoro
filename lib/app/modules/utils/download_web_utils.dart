import 'dart:convert';
import 'package:universal_html/html.dart' as html;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const text =
    'Veja e baixe os efeitos sonoros do programa Vai dar namoro: https://lincolnjota.github.io/vai-dar-namoro';

class DownloadUtils {
  DownloadUtils._();

  static Future<void> downloadAudio(String sound) async {
    final bytes = await rootBundle.load('assets/audio/$sound.mp3');
    final list = bytes.buffer.asUint8List();
    final content = base64Encode(list);
    html.AnchorElement(
        href: "data:application/octet-stream;charset=utf-16le;base64,$content")
      ..setAttribute("download", "$sound.mp3")
      ..click();
  }

  static Future<void> shareApp(BuildContext context) async {
    await Clipboard.setData(const ClipboardData(text: text));
    TextEditingController _controller = TextEditingController(text: text);

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text(
                'Compartilhar',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    //height: 80,
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: TextField(
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.black.withOpacity(0.2)),
                      maxLines: 2,
                      readOnly: true,
                      onTap: () => _controller.selection = TextSelection(
                          baseOffset: 0, extentOffset: _controller.text.length),
                      controller: _controller,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Link copiado para a área de transferência!',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              actions: [
                ElevatedButton(
                  child: const Text('OK, fechar!'),
                  onPressed: () => Navigator.pop(context),
                )
              ],
            ));
    // Get.showSnackbar(const GetSnackBar(
    //   title:
    //       'Link copiado para a área de transferência, agora basta copiar e colar pra quem você quiser!',
    //   backgroundColor: Colors.green,
    // ));
  }
}
