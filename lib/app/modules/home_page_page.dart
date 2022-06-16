import 'package:akar_icons_flutter/akar_icons_flutter.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:efeitos_sonoros_vai_dar_namoro/app/modules/components/app_bar_component.dart';
import 'package:efeitos_sonoros_vai_dar_namoro/app/modules/components/sound_listile.dart';
import 'package:efeitos_sonoros_vai_dar_namoro/app/modules/utils/ad_state.dart';
import 'package:efeitos_sonoros_vai_dar_namoro/app/modules/utils/download_web_utils.dart';
import 'package:efeitos_sonoros_vai_dar_namoro/app/modules/utils/share_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../shared/consts.dart';
import 'components/card_audio_component.dart';

enum ListType {
  listView,
  gridView,
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  static final AudioPlayer _audioPlayer = AudioPlayer();
  final AudioCache _audioCache = AudioCache(fixedPlayer: _audioPlayer);
  static const AdRequest request =
      AdRequest(keywords: ['musica', 'efeitos sonoros', 'engraçado']);
  bool _isPlaying = false;

  ListType _listType = ListType.listView;
  BannerAd? _banner;
  InterstitialAd? _interstitial;
  int _adsIndex = 0;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (kIsWeb) return;

    final adState = Provider.of<AdState>(context);
    adState.initialization.then((status) {
      setState(() {
        _banner = BannerAd(
            size: AdSize.banner,
            adUnitId: bannerUnitId,
            listener: AdState.adListener,
            request: const AdRequest())
          ..load();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) _createInterstitial();
    _initAudio();
    _showInfoDialog();
  }

  void _initAudio() async {
    for (final AudioInfo audio in soundList) {
      _audioCache.load('audio/${audio.sound}.mp3');
    }
  }

  @override
  void dispose() {
    if (kIsWeb) {
      _audioPlayer.dispose();
      _audioCache.clearAll();
      super.dispose();
      return;
    }

    _interstitial!.dispose();
    _banner!.dispose();
    _audioPlayer.dispose();
    _audioCache.clearAll();
    super.dispose();
  }

  void _showInterstitial() {
    if (_interstitial == null) {
      print(
          'Ocorreu uma tentativa de mostrar um interstitial, mas ainda não foi carregado.');
      return;
    }

    _interstitial!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        print('Ad mostrou o conteúdo em tela cheia');
      },
      onAdDismissedFullScreenContent: (ad) {
        print('Ad fechou o conteúdo em tela cheia');
        _createInterstitial();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        print('Ad falhou ao mostrar o conteúdo em tela cheia: $error');
        _createInterstitial();
      },
    );
    _interstitial!.show();
    _interstitial = null;
  }

