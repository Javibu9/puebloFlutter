import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:proyecto_pueblo/Util/global/globals.dart' as globals;
import 'Util/Global.dart';

class Consultar_info extends StatefulWidget {
  @override
  _Consultar_infoState createState() => _Consultar_infoState();
}

class _Consultar_infoState extends State<Consultar_info> {
  MediaQueryData queryData;

  String _counter;
  int numCodigo = 0;
  List codigos = new List();

  Future _scannerQR() async {
    _counter = await scanner.scan();
    print("Es esto " + _counter);
    numCodigo = int.parse(_counter.substring(3, 5));
  }

  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);
    //getList();
    try {} catch (e) {
      print("Error al cargar json");
    }
    return Scaffold(
        appBar: AppBar(
          title: Text("El Oso"),
        ),
        body: Container(
          child: Center(
            child: Column(children: [
              GestureDetector(
                  child: Container(
                      width: queryData.size.width / 2.5,
                      child: Image.asset("images/marcador.png")),
                  onTap: () {}),
              widgetComun(globals.localizarEs, globals.localizarEn),
              GestureDetector(
                  child: Container(
                      width: queryData.size.width / 2.5,
                      child: Image.asset("images/qr.png")),
                  onTap: () {
                    //_scannerQR();
                  }),
              widgetComun(globals.pulsarQREs, globals.pulsarQREn)
              /*child: FutureBuilder(
            future:
                DefaultAssetBundle.of(context).loadString('assets/qrs.json'),
            // ignore: missing_return
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                codigos = json.decode(snapshot.data.toString());

                ]);
              } else if (snapshot.hasError) {
                return Text("errror");
              } else {
                //animacion por que tarda en leer el json
                return CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                );
              }
            },
          ),*/
            ]),
          ),
        ));
  }

  Widget widgetComun(String es, String en) {
    print(Global.tipo);
    if (Global.idioma == "es") {
      return Text(es);
    } else if (Global.idioma == "en") {
      return Text(en);
    }
  }
}
