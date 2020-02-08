import 'package:flutter/material.dart';
import 'package:qr_reader/src/models/scan_model.dart';
import 'package:latlong/latlong.dart';
import 'package:flutter_map/plugin_api.dart';

class MapaPage extends StatefulWidget {
  @override
  _MapaPageState createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  String tipoMapa = 'streets';
  final map = new MapController();

  @override
  Widget build(BuildContext context) {
    final ScanModel scan = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('Cordeenadas QR'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.my_location),
            onPressed: () {
              map.move(scan.getLatLng(), 15);
            },
          )
        ],
      ),
      body: _crearMap(scan),
      floatingActionButton: _crearBotonFlotante(context),
    );
  }

  Widget _crearMap(ScanModel scan) {
    return FlutterMap(
      mapController: map,
      options: MapOptions(
        center: scan.getLatLng(),
        zoom: 15,
      ),
      layers: [
        _crearMapa(),
        _crearMarcadores(scan),
      ],
    );
  }

  _crearMapa() {
    return TileLayerOptions(
      urlTemplate: 'https://api.mapbox.com/v4/' +
          '{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}',
      additionalOptions: {
        'accessToken':
            'pk.eyJ1Ijoic2FyYWJyeWFuYWxlIiwiYSI6ImNrNmNvZjBxYjFlY3UzcHFiMm4xaHplbjkifQ.DhwEsdaIAz2Zeqst2p_AUg',
        'id': 'mapbox.$tipoMapa',
      },
    );
  }

  _crearMarcadores(ScanModel scanModel) {
    return MarkerLayerOptions(markers: <Marker>[
      Marker(
          width: 100.0,
          height: 100.0,
          point: scanModel.getLatLng(),
          builder: (context) => Container(
                child: Icon(
                  Icons.location_on,
                  size: 45.0,
                  color: Theme.of(context).primaryColor,
                ),
              )),
    ]);
  }

  Widget _crearBotonFlotante(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.repeat),
      backgroundColor: Theme.of(context).primaryColor,
      onPressed: () {
        if (tipoMapa == 'streets') {
          tipoMapa = 'dark';
        } else if (tipoMapa == 'dark') {
          tipoMapa = 'light';
        } else if (tipoMapa == 'light') {
          tipoMapa = 'outdoors';
        } else if (tipoMapa == 'outdoors') {
          tipoMapa = 'satellite';
        } else {
          tipoMapa = 'streets';
        }
        setState(() {});
      },
    );
  }
}
