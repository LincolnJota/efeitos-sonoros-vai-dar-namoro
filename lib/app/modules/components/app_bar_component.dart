import 'package:akar_icons_flutter/akar_icons_flutter.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:efeitos_sonoros_vai_dar_namoro/app/modules/utils/download_web_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../utils/share_utils.dart';

class AppBarComponent extends StatelessWidget implements PreferredSizeWidget {
  const AppBarComponent(
      {Key? key, required this.switchListPressed, required this.listIcon})
      : super(key: key);
  final void Function()? switchListPressed;
  final IconData listIcon;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: [
        IconButton(
          icon: const Icon(
            AkarIcons.network,
            color: Colors.white,
          ),
          onPressed: !kIsWeb
              ? ShareUtils.shareApp
              : () => DownloadUtils.shareApp(context),
        ),
        IconButton(
          onPressed: switchListPressed,
          icon: Icon(listIcon),
        ),
      ],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(10),
        ),
      ),

      flexibleSpace: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(10),
          ),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.pinkAccent.shade400,
              const Color.fromARGB(255, 212, 18, 57),
            ],
          ),
        ),
      ),
      //shape: const RoundedRectangleBorder(),
      backgroundColor: Colors.pinkAccent.shade400,
      title: const AutoSizeText(
        'EFEITOS SONOROS VAI DAR NAMORO',
        maxFontSize: 17,
        minFontSize: 14,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
