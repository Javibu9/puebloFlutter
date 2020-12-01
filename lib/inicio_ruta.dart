//import 'dart:html';

import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:proyecto_pueblo/Util/global/globals.dart' as globals;
import 'package:proyecto_pueblo/Util/Global.dart';
import 'package:proyecto_pueblo/intro_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Model/Codigo.dart';
import 'Util/Global.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:toast/toast.dart';
//import 'package:media_player/media_player.dart';

class Inicio_ruta extends StatefulWidget {
  @override
  _Inicio_rutaState createState() => _Inicio_rutaState();
}

var _contextShowAlert;
//MediaPlayer mp;

class _Inicio_rutaState extends State<Inicio_ruta> {
  MediaQueryData queryData;
  String _counter, _value = "";
  int cantQR = 0;
  int posiQR = 0;
  int posiQRtxt = 0;
  Codigo nextCodigo = null;
  List codigos = new List();

  String tipoRuta;

  String tituloEs;
  String tituloEn;
  String i;

  bool mostrarInfo = false;

  Future _scannerQR() async {
    SharedPreferences editor = await SharedPreferences.getInstance();
    _counter = await scanner.scan();
    print("Es esto " + _counter);
    String codigo = _counter.substring(3, 5);
    posiQRtxt += 1;

    if ((posiQRtxt) != int.parse(codigo)) {
      Toast.show('Escanea los codigos en orden', context,
          duration: Toast.LENGTH_SHORT);
      posiQRtxt -= 1;
    } else {
      setState(() {
        if (tipoRuta == "libre") {
          posiQR = int.parse(codigo) - 14;
          posiQRtxt = int.parse(codigo);
          i = posiQR.toString();
          editor.setString("NumeroQR", i);
          print(editor.getString("NumeroQR"));
        } else if (tipoRuta == "completa") {
          posiQRtxt = int.parse(codigo);
          posiQR = int.parse(codigo);
          i = posiQR.toString();
          editor.setString("NumeroQR", i);
          print(editor.getString("NumeroQR"));
        }
        mostrarInfo = true;
      });
    }
  }

  /*Future<String> loadAsset() async {
    String jsonString = await rootBundle.loadString('assets/qrs.json');
    final jsonReponse = json.decode(jsonString);
    Codigo codigo = new Codigo.fromJson(jsonReponse);

  }*/

  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);
    _contextShowAlert = context;
    //getList();
    try {} catch (e) {
      print("Error al cargar json");
    }

    setState(() {
      obtenerPreferencias();
    });
    /*
    if (Global.tipo == "libre"){
      nextCodigo = codigos[int.parse(Global.posicionQR)];
    } else if (Global.tipo == "completa"){
      nextCodigo = codigos[int.parse(Global.posicionQR)] + 16;
    }*/
    //posicion = editor.getString("NumeroQR") ?? "No hay dato";

    //_jsonQR(context);

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
          appBar: AppBar(
            //quita el boton de atras
            automaticallyImplyLeading: false,
            title: Text("El Oso"),
          ),
          body: Container(
            child: Center(
              child: FutureBuilder(
                future: DefaultAssetBundle.of(context)
                    .loadString('assets/qrs.json'),
                // ignore: missing_return
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    codigos = json.decode(snapshot.data.toString());
                    if (Global.tipo == "comleta") {
                      return scan_info(posiQRtxt);
                    } else if (Global.tipo == "libre") {
                      return scan_info(posiQRtxt + 1);
                    } else {
                      if (tipoRuta == "completa") {
                        return scan_info(posiQRtxt);
                      } else if (tipoRuta == "libre") {
                        return scan_info(posiQRtxt + 1);
                        print("El tipo ruta es " + tipoRuta);
                      } else {}
                    }
                  } else if (snapshot.hasError) {
                    return Text("errror");
                  } else {
                    //animacion por que tarda en leer el json
                    return CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                    );
                  }
                },
              ),
            ),
          )),
    );
  }

  Column scan_info(int posiQRtxt) {
    return Column(children: [
      widgetComun(
          codigos[posiQRtxt]['nombreEs'], codigos[posiQRtxt]['nombreEn']),
      //widgetRuta(codigos, posiQR),
      widgetDireccion(codigos[posiQRtxt]['direccion'] ?? [], queryData),
      GestureDetector(
          child: Container(
              width: queryData.size.width / 2.5,
              child: Image.asset("images/qr.png")),
          onTap: () {
            _scannerQR();
          }),
      widgetComun(globals.textoQR_es, globals.textoQR_en),
      botonInfo(codigos, posiQRtxt - 1, mostrarInfo),
      posicionQR(posiQR, cantQR),
      GestureDetector(
          child: Container(
            width: queryData.size.width / 2.5,
            height: 50,
            decoration: BoxDecoration(
                color: Colors.greenAccent,
                borderRadius: BorderRadius.circular(20)),
            child: Center(child: Text("Reiniciar")),
          ),
          onTap: () {
            reiniciarShared();
          }),
    ]);
  }

  void obtenerPreferencias() async {
    SharedPreferences editor = await SharedPreferences.getInstance();

    i = editor.getString("NumeroQR") ?? "No hay dato";
    print(editor.getString("NumeroQR"));
    posiQR = int.parse(i);
    if (posiQR > 0){
      mostrarInfo = true;
    }

    if (editor.getString("Tipo") == "libre") {
      cantQR = 11;
      posiQRtxt = int.parse(i) + 14;
    } else if (editor.getString("Tipo") == "completa") {
      cantQR = 26;
      posiQRtxt = int.parse(i);
    }

    tipoRuta = editor.getString("Tipo");
  }

  void reiniciarShared() async {
    SharedPreferences editor = await SharedPreferences.getInstance();

    editor.clear();
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => IntroPage()));
    Global.tipo = "No hay dato";
  }

