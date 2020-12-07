//import 'dart:html';

import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
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
  int codigoEscaneado;
  List codigos = new List();

  String tipoRuta;

  String tituloEs;
  String tituloEn;
  String i;

  bool mostrarSiguiente = false;
  bool mostrarInfo = false;

  Duration _duration = Duration();
  Duration _position = Duration();
  AudioPlayer advancedPlayer;
  AudioCache audioCache;
  String localFilePath;
  bool boolPlaying = false;
  bool poderParar = false;

  bool finRuta = false;

  Future _scannerQR() async {
    SharedPreferences editor = await SharedPreferences.getInstance();
    _counter = await scanner.scan();
    print("Es esto " + _counter);
    String codigo = _counter.substring(3, 5);
    codigoEscaneado = int.parse(codigo);

    if (editor.getString("Tipo") == "libre") {
      if ((posiQR) != codigoEscaneado-15) {
        Toast.show('Escanea los codigos en orden', context,
            duration: Toast.LENGTH_SHORT);
      } else {
        setState(() {
          if (posiQR == 26) {
            finRuta = true;
          }
          mostrarSiguiente = true;
          mostrarInfo = true;

          mostrarDialog();
        });
      }
    } else if (editor.getString("Tipo") == "completa") {
      if ((posiQR) != codigoEscaneado) {
        Toast.show('Escanea los codigos en orden', context,
            duration: Toast.LENGTH_SHORT);
      } else {
        setState(() {
          if (posiQR == 26) {
            finRuta = true;
          }
          mostrarSiguiente = true;
          mostrarInfo = true;

          mostrarDialog();
        });
      }
    }


  }

  @override
  void initState() {
    super.initState();
    initPlayer();
  }

  void initPlayer() {
    advancedPlayer = AudioPlayer();
    audioCache = AudioCache(fixedPlayer: advancedPlayer, prefix: 'raw/');

    advancedPlayer.onDurationChanged.listen((Duration d) {
      setState(() {
        _duration = d;
      });
    });
    advancedPlayer.durationHandler = (p) => setState(() {
          _duration = p;
        });
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
                      return scan_info(posiQR);
                    } else if (Global.tipo == "libre") {
                      return scan_info(posiQR + 15);
                    } else {
                      if (tipoRuta == "completa") {
                        return scan_info(posiQR);
                      } else if (tipoRuta == "libre") {
                        return scan_info(posiQR + 15);
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

  void obtenerPreferencias() async {
    SharedPreferences editor = await SharedPreferences.getInstance();

    i = editor.getString("NumeroQR") ?? "No hay dato";
    print(editor.getString("NumeroQR"));
    if (int.parse(i) == 0) {
      posiQR = 1;
    } else {
      posiQR = int.parse(i);
    }

    if (editor.getString("Tipo") == "libre") {
      cantQR = 11;
    } else if (editor.getString("Tipo") == "completa") {
      cantQR = 26;
    }

    tipoRuta = editor.getString("Tipo");
  }

  Column scan_info(int posiQRtxt) {
    return Column(children: [
      widgetComun(codigos[posiQRtxt - 1]['nombreEs'],
          codigos[posiQRtxt - 1]['nombreEn']),
      //widgetRuta(codigos, posiQR),
      widgetDireccion(codigos[posiQRtxt - 1]['direccion'] ?? [], queryData),
      GestureDetector(
          child: Container(
              width: queryData.size.width / 2.5,
              child: Image.asset("images/qr.png")),
          onTap: () {
            _scannerQR();
          }),
      widgetComun(globals.textoQR_es, globals.textoQR_en),
      botonInfo(codigos, posiQRtxt - 1),
      posicionQR(posiQR, cantQR),

      Visibility(
          visible: finRuta,
          child: widgetComun(globals.felicidadesEs, globals.felicidadesEn)),
      Visibility(
        visible: finRuta,
        child: GestureDetector(
            child: Container(
              width: queryData.size.width / 2.5,
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.greenAccent,
                  borderRadius: BorderRadius.circular(20)),
              child: Center(child: widgetComun(globals.finalizarEs, globals.finalizarEn)),
            ),
            onTap: () {
              reiniciarShared();
            }),
      ),
      Row(
        children: [
          GestureDetector(
              child: Container(
                width: queryData.size.width / 2.5,
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.greenAccent,
                    borderRadius: BorderRadius.circular(20)),
                child: Center(child: widgetComun(globals.reiniciarRuta_es, globals.reiniciarRuta_en)),
              ),
              onTap: () {
                reiniciarShared();
              }),
          botonSiguiente(codigos, posiQRtxt - 1, queryData)
        ],
      )
    ]);
  }

  void reiniciarShared() async {
    SharedPreferences editor = await SharedPreferences.getInstance();

    editor.clear();
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => IntroPage()));
    Global.tipo = "No hay dato";
  }

  void mostrarDialog() {
    showDialog(
      context: _contextShowAlert,
      barrierDismissible: false,
      //StatefulBuilder para poder actualizar el dialog
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: widgetComun(codigos[codigoEscaneado - 1]['nombreEs'],
                codigos[codigoEscaneado - 1]['nombreEn']),
            content: Container(
              width: MediaQuery.of(context).size.width,
              height: 250,
              child: Column(children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  child: SingleChildScrollView(
                    child: widgetComun(codigos[codigoEscaneado - 1]['textoEs'],
                        codigos[codigoEscaneado - 1]['textoEn']),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: 3,
                              color: Colors.black,
                            ),
                          ),
                          child: Center(
                            child: Icon(
                                !boolPlaying ? Icons.play_arrow : Icons.pause),
                            //child: widgetIcono (boolPlaying)
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            if (boolPlaying == false) {
                              boolPlaying = true;
                              poderParar = true;

                              if (Global.idioma == "es") {
                                audioCache.play(
                                    codigos[codigoEscaneado - 1]['audioEs'] + ".mp3");
                              } else if (Global.idioma == "en") {
                                audioCache.play(
                                    codigos[codigoEscaneado - 1]['audioEn'] + ".mp3");
                              }
                            } else {
                              boolPlaying = false;

                              advancedPlayer.pause();
                            }
                          });
                          //mostrarDialog();
                        }),
                    GestureDetector(
                        child: Visibility(
                          visible: poderParar,
                          child: Container(
                            height: 30,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                width: 2,
                                color: Colors.black,
                              ),
                            ),
                            child: Center(
                              child: Icon(Icons.stop),
                              //child: widgetIcono (boolPlay)
                            ),
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            boolPlaying = false;
                            poderParar = false;
                          });

                          advancedPlayer.resume();
                          advancedPlayer.stop();
                          //mostrarDialog();
                        }),
                    GestureDetector(
                        child: Container(
                          height: 40,
                          child: Center(
                            child: widgetComun(globals.cerrar, globals.close),
                            //child: widgetIcono (boolPlaying)
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            Navigator.of(context).pop();
                            boolPlaying = false;
                            poderParar = false;
                          });

                          advancedPlayer.resume();
                          advancedPlayer.stop();
                          //mostrarDialog();
                        }),
                  ],
                ),
              ]),
            ),
            actions: <Widget>[
              /*FlatButton(
              child: widgetComun(globals.cerrar, globals.close),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )*/
            ],
          );
        },
      ),
    ).then((result) => print(result));
  }

