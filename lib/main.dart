import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'model/photos_library_api_model.dart';
import 'pages/home_page.dart';

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
  @override // supposed to annotate these?
  MyPlanPage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyPlanPageState createState() => _MyPlanPageState();
}

//class PoolSite {
//  String name;
//  double lat;
//  double lng;
//  PoolSite(
//    this.name,
//    this.lat,
//    this.lng,
//  );
//  void disp() {
//    print('$name, $lat, $lng');
//  }
//}

class _MyPlanPageState extends State<MyPlanPage> {
  final Map<String, Marker> _markers = {};
  final LatLng _center = const LatLng(47.605, -122.325);
  Future<void> _onMapCreated(GoogleMapController controller) async {
    //Future<void> _onMapCreated(GoogleMapController controller) async {
    //final googleOffices = await locations.getGoogleOffices();
    setState(() {
      _markers.clear();
    });
  }
  //GoogleMapController mapController;
  //final LatLng _center = const LatLng(47.605, -122.325);
  //void _onMapCreated(GoogleMapController controller) {
  //  mapController = controller;
  //}

  @override
  Widget build(BuildContext context) {
    var beachSet = <Marker>{};
    const theseBeaches = [
      ['Richmond Beach Saltwater Park', 47.7652, -122.383],
      ['Carkeek Park', 47.7119, -122.3724],
      ['Golden Gardens Park', 47.6925, -122.4029],
      ['Charles Richey Sr Viewpoint', 47.5735, -122.4164],
      ['Lincoln Park', 47.5315, -122.3929],
      ['Seahurst Ed Munro Park', 47.4695, -122.3622],
      ['Saltwater State Park', 47.3742, -122.3191],
      ['Des Moines Beach Park', 47.4048, -122.3284],
      ['Redondo Beach', 47.3486, -122.3243],
      ['Dash Point State Park', 47.317, -122.4073],
    ];
    for (var i = 0; i < theseBeaches.length; i++) {
      var marker = Marker(
        markerId: MarkerId(theseBeaches[i][0]),
        position: LatLng(theseBeaches[i][1], theseBeaches[i][2]),
        infoWindow: InfoWindow(
          title: theseBeaches[i][0],
        ),
      );
      beachSet.add(marker);
    }
    //final otherEagle = PoolSite(
    //  'Seattle Eagle',
    //  47.614172,
    //  -122.327119,
    //);
    //final otherMarker = Marker(
    //  markerId: MarkerId(otherEagle.name),
    //   position: LatLng(otherEagle.lat, otherEagle.lng),
    //   infoWindow: InfoWindow(
    //     title: otherEagle.name,
    //     snippet: otherEagle.address,
    //   ),
    //);
    // var otherSet = <Marker>{otherMarker};
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Plan!'),
          backgroundColor: Colors.green[700],
        ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 11.0,
          ),
          markers: beachSet,
        ),
      ),
    );
  }
}

class MyConnectPage extends StatefulWidget {
  MyConnectPage({Key key, this.title}) : super(key: key);
  final String title;
  @override // still not sure what I'm overriding but the app loves comments
  _MyConnectPageState createState() => _MyConnectPageState();
}

class _MyConnectPageState extends State<MyConnectPage> {
  @override // just for giggles
  var theseImages = [
    AssetImage('images/18025.jpeg'),
    AssetImage('images/18125.jpeg'),
    AssetImage('images/18126.jpeg'),
    AssetImage('images/18128.jpeg'),
    AssetImage('images/18152.jpeg'),
    AssetImage('images/18154.jpeg'),
    AssetImage('images/18156.jpeg'),
    AssetImage('images/18158.jpeg'),
    AssetImage('images/18159.jpeg'),
    AssetImage('images/18320.jpeg'),
    AssetImage('images/18322.jpeg')
  ];
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(height: 400.0),
      items: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10].map((i) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: theseImages[i],
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override // these are supposed to be annotated?
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
      return MyConnectPage(title: 'Connect!');
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
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            //image: AssetImage('images/18025.jpeg'),
            image: AssetImage('images/el-pescador-beach-in-california.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        //child: Text(
        //    "photo credit: National Park Service via www.goodfreephotos.com")
      ),
    );
  }
}
