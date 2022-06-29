import 'package:accra_finder/splash.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:url_launcher/url_launcher.dart';
// import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() {
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Accra Finder',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      // home: const MyHomePage(title: 'Accra Finder'),
      home: Splash(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

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


  openwhatsapp() async {
    var whatsapp = "+233553460351";
    var whatsappURl_android =
        "whatsapp://send?phone=" + whatsapp + "&text=hello";
    var whatappURL_ios = "https://wa.me/$whatsapp?text=${Uri.parse("hello")}";
    if (Platform.isIOS) {
      // for iOS phone only
      if (await canLaunch(whatappURL_ios)) {
        await launch(whatappURL_ios, forceSafariVC: false);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: new Text("whatsapp no installed")));
      }
    } else {
      // android , web
      if (await canLaunch(whatsappURl_android)) {
        await launch(whatsappURl_android);
      } else {
        // ScaffoldMessenger.of(context)
        //     .showSnackBar(SnackBar(content: new Text("whatsapp no installed")));
        await launch(whatsappURl_android);
      }
    }
  }

  Future<void> _loadurl(
      WebViewController controller, BuildContext context) async {
    await controller.loadUrl(myurl);
  }


  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  var myurl ='https://accrafinder.info/';
  final Completer<WebViewController> _controller = Completer <WebViewController>();
  late WebViewController mycontroller;

  @override
  void initState() {
    super.initState();
    myurl = 'https://accrafinder.info/';
    
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
        // appBar: AppBar(
        //   // Here we take the value from the MyHomePage object that was created by
        //   // the App.build method, and use it to set our appbar title.
        //   title: Text(widget.title),
        // ),

        bottomNavigationBar: ConvexAppBar(
          backgroundColor: Colors.orange,
          items: [
            TabItem(icon: Icons.home, title: 'Home'),
            TabItem(icon: Icons.add, title: 'Publish'),
            TabItem(icon: Icons.message, title: 'Support'),
          ],
          initialActiveIndex: 0, //optional, default as 0
          onTap: (int i) async{
           print('click index=$i');
           switch (i) {
             case  0:
               setState(() {
                 myurl ='https://accrafinder.info/';
               }); 
               print(myurl);
                 mycontroller.loadUrl(myurl);
                 

               break;
            case 1:
              setState(() {
                myurl = 'https://accrafinder.info/my-ads/';
              });
              print(myurl);
              mycontroller.loadUrl(myurl);
              break;  
            case 2 :

            // setState(() {
            //     myurl = 'https://accrafinder.info/my-ads/';
            //   });
            //   print(myurl);
            //   mycontroller.loadUrl(myurl);

            openwhatsapp();

              break;

             default:
           }

          }
            
        ),
        body: SafeArea(
          child: WebView(
            initialUrl: myurl,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (mycontroller) {
              this.mycontroller = mycontroller;
        },
            onProgress: (int progress) {
              print('WebView is loading (progress : $progress%)');
            },
            navigationDelegate: (NavigationRequest request) {
              if (request.url.startsWith('https://accrafinder.info/')) {
                print('allowing navigation to $request');
                return NavigationDecision.navigate;
              }

              print('blocking navigation to $request}');
              return NavigationDecision.prevent;
            },
            onPageStarted: (String url) {
              print('Page started loading: $url');
            },
            onPageFinished: (String url) {
              print('Page finished loading: $url');
            },
            gestureNavigationEnabled: true,
            backgroundColor: const Color(0x00000000),
          ),
        ) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