/*void getList() async {
    codigos = json.decode(snapshot.data.toString());
    print(codigos[1]['nombreEs']);
  }

  Future <void> _jsonQR(BuildContext context) async {
    String data = await DefaultAssetBundle.of(context).loadString("assets/qrs.json");
    //final jsonResult = json.decode(data);
  }*/
}

Widget widgetComun(String es, String en) {
  print(Global.tipo);
  if (Global.idioma == "es") {
    return Text(es);
  } else if (Global.idioma == "en") {
    return Text(en);
  }
}

Widget widgetRuta(List codigos, int posiQR) {
  if (Global.tipo == "completa") {
    return widgetComun(
        codigos[posiQR]['nombreEs'], codigos[posiQR]['nombreEn']);
  } else if (Global.tipo == "libre") {
    return widgetComun(
        codigos[posiQR + 15]['nombreEs'], codigos[posiQR + 15]['nombreEn']);
  }
}

Widget widgetDireccion(String direccion, MediaQueryData queryData) {
  if (direccion == "nulo") {
    //imagen invisible
    return GestureDetector(
        child: Visibility(
          visible: false,
          child: Container(
              width: queryData.size.width / 10,
              child: Image.asset("images/marcador.png")),
        ),
        onTap: () {});
  } else {
    //imagen visible
    return GestureDetector(
        child: Visibility(
          visible: true,
          child: Container(
              width: queryData.size.width / 10,
              child: Image.asset("images/marcador.png")),
        ),
        onTap: () {});
  }
}

Widget posicionQR(int posiQR, int cantQR) {
  return Text("" + posiQR.toString() + " / " + cantQR.toString() + "");
}

Widget botonInfo(List codigos, int posiQRtxt, bool mostrarInfo) {
  return Visibility(
    visible: mostrarInfo,
    child: GestureDetector(
        child: FractionallySizedBox(
          widthFactor: 0.6,
          child: Container(
            height: 40,
            decoration: BoxDecoration(
                color: Colors.greenAccent,
                borderRadius: BorderRadius.circular(20)),
            child: Center(
              child: widgetComun(globals.mostrarInfoEs, globals.mostrarInfoEn),
            ),
          ),
        ),
        onTap: () {
          showDialog(
            context: _contextShowAlert,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              title: widgetComun(codigos[posiQRtxt]['nombreEs'],
                  codigos[posiQRtxt]['nombreEn']),
              content: Container(
                width: MediaQuery.of(context).size.width,
                height: 250,
                child: Column(children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    child: SingleChildScrollView(
                      child: widgetComun(codigos[posiQRtxt]['textoEs'],
                          codigos[posiQRtxt]['textoEn']),
                    ),
                  ),
                  Row(

                  ),
                ]),
              ),
              actions: <Widget>[
                FlatButton(
                  child: widgetComun(globals.cerrar, globals.close),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
          ).then((result) => print(result));
        }),
  );
}
