class Pregunta {
  String _preguntaEs;
  String _preguntaEn;
  String _respuesta1Es;
  String _respuesta2Es;
  String _respuesta3Es;
  String _respuesta1En;
  String _respuesta2En;
  String _respuesta3En;
  String _acierto;

  /*
    ESTA APLICACIÓN HA SIDO DESARROLLADA POR CARLOS DIEZ, RAÚL BLÁZQUEZ, JAVIER MORAL Y JUAN BARROSO
    HA SIDO DESARROLLADA PARA EL PUEBLO DE ÁVILA "EL OSO". CUALQUIER OTRO USO SERA DENUNCIABLE POR LOS CREADORES.
    */

  /*Pregunta(String preguntaEs, String preguntaEn, String respuesta1Es, String respuesta2Es, String respuesta3Es, String respuesta1En, String respuesta2En, String respuesta3En, String acierto){
    this.preguntaEs = preguntaEs;
    this.preguntaEn = , this.respuesta1Es = , this.respuesta2Es = , this.respuesta3Es = , this.respuesta1En = , this.respuesta2En = , this.respuesta3En = , this.acierto = ;
  }*/

  Pregunta(this._preguntaEs, this._preguntaEn, this._respuesta1Es,
      this._respuesta2Es, this._respuesta3Es, this._respuesta1En,
      this._respuesta2En, this._respuesta3En, this._acierto);

  String get acierto => _acierto;

  set acierto(String value) {
    _acierto = value;
  }

  String get respuesta3En => _respuesta3En;

  set respuesta3En(String value) {
    _respuesta3En = value;
  }

  String get respuesta2En => _respuesta2En;

  set respuesta2En(String value) {
    _respuesta2En = value;
  }

  String get respuesta1En => _respuesta1En;

  set respuesta1En(String value) {
    _respuesta1En = value;
  }

  String get respuesta3Es => _respuesta3Es;

  set respuesta3Es(String value) {
    _respuesta3Es = value;
  }

  String get respuesta2Es => _respuesta2Es;

  set respuesta2Es(String value) {
    _respuesta2Es = value;
  }

  String get respuesta1Es => _respuesta1Es;

  set respuesta1Es(String value) {
    _respuesta1Es = value;
  }

  String get preguntaEn => _preguntaEn;

  set preguntaEn(String value) {
    _preguntaEn = value;
  }

  String get preguntaEs => _preguntaEs;

  set preguntaEs(String value) {
    _preguntaEs = value;
  }
}
