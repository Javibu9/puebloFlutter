import 'dart:convert';
import 'dart:core';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:proyecto_pueblo/Util/global/globals.dart' as globals;
import 'Util/Global.dart';
import 'Util/PopUp.dart';

class Consultar_info extends StatefulWidget {
  @override
  _Consultar_infoState createState() => _Consultar_infoState();
}

var _contextShowAlert;

class _Consultar_infoState extends State<Consultar_info> {
  MediaQueryData queryData;

  String _counter;
  int codigoEscaneado;
  List codigos = new List();

  Duration _duration = Duration();
  Duration _position = Duration();
  AudioPlayer advancedPlayer;
  AudioCache audioCache;
  String localFilePath;
  bool boolPlaying = false;
  bool poderParar = false;

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

  Future _scannerQR() async {
    _counter = await scanner.scan();
    print("Es esto " + _counter);
    String codigo = _counter.substring(3, 5);
    codigoEscaneado = int.parse(codigo);

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
                                audioCache.play(codigos[codigoEscaneado - 1]
                                ['audioEs'] +
                                    ".mp3");
                              } else if (Global.idioma == "en") {
                                audioCache.play(codigos[codigoEscaneado - 1]
                                ['audioEn'] +
                                    ".mp3");
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

  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);
    _contextShowAlert = context;
    //getList();
    try {} catch (e) {
      print("Error al cargar json");
    }
    return Scaffold(
        appBar: AppBar(
            title: Text("El Oso"),
            actions: <Widget>[
              PopupMenuButton<String>(
                  onSelected: popUpAccion,
                  /*
              (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: "Contact",
                child: widgetAlertDialog(globals.contacto, globals.contact),
              ),
            ],
             */

                  itemBuilder: (BuildContext context) {
                    return PopUp.opciones.map((String choice) {
                      return PopupMenuItem<String>(
                        value: widgetString(globals.contacto, globals.contact),
                        child: widgetComun(globals.contacto, globals.contact),
                      );
                    }).toList();
                  })
            ]),
        body: Container(
          child: Center(
            child: FutureBuilder(
                future: DefaultAssetBundle.of(context)
                    .loadString('assets/qrs.json'),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    codigos = json.decode(snapshot.data.toString());
                    return Column(children: [
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
                            _scannerQR();
                          }),
                      widgetComun(globals.pulsarQREs, globals.pulsarQREn)
                    ]);
                  } else if (snapshot.hasError) {
                    return Text("errror");
                  } else {
                    //animacion por que tarda en leer el json
                    return CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                    );
                  }
                }),
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

  String widgetString(String es, String en) {
    if (Global.idioma == "es") {
      return es;
    } else if (Global.idioma == "en") {
      return en;
    }
  }

  void popUpAccion(String choice) {
    if (Global.idioma == "es") {
      PopUp.contacto = "Contacto";
      popUp(choice);
    } else if (Global.idioma == "en") {
      PopUp.contacto = "Contact";
      popUp(choice);
    }
  }

  void popUp(String choice) {
    print(choice);
    print(PopUp.contacto);
    if (choice == PopUp.contacto) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.red,
          title: widgetComun(globals.contacto, globals.contact),
          content: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  children: [
                    Icon(Icons.email),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Text(globals.email),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Row(
                    children: [
                      Icon(Icons.phone),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Text(globals.telefono),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Row(
                    children: [
                      Icon(Icons.location_on),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Text(globals.ubicacion),
                      )
                    ],
                  ),
                )
              ],
            ),
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
      ).then((result) {
        print(result);
      });
    }
  }
}