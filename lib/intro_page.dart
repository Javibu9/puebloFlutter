import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'file:///C:/Users/javie/Documents/Flutter/proyectoPueblo/proyecto_pueblo/lib/Util/PopUp.dart';
import 'package:proyecto_pueblo/Util/Global.dart';
import 'package:proyecto_pueblo/consultar_info.dart';
import 'file:///C:/Users/javie/Documents/Flutter/proyectoPueblo/proyecto_pueblo/lib/Util/global/globals.dart'
    as globals;
import 'package:proyecto_pueblo/inicio_ruta.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroPage extends StatefulWidget {
  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  MediaQueryData queryData;
  SharedPreferences sharedPreferences;

  String tipoRuta = "";

  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);
    //un controler que sirve para coger el dato de widgets //*********//
    //var txt = TextEditingController();
    //obtenerPreferencias();
    print("Puta ruta " + tipoRuta);
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
            //quita el boton de atras
            automaticallyImplyLeading: false,
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
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 30,
            ),
            child: Column(
              children: [
                if (Global.idioma == "es")
                  Text(
                    globals.cabezal,
                    style: TextStyle(fontSize: 24),
                  ),
                if (Global.idioma == "en")
                  Text(
                    globals.header,
                    style: TextStyle(fontSize: 24),
                  ),
                const SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    //own custom button
                    GestureDetector(
                        child: Container(
                          width: queryData.size.width / 2.5,
                          height: 50,
                          decoration: BoxDecoration(
                              color: Colors.greenAccent,
                              borderRadius: BorderRadius.circular(20)),
                          child: Center(
                            child: widgetIdiomas(
                                globals.espannol, globals.spanish),
                          ),
                        ),
                        onTap: () {
                          if (Global.idioma == "en") {
                            setState(() {
                              //print("idioma español");
                              Global.idioma = "es";
                            });
                          }
                        }),
                    GestureDetector(
                        child: Container(
                          width: queryData.size.width / 2.5,
                          height: 50,
                          decoration: BoxDecoration(
                              color: Colors.greenAccent,
                              borderRadius: BorderRadius.circular(20)),
                          child: Center(
                            child:
                                widgetIdiomas(globals.ingles, globals.english),
                          ),
                        ),
                        onTap: () {
                          if (Global.idioma == "es") {
                            setState(() {
                              //print("idioma ingles");
                              Global.idioma = "en";
                            });
                          }
                        }),
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
                widgetTexto(globals.texto1, globals.text1),
                const SizedBox(
                  height: 40,
                ),
                widgetTexto(globals.texto2, globals.text2),
                const SizedBox(
                  height: 30,
                ),
                GestureDetector(
                    child: Container(
                      width: queryData.size.width / 2.5,
                      height: 50,
                      child: Image.asset("images/marcador.png"),
                    ),
                    onTap: () {}),
                GestureDetector(
                    child: Container(
                      width: queryData.size.width / 2.5,
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.greenAccent,
                          borderRadius: BorderRadius.circular(20)),
                      child: Center(
                        child: widgetIdiomas(globals.consultarInfoEs, globals.consultarInfoEn),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => Consultar_info()));
                    }),
                widgetBotonComenzar(),

              ], // Children
            ),
          ),
        ),
      ),
    );
  }


  Text widgetText(String es, String en) {
    //meto el widget en una funcion
    return Text((() {
      if (Global.idioma == "es") {
        return es;
      } else if (Global.idioma == "en") {
        return en;
      }
    })());
  }

  Widget widgetIdiomas(String es, String en) {
    //meto el widget en una funcion
    if (Global.idioma == "es") {
      return Text(
        es,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.black,
        ),
      );
    } else if (Global.idioma == "en") {
      return Text(
        en,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.black,
        ),
      );
    }
  }

  Widget widgetTexto(String es, String en) {
    //meto el widget en una funcion
    if (Global.idioma == "es") {
      return Text(
        es,
        textAlign: TextAlign.center,
      );
    } else if (Global.idioma == "en") {
      return Text(
        en,
        textAlign: TextAlign.center,
      );
    }
  }

  Widget widgetComenzar(String es, String en) {
    //meto el widget en una funcion
    if (Global.idioma == "es") {
      return Text(
        es,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
        ),
      );
    } else if (Global.idioma == "en") {
      return Text(
        en,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
        ),
      );
    }
  }

  Widget widgetComun(String es, String en) {
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

  Future<void> _tipoLocal(String tipo) async {
    SharedPreferences editor = await SharedPreferences.getInstance();

    editor.setString("Tipo", tipo);
    editor.setString("NumeroQR", "0");
    editor.setString("PosicionTest", "0");
    editor.setString("AciertosTest", "0");

    Global.tipo = editor.getString("Tipo") ?? "No hay dato";

    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => Inicio_ruta()));
  }

  Future<void> obtenerPreferencias() async {
    SharedPreferences editor = await SharedPreferences.getInstance();
    tipoRuta = editor.getString("Tipo") ?? "No hay dato";
    if (tipoRuta != "No hay dato") {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => Inicio_ruta()));
    } else {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.red,
          title: widgetComun(globals.ruta, globals.rute),
          content: Container(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: [
                //own custom button
                GestureDetector(
                    child: Container(
                      width: queryData.size.width / 3,
                      height: 40,
                      decoration: BoxDecoration(
                          color: Colors.greenAccent,
                          borderRadius: BorderRadius.circular(20)),
                      child: Center(
                        child: Text(
                          "MUSEO AL AIRE LIBRE",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black, fontSize: 13),
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      _tipoLocal("libre");
                    }),
                GestureDetector(
                    child: Container(
                      width: queryData.size.width / 3,
                      height: 40,
                      decoration: BoxDecoration(
                          color: Colors.greenAccent,
                          borderRadius: BorderRadius.circular(20)),
                      child: Center(
                        child: Text(
                          "RUTA COMLETA",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      _tipoLocal("completa");
                    }),
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
      ).then((result) => print(result));
    }
  }

  widgetBotonComenzar() {
      return GestureDetector(
          child: Center(
            child: Container(
              //width: queryData.size.width / 2.5,
              height: 125,
              decoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              child: Center(
                //Center Column contents vertically,
                child: widgetComenzar(globals.comenzar, globals.start),
              ),
            ),
          ),
          //showDialog returns a Future and onTap accepts void, which is why you can't directly assign showDialig to onTap, however when you do onTap: () =>  You're simply executing showDialog(...) inside the callback provided by onTap
          onTap: () {
            obtenerPreferencias();

          });

    /*else {
      return GestureDetector(
          child: Center(
            child: Container(
              //width: queryData.size.width / 2.5,
              height: 125,
              decoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              child: Center(
                //Center Column contents vertically,
                child: widgetComenzar(globals.comenzar, globals.start),
              ),
            ),
          ),
          //showDialog returns a Future and onTap accepts void, which is why you can't directly assign showDialig to onTap, however when you do onTap: () =>  You're simply executing showDialog(...) inside the callback provided by onTap
          onTap: () =>
    }*/
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
