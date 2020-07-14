import 'dart:io';

import 'package:QReaderApp/src/bloc/scans_bloc.dart';
import 'package:QReaderApp/src/models/scan_model.dart';
import 'package:QReaderApp/src/utils/utils.dart' as utils;
import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:QReaderApp/src/pages/directions_page.dart';
import 'package:QReaderApp/src/pages/maps_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scansBloc = new ScansBloc();
  int page =  0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete_forever), 
            onPressed: scansBloc.borrarAllScans 
          )
        ],
      ),
      body: _loadPage(page),
      bottomNavigationBar: _crearBottomNavigationBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.filter_center_focus),
        onPressed: ()=>_scanQR(context),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  _scanQR(BuildContext context) async {
    // geo:40.73776155468015,-74.18996229609378
    // https://fernando-herrera.com

    dynamic futureString = '';
    // dynamic futureString = 'https://fernando-herrera.com';
    // dynamic futureString2 = 'geo:21.052862050291168,-105.23537292918094';
    
    try {
      futureString = await BarcodeScanner.scan();
      print('el futureSTRING es : ${futureString.rawContent}');
    } catch (e) {
      futureString = e.toString();
    }

    if (futureString.rawContent != '') {
      final scan = ScanModel(valor: futureString.rawContent.toString());
      scansBloc.agregarScans(scan);

      if (Platform.isIOS) {
        Future.delayed(Duration(milliseconds: 750), (){
          utils.abrirScan(context, scan);
        });
      } else {
        utils.abrirScan(context, scan);
      }

    }
  }

  Widget _loadPage(int page) {
    switch(page) {
      case 0: return MapsPage();
      case 1: return DirectionsPage();

      default: return MapsPage();
    }
  }

  Widget _crearBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: page,
      onTap: (index) {
        setState(() {
          page = index;
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          title: Text('Mapas')
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.link),
          title: Text('Direcciones')
        ),
      ]
    );
  }
}