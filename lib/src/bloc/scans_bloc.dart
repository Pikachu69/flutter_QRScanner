import 'dart:async';

import 'package:QReaderApp/src/bloc/validator.dart';
import 'package:QReaderApp/src/providers/db_provider.dart';

class ScansBloc with Validator{
  static final ScansBloc _singleton = new ScansBloc._internal();

  factory ScansBloc() {
    return _singleton;
  }

  ScansBloc._internal(){
    //obtener los scans de la base de datos
    obtenerScans();
  }

  final _scansStreamController = StreamController<List<ScanModel>>.broadcast();

  //Escuchar informacion del stream
  Stream<List<ScanModel>> get scansStream     => _scansStreamController.stream.transform(validarGeo);
  Stream<List<ScanModel>> get scansStreamHttp => _scansStreamController.stream.transform(validarHttp);

  dispose() {
    _scansStreamController?.close();
  }

  obtenerScans() async {
    _scansStreamController.sink.add(await DBProvider.db.getAll());
  }

  agregarScans(ScanModel scan) async {
    await DBProvider.db.newScan(scan);
    obtenerScans();
  }

  borrarScan(int id) async {
    await DBProvider.db.deleteScan(id);
    obtenerScans();
  }

  borrarAllScans() async {
    await DBProvider.db.deleteAll();
    obtenerScans();
  }
}