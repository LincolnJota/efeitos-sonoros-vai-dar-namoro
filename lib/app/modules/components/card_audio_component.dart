import 'package:akar_icons_flutter/akar_icons_flutter.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class AudioInfo {
  final String nome;
  final String sound;

  AudioInfo({
    required this.nome,
    required this.sound,
  });
}

class CardAudio extends StatelessWidget {
  const CardAudio(this.audioInfo,
      {Key? key,
      required this.playPressed,
      required this.actionPressed,
      required this.actionLabel,
      required this.actionIcon})
      : super(key: key);

  final void Function() playPressed;
  final void Function() actionPressed;
  final String actionLabel;
  final Icon actionIcon;
  final AudioInfo audioInfo;

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
            audioInfo.nome,
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
              onPressed: playPressed, //play(widget.audioInfo.sound),
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
              onPressed: actionPressed,
              icon: actionIcon,
              label: Text(
                actionLabel,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
