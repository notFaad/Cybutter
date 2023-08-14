import 'package:cybutter/components/navigationrail.dart';
import 'package:cybutter/crawler/parser.dart';
import 'package:cybutter/pages/download_page.dart';
import 'package:cybutter/pages/media_page.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    minimumSize: Size(850, 700),
    size: Size(850, 700),
    center: true,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.normal,
    windowButtonVisibility: true,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    //await windowManager.setIcon("assets/logo.svg");
    await windowManager.show();
    await windowManager.focus();
    await windowManager.setTitle("C Y B U T T E R : Player & Downloader");
  });
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
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        primaryColor: Color.fromARGB(255, 183, 142, 255),
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        useMaterial3: true,
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 183, 142, 255))
                .copyWith(background: Color.fromARGB(193, 46, 34, 52)),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  int _select = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).backgroundColor.withBlue(55),
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Wrap(children: [
          Text(
            "| C Y B U T T E R  |  ",
            style:
                TextStyle(color: Theme.of(context).primaryColor, fontSize: 24),
          ),
          InkWell(
            hoverColor: Theme.of(context).primaryColor.withAlpha(35),
            child: Text("A cyberdrop downloader & Media Player",
                style: TextStyle(
                    color: Colors.blue.shade800,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.blue.shade800)),
            onHover: (value) {},
            onTap: () {
              launchUrl(Uri.https("cyberdrop.me", ""));
            },
          )
        ], alignment: WrapAlignment.center),
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Row(
            children: [
              Navigationrail(
                selected: _select,
                callback: (value) {
                  setState(() => {_select = value});
                },
              ),
              if (_select == 1) MediaPage() else DownloadPage()
            ],
          )),
      // Center is a layout widget. It takes a single child and positions it
      // in the middle of the parent

      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
