import 'dart:io';

import 'package:akar_icons_flutter/akar_icons_flutter.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../shared/consts.dart';

class AudioInfo {
  final String nome;
  final String sound;

  AudioInfo({
    required this.nome,
    required this.sound,
  });
}

class CardAudio extends StatefulWidget {
  const CardAudio(this.audioInfo,
      {Key? key, required this.playPressed, required this.sharePressed})
      : super(key: key);

  final void Function() playPressed;
  final void Function() sharePressed;
  final AudioInfo audioInfo;

  @override
  State<CardAudio> createState() => _CardAudioState();
}

class _CardAudioState extends State<CardAudio> {
  //static final AudioPlayer _audioPlayer = AudioPlayer();
  //final AudioCache _audioCache = AudioCache(fixedPlayer: _audioPlayer);

  //AudioPlayer(mode: PlayerMode.MEDIA _PLAYER);
  //final _player = AudioPlayer();
  // bool _isPlaying = false;

  // @override
  // void initState() {
  //   super.initState();
  //   _init();
  // }

  // void _init() async {
  //   for (final AudioInfo audio in soundList) {
  //     _audioCache.load('audio/${audio.sound}.mp3');
  //   }
  //   //print(_audioCache.loadedFiles);
  // }

  // @override
  // void dispose() {
  //   _audioCache.clearAll();
  //   super.dispose();
  // }

  // void play(String soundName) async {
  //   widget.playPressed();
  //   _audioPlayer.stop();
  //   try {
  //     setState(() {
  //       _isPlaying = true;
  //     });

  //     _audioPlayer.onPlayerStateChanged.listen((event) {
  //       if (event == PlayerState.COMPLETED) {
  //         setState(() {
  //           _isPlaying = false;
  //         });
  //       }
  //     });

  //     await _audioCache.play('audio/$soundName.mp3');
  //   } catch (e) {
  //     Get.snackbar('ERRO', 'Erro ao carregar o audio');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          AutoSizeText(
            widget.audioInfo.nome,
            softWrap: true,
            maxLines: 2,
            minFontSize: 20,
            maxFontSize: 30,
            style: const TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 50,
            width: _size.width,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
                elevation: 1,
                primary: Colors.redAccent.shade400,
              ),
              onPressed: widget.playPressed, //play(widget.audioInfo.sound),
              icon: const Icon(
                AkarIcons.play,
                color: Colors.white,
              ),
              label: const Text(
                'tocar',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(
            height: 50,
            width: _size.width,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                elevation: 0,
                primary: const Color.fromARGB(255, 212, 18, 57),
              ),
              onPressed: widget.sharePressed, //async {
              // final bytes = await rootBundle
              //     .load('assets/audio/${widget.audioInfo.sound}.mp3');
              // final list = bytes.buffer.asUint8List();

              // final tempDir = await getTemporaryDirectory();
              // final file =
              //     await File('${tempDir.path}/${widget.audioInfo.sound}.mp3')
              //         .create();
              // file.writeAsBytesSync(list);

              // Share.shareFiles([(file.path)]);
              //},
              icon: const Icon(
                AkarIcons.network,
                color: Colors.white,
              ),
              label: const Text(
                'Compartilhar',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
