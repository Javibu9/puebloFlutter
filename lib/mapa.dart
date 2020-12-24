import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

import 'package:proyecto_pueblo/Util/Global.dart';

class Mapa extends StatefulWidget {

  @override
  _MapaState createState() => _MapaState();
}

class _MapaState extends State<Mapa> {
  Completer<GoogleMapController> _completer = Completer();
  List codigos = new List();

  MediaQueryData queryData;
  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);
    return FutureBuilder(
      future: DefaultAssetBundle.of(context)
      .loadString('assets/qrs.json'),
      builder: (context, snapshot){
        if(snapshot.hasData){
          codigos = json.decode(snapshot.data.toString());
          return GoogleMap(
            //mapType: MapType.hybrid,
            initialCameraPosition: CameraPosition(
                target: LatLng(40.842047,-4.7703047),
                zoom: 16
            ),
            markers: _marcadores(),

            /*onMapCreated: (GoogleMapController controller){
            _completer.complete(controller);
          }*/
          );
        } else if (snapshot.hasError) {
          return Text("errror");
        } else {
          //animacion por que tarda en leer el json
          return CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow),
          );
        }
      },
    );
  }

  Set<Marker> _marcadores(){
    var tmap = Set<Marker>();
    if(Global.todosMarcadores == true){
      int i = 0;

      for(var cod in codigos){
        if (codigos[i]['direccion'] != "nulo"){
          annadirMarcador(tmap, i.toString(), codigos[i]['direccion']);
        }
        i++;
      }
    }else{
      print(Global.posicionMapa);
      annadirMarcador(tmap, "1", codigos[Global.posicionMapa]['direccion']);
    }

    return tmap;
  }

  Set<Marker> annadirMarcador(Set<Marker> tmap, String id, String direccion) {
    var partir = direccion.split(",");
    tmap.add(Marker(
      markerId: MarkerId(id),
      position: LatLng(double.parse(partir[0]), double.parse(partir[1]))
    ));
    return tmap;
  }
}
