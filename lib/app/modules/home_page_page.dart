import 'package:akar_icons_flutter/akar_icons_flutter.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:efeitos_sonoros_vai_dar_namoro/app/modules/components/app_bar_component.dart';
import 'package:efeitos_sonoros_vai_dar_namoro/app/modules/components/sound_listile.dart';
import 'package:efeitos_sonoros_vai_dar_namoro/app/modules/utils/ad_state.dart';
import 'package:efeitos_sonoros_vai_dar_namoro/app/modules/utils/share_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

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
    _createInterstitial();
    _initAudio();
  }

  void _initAudio() async {
    for (final AudioInfo audio in soundList) {
      _audioCache.load('audio/${audio.sound}.mp3');
    }
  }

  @override
  void dispose() {
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

  void addAdCount() {
    _adsIndex++;
    print('clicks: $_adsIndex');
    if (_adsIndex >= 8) {
      _showInterstitial();
      _adsIndex = 0;
    }
  }

  void play(String soundName) async {
    addAdCount();
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

  @override
  Widget build(BuildContext context) {
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
                      playPressed: () => play(soundList[index].sound),
                      sharePressed: () =>
                          ShareUtils.shareAudio(soundList[index].sound),
                    ),
                  )
                : GridView.count(
                    crossAxisCount: 2,
                    childAspectRatio: 1.0,
                    children: soundList
                        .map((audio) => CardAudio(
                              audio,
                              playPressed: () => play(audio.sound),
                              sharePressed: () =>
                                  ShareUtils.shareAudio(audio.sound),
                            ))
                        .toList(),
                  ),
          ),
          Visibility(
              visible: _banner != null,
              replacement: const SizedBox(height: 50),
              child: SizedBox(height: 50, child: AdWidget(ad: _banner!))),
        ],
      ),
    );
  }
}
