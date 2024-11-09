import 'package:diablo_iv/anel.dart';
import 'package:diablo_iv/classe.dart';

class Character {
  int id;
  String nome;
  String elmo;
  String peitoral;
  String calca;
  String botas;
  List<Anel> aneis;
  String amuleto;
  Classe classe;

  Character({
    required this.id,
    required this.nome,
    required this.elmo,
    required this.peitoral,
    required this.calca,
    required this.botas,
    required this.aneis,
    required this.amuleto,
    required this.classe,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
  return Character(
    id: int.parse(json['id'].toString()),
    nome: json['nome'],
    classe: Classe.values.firstWhere((e) => e.toString() == 'Classe.${json['classe']}'),
    elmo: json['elmo'],
    peitoral: json['peitoral'],
    calca: json['calca'],
    botas: json['botas'],
    aneis: (json['aneis'] as List).map((anel) => Anel.fromJson(anel)).toList(),
    amuleto: json['amuleto'],
  );
}


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'elmo': elmo,
      'peitoral': peitoral,
      'calca': calca,
      'botas': botas,
      'aneis': aneis.map((e) => e.toJson()).toList(),
      'amuleto': amuleto,
      'classe': classe.toString().split('.').last,
    };
  }
}