/*void getList() async {
    codigos = json.decode(snapshot.data.toString());
    print(codigos[1]['nombreEs']);
  }

  Future <void> _jsonQR(BuildContext context) async {
    String data = await DefaultAssetBundle.of(context).loadString("assets/qrs.json");
    //final jsonResult = json.decode(data);
  }*/

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

  Widget botonInfo(List codigos, int posiQRtxt) {
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
                child:
                    widgetComun(globals.mostrarInfoEs, globals.mostrarInfoEn),
              ),
            ),
          ),
          onTap: () {
            mostrarDialog();
          }),
    );
  }

  Widget botonSiguiente(List codigos, int posiQRtxt, MediaQueryData queryData) {
    return Visibility(
      visible: mostrarSiguiente,
      child: GestureDetector(
          child: Container(
            width: queryData.size.width / 2.5,
            height: 50,
            decoration: BoxDecoration(
                color: Colors.greenAccent,
                borderRadius: BorderRadius.circular(20)),
            child: Center(child: Text("Siguiente")),
          ),
          onTap: () async {
            SharedPreferences editor = await SharedPreferences.getInstance();

            setState(() {
              mostrarSiguiente = false;
              mostrarInfo = false;
              if (tipoRuta == "libre") {
                posiQR += 1;
                i = posiQR.toString();
                editor.setString("NumeroQR", i);
                print(editor.getString("NumeroQR"));
              } else if (tipoRuta == "completa") {
                posiQR += 1;
                i = posiQR.toString();
                editor.setString("NumeroQR", i);
                print(editor.getString("NumeroQR"));
              }
            });
          }),
    );
  }

  Widget widgetIcono(bool boolPlay) {
    if (boolPlay == true) {
      return Icon(Icons.play_arrow);
    } else {
      return Icon(Icons.pause);
    }
  }
}
