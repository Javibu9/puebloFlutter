class Codigo{
  String nombreEs;
  String nombreEn;
  String textoEs;
  String textoEn;
  String foto;
  String direccion;
  String audioEs;
  String audioEn;

  /*
    ESTA APLICACIÓN HA SIDO DESARROLLADA POR CARLOS DIEZ, RAÚL BLÁZQUEZ, JAVIER MORAL Y JUAN BARROSO
    HA SIDO DESARROLLADA PARA EL PUEBLO DE ÁVILA "EL OSO". CUALQUIER OTRO USO SERA DENUNCIABLE POR LOS CREADORES.
    */

  Codigo({this.nombreEs, this.nombreEn, this.textoEs, this.textoEn,
      this.foto, this.direccion, this.audioEs, this.audioEn});

  factory Codigo.fromJson(Map<String, dynamic> parsedJson){
    return Codigo(
        nombreEs: parsedJson['nombreEs'],
        nombreEn: parsedJson['nombreEn'],
        textoEs: parsedJson['textoEs'],
        textoEn: parsedJson['textoEn'],
        foto: parsedJson['foto'],
        direccion: parsedJson['direccion'],
        audioEs: parsedJson['audioEs'],
        audioEn: parsedJson['audioEn']
    );
  }

  /*String get audioEn => _audioEn;

  set audioEn(String value) {
    _audioEn = value;
  }

  String get audioEs => _audioEs;

  set audioEs(String value) {
    _audioEs = value;
  }

  String get direccion => _direccion;

  set direccion(String value) {
    _direccion = value;
  }

  String get foto => _foto;

  set foto(String value) {
    _foto = value;
  }

  String get textoEn => _textoEn;

  set textoEn(String value) {
    _textoEn = value;
  }

  String get textoEs => _textoEs;

  set textoEs(String value) {
    _textoEs = value;
  }

  String get nombreEn => _nombreEn;

  set nombreEn(String value) {
    _nombreEn = value;
  }

  String get nombreEs => _nombreEs;

  set nombreEs(String value) {
    _nombreEs = value;
  }*/


}