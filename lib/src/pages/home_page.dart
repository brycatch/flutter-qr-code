import 'package:flutter/material.dart';

import 'package:qr_reader/src/bloc/scans_bloc.dart';
import 'package:qr_reader/src/models/scan_model.dart';

import 'package:qr_reader/src/pages/direciones_page.dart';
import 'package:qr_reader/src/pages/mapas_page.dart';
import 'package:qr_reader/src/utils/utils.dart' as utils;

import 'package:barcode_scan/barcode_scan.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scansBloc = new ScansBloc();

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner'),
        centerTitle: true,
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: () => scansBloc.borrarScanTODOS(),
          )
        ],
      ),
      body: _callPage(currentIndex),
      bottomNavigationBar: _crearBottomNavigationBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _crearFloatingActionButton(),
    );
  }

  Widget _crearBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        setState(() {
          currentIndex = index;
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          title: Text('Mapas'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.brightness_5),
          title: Text('Direcciones'),
        ),
      ],
    );
  }

  Widget _callPage(int paginaActual) {
    switch (paginaActual) {
      case 0:
        return MapasPage();
      case 1:
        return DireccionesPage();
      default:
        return MapasPage();
    }
  }

  Widget _crearFloatingActionButton() {
    return FloatingActionButton(
      child: Icon(Icons.filter_center_focus),
      backgroundColor: Theme.of(context).primaryColor,
      onPressed: () => _scanQR(context),
    );
  }

  void _scanQR(BuildContext context) async {
    // https://www.pichico.mx
    // geo:473255860802501, -73.89333143671877

    String futureString = '';

    try {
      futureString = await BarcodeScanner.scan();
    } catch (e) {
      futureString = e.toString();
    }

    // print('Future string $futureString');

    if (futureString != null) {
      final scan = ScanModel(valor: futureString);
      scansBloc.agregarScan(scan);

      utils.abrirScan(context, scan);
    }
  }
}
