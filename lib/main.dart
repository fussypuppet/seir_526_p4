import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import './keys.dart' show FAKE_KEY;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EDP4',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Plenty of Starfish'),
    );
  }
}

class MyPlanPage extends StatefulWidget {
  @override
  MyPlanPage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyPlanPageState createState() => _MyPlanPageState();
}

class _MyPlanPageState extends State<MyPlanPage> {
  GoogleMapController mapController;
  final LatLng _center = const LatLng(47.605, -122.325);
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Plan!"),
          backgroundColor: Colors.green[700],
        ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 11.0,
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _plan() {
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (BuildContext context) {
      return MyPlanPage(title: 'Plan3');
      //Scaffold(
      //  appBar: AppBar(
      //    title: Text('Plan!'),
      //  ),
      //);
    }));
  }

  void _play() {
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Play!'),
        ),
      );
    }));
  }

  void _connect() {
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Connect!'),
        ),
      );
    }));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(icon: Icon(Icons.schedule), onPressed: _plan),
          IconButton(icon: Icon(Icons.terrain), onPressed: _play),
          IconButton(icon: Icon(Icons.mms), onPressed: _connect),
        ],
      ),
      body: Center(),
    );
  }
}
