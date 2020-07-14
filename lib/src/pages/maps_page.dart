import 'package:QReaderApp/src/utils/utils.dart' as utils;
import 'package:flutter/material.dart';

import 'package:QReaderApp/src/bloc/scans_bloc.dart';
import 'package:QReaderApp/src/models/scan_model.dart';

class MapsPage extends StatelessWidget {

  final scansBloc = new ScansBloc();

  @override
  Widget build(BuildContext context) {
    
    scansBloc.obtenerScans();

    return StreamBuilder<List<ScanModel>>(
      stream: scansBloc.scansStream,
      builder: (BuildContext context, AsyncSnapshot<List<ScanModel>> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final scans = snapshot.data;
        if(scans.length == 0){
          return Center(
            child: Text('No hay información'),
          );
        }

        return ListView.builder(
          itemCount: scans.length,
          itemBuilder: (context, i) {
            return Dismissible(
              direction: DismissDirection.startToEnd,
              key: UniqueKey(),
              background: Container(
                margin: EdgeInsets.only(left: 20.0),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.delete),
                    SizedBox(width: 20.0,),
                    Text('Eliminar Registro')
                  ],
                ),
              ),
              onDismissed: (direction) => scansBloc.borrarScan(scans[i].id),
              child: ListTile(
                leading: Icon(Icons.map, color: Theme.of(context).primaryColor),
                title: Text(scans[i].valor),
                trailing: Icon(Icons.keyboard_arrow_right,),
                onTap: (){
                  utils.abrirScan(context, scans[i]);
                },
              ),
            );
          },
        );
      },
    );
  }
}