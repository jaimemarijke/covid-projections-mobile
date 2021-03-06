import 'dart:convert';

import 'package:covidactnow/pages/view_faq.dart';
import 'package:covidactnow/pages/view_statelist.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:url_launcher/url_launcher.dart';

import './constants.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final FirebaseAnalytics analytics = FirebaseAnalytics();

    return MaterialApp(
      title: 'COVID ACT NOW',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics),
      ],
      home: const MyHomePage(title: 'COVID ACT NOW'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  final String faqDataSourceURL =
      "https://abe-today.firebaseio.com/can/faq.json";
  List<dynamic> faqData;

  @override
  void initState() {
    super.initState();
    _fetchDataSource();
  }

  Future<void> _fetchDataSource() async {
    faqData = jsonDecode(await http.read(faqDataSourceURL)) as List<dynamic>;
    setState(() {});
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    const drawerTilePadding = EdgeInsets.only(left: 30, bottom: 2, top: 2);
    final List<Widget> tabs = [Page_ViewStatelist(), Page_ViewFAQ(faqData)];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Image(
          image: AssetImage('assets/logo.png'),
          height: 38,
        ),
        elevation: 1,
      ),
      drawer: Drawer(
        child: Container(
            color: Colors.white,
            child: ListView(
              padding: const EdgeInsets.only(top: 30),
              children: <Widget>[
                ListTile(
                  contentPadding: drawerTilePadding,
                  title: Row(children: <Widget>[
                    Text('Endorsements  ', style: H2),
                    Icon(Icons.launch)
                  ]),
                  onTap: () {
                    launch("https://covidactnow.org/endorsements");
                  },
                ),
                ListTile(
                  contentPadding: drawerTilePadding,
                  title: Row(children: <Widget>[
                    Text('Announcements  ', style: H2),
                    Icon(Icons.launch)
                  ]),
                  onTap: () {
                    launch("https://blog.covidactnow.org/");
                  },
                ),
                ListTile(
                  contentPadding: drawerTilePadding,
                  title: Row(children: <Widget>[
                    Text('Terms of Service  ', style: H2),
                    Icon(Icons.launch)
                  ]),
                  onTap: () {
                    launch("https://covidactnow.org/terms");
                  },
                ),
              ],
            )),
      ),
      body: tabs[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            title: Text('Data'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info_outline),
            title: Text('FAQ'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
//      floatingActionButton: FloatingActionButton(
//        onPressed: _incrementCounter,
//        tooltip: 'Increment',
//        child: Icon(Icons.add),
//      ),
    );
  }
}
