import 'package:QReaderApp/src/models/scan_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final map = new MapController();

  String tipoMapa = 'outdoors-v11';

  @override
  Widget build(BuildContext context) {
    final ScanModel scan = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('Coordenadas QR'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.my_location),
            onPressed: (){
              map.move(scan.getLatLng(), 15);
            },
          )
        ],
      ),
      body: _crearFlutterMap(scan),
      floatingActionButton: _crearFloatingActionButton(context),
    );
  }

  _crearFlutterMap(ScanModel scan) {
    return FlutterMap(
      mapController: map,
      options: MapOptions(
        center: scan.getLatLng(),
        zoom: 15.0
      ),
      layers: [
        _crearMapa(),
        _crearMarcadores(scan),
      ],
    );
  }

  _crearMapa() {
    // mapbox://styles/cebi69/ckcl1uuwf08gk1ipe8l43kgj9 - mi estilo
    return TileLayerOptions(
      urlTemplate: 'https://api.mapbox.com/styles/v1/'
      '{id}/tiles/{z}/{x}/{y}@2x?access_token={accessToken}',
      additionalOptions: {
        'accessToken' : 'pk.eyJ1IjoiY2ViaTY5IiwiYSI6ImNrY2wwM3oxNDA1MG0yc25uZTdzZWF4czMifQ.tRe9iQavIH4LnLSF9noBCA',
        'id' : 'mapbox/$tipoMapa'
      }
    );
  }

  _crearMarcadores(ScanModel scan) {
    return MarkerLayerOptions(
      markers: [
        Marker(
          width: 100.0,
          height: 100.0,
          point: scan.getLatLng(),
          builder: (BuildContext context) => Container(
            child: Icon(Icons.location_on, size: 60.0, color: Theme.of(context).primaryColor,),
          )
        )
      ]
    );
  }

  _crearFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.repeat),
      backgroundColor: Theme.of(context).primaryColor,
      onPressed: () {
        //outdoors-v11, streets-v11, light-v10, dark-v10, satellite-v9, satellite-streets-v11
        if (tipoMapa == 'streets-v11') {
          tipoMapa = 'dark-v10';
        } else if(tipoMapa == 'dark-v10') {
          tipoMapa = 'light-v10';
        } else if(tipoMapa == 'light-v10') {
          tipoMapa = 'outdoors-v11';
        } else if(tipoMapa == 'outdoors-v11') {
          tipoMapa = 'satellite-v9';
        } else if(tipoMapa == 'satellite-v9') {
          tipoMapa = 'satellite-streets-v11';
        } else {
          tipoMapa = 'streets-v11';
        }
        print(tipoMapa);
        setState(() {});
      }
    );
  }
}