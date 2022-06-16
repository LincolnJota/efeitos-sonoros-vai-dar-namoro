import 'package:akar_icons_flutter/akar_icons_flutter.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:efeitos_sonoros_vai_dar_namoro/app/modules/components/card_audio_component.dart';
import 'package:flutter/material.dart';

class AudioListTile extends StatelessWidget {
  const AudioListTile({
    Key? key,
    required this.audioInfo,
    required this.playPressed,
    required this.actionPressed,
    required this.iconAction,
  }) : super(key: key);

  final AudioInfo audioInfo;
  final void Function()? playPressed;
  final Icon iconAction;
  final void Function()? actionPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
        color: Colors.white,
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.08,
        decoration: BoxDecoration(
          color: Colors.redAccent.shade400,
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 5,
              child: Container(
                padding: const EdgeInsets.all(8),
                alignment: Alignment.centerLeft,
                height: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                ),
                child: AutoSizeText(
                  audioInfo.nome,
                  maxFontSize: 22,
                  minFontSize: 19,
                  style: const TextStyle(
                    //color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                onPressed: playPressed, //() => play(soundList[index].sound),
                icon: const Icon(AkarIcons.play),
                color: Colors.white,
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 25,
                      offset: Offset(3, 5),
                      spreadRadius: 1,
                    ),
                  ],
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                    bottomLeft: Radius.circular(30),
                    topLeft: Radius.circular(30),
                  ),
                  color: Color.fromARGB(255, 212, 18, 57),
                ),
                height: double.infinity,
                child: IconButton(
                  onPressed:
                      actionPressed, //() => ShareUtils.shareAudio(soundList[index].sound),
                  icon: iconAction,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
