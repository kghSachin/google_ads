import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  late BannerAd bannerAd;
  bool isAdLoaded = false;
  String errorMsg = "";

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 10; i++) {
      _loadBannerAd();
      Future.delayed(Duration(seconds: 5));
    }
  }

  _loadBannerAd() {
    bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/6300978111',
      // adUnitId: 'ca-app-pub-3940256099942544/2934735716',
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          print("ad is loaded ${ad.responseInfo}");
          setState(() {
            isAdLoaded = true;
          });
        },
        onAdClosed: (Ad ad) {
          ad.dispose();
          print("ad is closed");
        },
        onAdClicked: (ad) {
          ad.dispose();
        },
        onAdOpened: (ad) => {ad.dispose()},
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
          setState(() {
            errorMsg = error.toString();
          });
          print(error);
        },
      ),
    )..load();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              errorMsg,
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: isAdLoaded
          ? SizedBox(
              height: 50,
              child: AdWidget(ad: bannerAd),
            )
          : const SizedBox(
              child: Text("error loading ads try"),
            ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
