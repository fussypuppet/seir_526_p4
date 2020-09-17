import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:flutter/semantics.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'model/photos_library_api_model.dart';
import 'pages/home_page.dart';

var theseImages = <dynamic>[
  AssetImage('images/no_photos.png'),
//AssetImage('images/18025.jpeg'),
//AssetImage('images/18125.jpeg'),
//AssetImage('images/18126.jpeg'),
//AssetImage('images/18128.jpeg'),
//AssetImage('images/18152.jpeg'),
//AssetImage('images/18154.jpeg'),
//AssetImage('images/18156.jpeg'),
//AssetImage('images/18158.jpeg'),
//AssetImage('images/18159.jpeg'),
//AssetImage('images/18320.jpeg'),
//AssetImage('images/18322.jpeg')
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
      home: MyHomePage(title: 'Tidepool Finder'),
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
    return CarouselSlider(
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
    );
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
    final thisAlbum = 'TidepoolFinderPics';
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
        title: Text('Image Picker Example'),
      ),
      body: Container(
        child: Column(
          children: [
            FlatButton(
              textColor: Colors.white,
              color: Colors.blue,
              child: Text('Add image using camera',
                  style: TextStyle(fontSize: 20.0)),
              onPressed: getImageFromCamera,
            ),
            FlatButton(
              textColor: Colors.white,
              color: Colors.blue,
              child: Text('Add image from gallery',
                  style: TextStyle(fontSize: 20.0)),
              onPressed: getImageFromGallery,
            ),
            Center(
              child: _image == null
                  ? Text('No image selected', style: TextStyle(fontSize: 20.0))
                  : Column(
                      children: [
                        Image.file(_image),
                        Text('Image added!', style: TextStyle(fontSize: 20.0)),
                      ],
                    ),
            )
          ],
        ),
      ),
      //floatingActionButton: FloatingActionButton(
      //  onPressed: getImageFromCamera,
      //  tooltip: 'Take Photo',
      //  child: Icon(Icons.add_a_photo),
      //),
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
      return HomePage();
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
      return MyGalleryPage(title: "Pick an image!");
    }));
  }

  Future populateCarousel() async {
    final List<Album> imageAlbums = await PhotoGallery.listAlbums(
      mediumType: MediumType.image,
    );
    for (var i = 0; i < imageAlbums.length; i++) {
      if (imageAlbums[i].name == 'TidepoolFinderPics') {
        final MediaPage imagePage = await imageAlbums[i].listMedia();
        if (imagePage.items.isNotEmpty) {
          theseImages.remove(AssetImage('images/no_photos.png'));
        }
        for (var j = 0; j < imagePage.items.length; j++) {
          print(
              '🟫🟫🟫🟫🟫🟫 hopefully good image info: ${imagePage.items[j]}');
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
              child: Text('Plan a trip', style: TextStyle(fontSize: 20.0)),
              onPressed: _plan,
            ),
            FlatButton(
              textColor: Colors.white,
              color: Colors.blue,
              child:
                  Text('Share your photos', style: TextStyle(fontSize: 20.0)),
              onPressed: _play,
            ),
            FlatButton(
              textColor: Colors.white,
              color: Colors.blue,
              child:
                  Text('View photo carousel', style: TextStyle(fontSize: 20.0)),
              onPressed: _connect,
            ),
            FlatButton(
              textColor: Colors.white,
              color: Colors.blue,
              child: Text('Add image to carousel',
                  style: TextStyle(fontSize: 20.0)),
              onPressed: _pick_image,
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
            //image: AssetImage('images/18025.jpeg'),
            image: AssetImage('images/el-pescador-beach-in-california.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        //child: Text(
        //    "")
      ),
    );
  }
}