  void _createInterstitial() {
    InterstitialAd.load(
      adUnitId: interstitialAds,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitial = ad;
          print('Ad interstitial loaded');
        },
        onAdFailedToLoad: (error) {
          print('Ad interstitial failed to load: $error');
        },
      ),
    );
  }

  void _addAdCount() {
    _adsIndex++;
    print('clicks: $_adsIndex');
    if (_adsIndex >= 8) {
      _showInterstitial();
      _adsIndex = 0;
    }
  }

  void _play(String soundName) async {
    _addAdCount();
    _audioPlayer.stop();
    try {
      setState(() {
        _isPlaying = true;
      });

      _audioPlayer.onPlayerStateChanged.listen((event) {
        if (event == PlayerState.COMPLETED) {
          setState(() {
            _isPlaying = false;
          });
        }
      });

      await _audioCache.play('audio/$soundName.mp3');
    } catch (e) {
      Get.snackbar('ERRO', 'Erro ao carregar o audio');
    }
  }

  void _showInfoDialog() {
    Future.delayed(const Duration(seconds: 2), () {
      if (kIsWeb) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text(
              'Efeitos Sonoros Vai Dar Namoro',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: 'Desenvolvido por: ',
                      ),
                      TextSpan(
                        text: 'LincolnJota | Capiense Team',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Contato: ',
                        style: TextStyle(color: Colors.black),
                      ),
                      TextSpan(
                        text: 'capiense.team@gmail.com',
                        style: const TextStyle(color: Colors.blue),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            launchUrlString('mailto:capiense.team@gmail.com');
                          },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'App na Play Store: ',
                        style: TextStyle(color: Colors.black),
                      ),
                      TextSpan(
                        text: 'clique aqui',
                        style: const TextStyle(color: Colors.blue),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            launchUrlString(
                                'https://play.google.com/store/apps/details?id=com.capiense.efeitos_sonoros_vai_dar_namoro');
                          },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Projeto no github: ',
                        style: TextStyle(color: Colors.black),
                      ),
                      TextSpan(
                        text: 'clique aqui',
                        style: const TextStyle(color: Colors.blue),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            launchUrlString(
                                'https://github.com/LincolnJota/efeitos-sonoros-vai-dar-namoro');
                          },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Caso queira fazer alguma doação, entra em contato no email',
                  style: TextStyle(
                      color: Color.fromARGB(255, 5, 114, 129),
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                const Text('2022 © Capiense Team'),
              ],
            ),
            actions: [
              ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('fechar')),
            ],
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print('build!');
    final size = MediaQuery.of(context).size;

    bool isMobile() => size.width < 850;

    bool isTablet() =>
        MediaQuery.of(context).size.width < 1100 && size.width >= 850;

    bool isDesktop() => size.width >= 1100;

    return Scaffold(
      appBar: AppBarComponent(
        switchListPressed: () {
          setState(() {
            switch (_listType) {
              case ListType.listView:
                _listType = ListType.gridView;
                break;
              case ListType.gridView:
                _listType = ListType.listView;
                break;
              default:
                _listType = ListType.gridView;
                break;
            }
          });
        },
        listIcon: _listType == ListType.listView
            ? AkarIcons.text_align_justified
            : AkarIcons.grid,
      ),
      body: Column(
        children: [
          Expanded(
            child: _listType == ListType.listView
                ? ListView.separated(
                    physics: const ClampingScrollPhysics(),
                    separatorBuilder: (context, index) => const Divider(
                      height: 4,
                    ),
                    padding: const EdgeInsets.only(top: 2, left: 2, right: 2),
                    itemCount: soundList.length,
                    itemBuilder: (context, index) => AudioListTile(
                      audioInfo: soundList[index],
                      playPressed: () => _play(soundList[index].sound),
                      iconAction: const Icon(
                          !kIsWeb ? AkarIcons.network : AkarIcons.download),
                      actionPressed: () => !kIsWeb
                          ? ShareUtils.shareAudio(soundList[index].sound)
                          : DownloadUtils.downloadAudio(soundList[index].sound),
                    ),
                  )
                : GridView.count(
                    crossAxisCount: isTablet()
                        ? 3
                        : isMobile()
                            ? 2
                            : isDesktop()
                                ? 4
                                : 3,
                    childAspectRatio: MediaQuery.of(context).size.width /
                        (MediaQuery.of(context).size.height / 1.4),
                    children: soundList
                        .map((audio) => CardAudio(
                              audio,
                              playPressed: () => _play(audio.sound),
                              actionLabel: !kIsWeb ? 'Compartilhar' : 'Baixar',
                              actionIcon: !kIsWeb
                                  ? const Icon(AkarIcons.network)
                                  : const Icon(AkarIcons.download),
                              actionPressed: () => !kIsWeb
                                  ? ShareUtils.shareAudio(audio.sound)
                                  : DownloadUtils.downloadAudio(audio.sound),
                            ))
                        .toList(),
                  ),
          ),
          if (!kIsWeb)
            Visibility(
                visible: _banner != null,
                replacement: const SizedBox(height: 50),
                child: SizedBox(height: 50, child: AdWidget(ad: _banner!))),
        ],
      ),
    );
  }
}
