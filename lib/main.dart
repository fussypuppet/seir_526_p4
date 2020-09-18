import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:flutter/semantics.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'model/photos_library_api_model.dart';
import 'pages/home_page.dart';

var theseImages = <dynamic>[
  AssetImage('images/no_photos.png'),
];

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final apiModel = PhotosLibraryApiModel();
  apiModel.signInSilently();
  runApp(
    ScopedModel<PhotosLibraryApiModel>(model: apiModel, child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EDP4',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Tide Pool Finder'),
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

class _MyPlanPageState extends State<MyPlanPage> {
  final Map<String, Marker> _markers = {};
  final LatLng _center = const LatLng(47.605, -122.325);
  Future<void> _onMapCreated(GoogleMapController controller) async {
    setState(() {
      _markers.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    var beachSet = <Marker>{};
    const theseBeaches = [
      [
        'Richmond Beach Saltwater Park',
        47.7652,
        -122.383,
        '2021 NW 190th Street Shoreline, WA 98177',
        'https://www.shorelinewa.gov/Home/Components/FacilityDirectory/FacilityDirectory/1059/135',
      ],
      [
        'Carkeek Park',
        47.7119,
        -122.3724,
        '950 NW Carkeek Park Rd., Seattle, WA 98177',
        'https://www.seattle.gov/parks/find/parks/carkeek-park',
      ],
      [
        'Golden Gardens Park',
        47.6925,
        -122.4029,
        '8498 Seaview Pl. NW, Seattle, WA 98117',
        'https://www.seattle.gov/parks/find/parks/golden-gardens-park',
      ],
      [
        'Charles Richey Sr Viewpoint',
        47.5735,
        -122.4164,
        '3521 Beach Dr. SW, Seattle, WA 98116',
        'https://www.seattle.gov/parks/find/parks/charles-richey-sr-viewpoint',
      ],
      [
        'Lincoln Park',
        47.5315,
        -122.3929,
        '8011 Fauntleroy Way SW, Seattle, WA 98136',
        'https://www.seattle.gov/parks/find/parks/lincoln-park',
      ],
      [
        'Seahurst Ed Munro Park',
        47.4695,
        -122.3622,
        '1600 SW Seahurst Park Rd, Burien, WA 98166',
        'https://www.burienwa.gov/cms/one.aspx?portalId=11046019&pageId=12542296',
      ],
      [
        'Saltwater State Park',
        47.3742,
        -122.3191,
        '25205 8th Place S, Des Moines, WA 98198',
        'https://parks.state.wa.us/578/Saltwater',
      ],
      [
        'Des Moines Beach Park',
        47.4048,
        -122.3284,
        '22030 Cliff Ave. S, Des Moines, WA 98198',
        'https://www.seattlesouthside.com/listing/des-moines-beach-park/1291/',
      ],
      [
        'Redondo Beach',
        47.3486,
        -122.3243,
        'Redondo Beach Dr S, Des Moines, WA 98198',
        'https://www.seattlesouthside.com/listing/redondo-pier-boat-launch-%26-boardwalk/1374/',
      ],
      [
        'Dash Point State Park',
        47.317,
        -122.4073,
        '5700 S.W. Dash Point Rd, Federal Way, WA 98023',
        'https://www.parks.state.wa.us/496/Dash-Point',
      ],
    ];

    _launchURL(String thisURL) async {
      var url = thisURL;
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        print('🟥🟥🟥🟥🟥🟥Could not launch $url');
      }
    }

    for (var i = 0; i < theseBeaches.length; i++) {
      var marker = Marker(
          markerId: MarkerId(theseBeaches[i][0]),
          position: LatLng(theseBeaches[i][1], theseBeaches[i][2]),
          infoWindow: InfoWindow(
            title: theseBeaches[i][0],
          ),
          onTap: () {
            print(
                'Marker for ${theseBeaches[i][0]} clicked with context $context!');
            showModalBottomSheet(
                context: context,
                builder: (context) => Container(
                    height: MediaQuery.of(context).size.height * .25,
                    color: Colors.white,
                    child: Column(children: [
                      Text(theseBeaches[i][0],
                          style: TextStyle(fontSize: 20.0)),
                      Text(theseBeaches[i][3],
                          style: TextStyle(fontSize: 17.0)),
                      FlatButton(
                        textColor: Colors.white,
                        color: Colors.blue,
                        child: Text('Open in Google Maps',
                            style: TextStyle(fontSize: 20.0)),
                        onPressed: () => _launchURL(
                            'https://www.google.com/maps/search/?api=1&query=${Uri.encodeFull(theseBeaches[i][3])}'),
                      ),
                      FlatButton(
                          textColor: Colors.white,
                          color: Colors.blue,
                          child: Text('View Website',
                              style: TextStyle(fontSize: 20.0)),
                          onPressed: () => _launchURL(theseBeaches[i][4]))
                    ])));
          });
      beachSet.add(marker);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Nearby Tide Pool Sites'),
        backgroundColor: Colors.blue[700],
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 11.0,
        ),
        markers: beachSet,
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
  Widget build(BuildContext context) {
    var theseImagesIndices = new List();
    for (var index = 0; index < theseImages.length; index++) {
      theseImagesIndices.add(index);
    }
    return Scaffold(
        appBar: AppBar(
          title: Text('Photo Carousel'),
        ),
        body: Container(
          child: Center(
            child: CarouselSlider(
              options: CarouselOptions(height: 400.0),
              items: theseImagesIndices.map((i) {
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
            ),
          ),
          decoration: BoxDecoration(
            color: Colors.black,
          ),
        ));
  }
}

class MyGalleryPage extends StatefulWidget {
  MyGalleryPage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyGalleryPageState createState() => _MyGalleryPageState();
}

class _MyGalleryPageState extends State<MyGalleryPage> {
  File _image;
  FileImage _fileImage;
  String _saveResult;
  final picker = ImagePicker();

  Future getImageFromCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      _image = File(pickedFile.path);
      _fileImage = FileImage(_image);
    });
    if (theseImages[0] == AssetImage('images/no_photos.png')) {
      theseImages[0] = _fileImage;
    } else {
      theseImages.add(_fileImage);
    }
    final thisAlbum = 'TidePoolFinder';
    final awaitResult =
        await GallerySaver.saveImage(pickedFile.path, albumName: thisAlbum);
    print('🔴🔴🔴🔴 awaitResult' +
        awaitResult.toString() +
        ' and pickedFile.path: ' +
        pickedFile.path);
  }

  Future getImageFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(pickedFile.path);
      _fileImage = FileImage(_image);
    });
    if (theseImages[0] == AssetImage('images/no_photos.png')) {
      theseImages[0] = _fileImage;
    } else {
      theseImages.add(_fileImage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Photo'),
      ),
      body: Container(
        child: Column(
          children: [
            FlatButton(
              textColor: Colors.white,
              color: Colors.blue,
              child: Text('Add photo using camera',
                  style: TextStyle(fontSize: 20.0)),
              onPressed: getImageFromCamera,
            ),
            FlatButton(
              textColor: Colors.white,
              color: Colors.blue,
              child: Text('Import photo from gallery',
                  style: TextStyle(fontSize: 20.0)),
              onPressed: getImageFromGallery,
            ),
            if (_image != null) Image.file(_image, width: 100),
            Center(
                child: _image != null
                    ? Text('Image added!', style: TextStyle(fontSize: 20.0))
                    : Text('No image selected',
                        style: TextStyle(fontSize: 20.0))),
          ],
        ),
      ),
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
    }));
  }

  void _play() {
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (BuildContext context) {
      return HomePage(); // note that this is not MYHomePage
      //I think HomePage is a google photos API object
    }));
  }

  void _connect() {
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (BuildContext context) {
      return MyConnectPage(title: 'Connect!');
    }));
  }

  void _pick_image() {
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (BuildContext context) {
      return MyGalleryPage(title: 'Pick an image!');
    }));
  }

  Future populateCarousel() async {
    final List<Album> imageAlbums = await PhotoGallery.listAlbums(
      mediumType: MediumType.image,
    );
    for (var i = 0; i < imageAlbums.length; i++) {
      if (imageAlbums[i].name == 'TidePoolFinder') {
        final MediaPage imagePage = await imageAlbums[i].listMedia();
        if (imagePage.items.isNotEmpty) {
          theseImages.remove(AssetImage('images/no_photos.png'));
        }
        for (var j = 0; j < imagePage.items.length; j++) {
          var thisImageFile =
              await PhotoGallery.getFile(mediumId: imagePage.items[j].id);
          var thisFileImage = FileImage(thisImageFile);
          theseImages.add(thisFileImage);
        }
      }
    }
  }

  Widget build(BuildContext context) {
    if (theseImages[0] == AssetImage('images/no_photos.png')) {
      populateCarousel();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: Column(
          children: [
            FlatButton(
              textColor: Colors.white,
              color: Colors.blue,
              child: Text('Plan Trip', style: TextStyle(fontSize: 20.0)),
              onPressed: _plan,
            ),
            FlatButton(
              textColor: Colors.white,
              color: Colors.blue,
              child: Text('Add Photo', style: TextStyle(fontSize: 20.0)),
              onPressed: _pick_image,
            ),
            FlatButton(
              textColor: Colors.white,
              color: Colors.blue,
              child: Text('View photos', style: TextStyle(fontSize: 20.0)),
              onPressed: _connect,
            ),
            FlatButton(
              textColor: Colors.white,
              color: Colors.blue,
              child: Text('Share photos', style: TextStyle(fontSize: 20.0)),
              onPressed: _play,
            ),
            Expanded(
              child: Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                      'photo credit: National Park Service via www.goodfreephotos.com',
                      style: TextStyle(color: Colors.white))),
            )
          ],
        ),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/el-pescador-beach-in-california.jpg'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
