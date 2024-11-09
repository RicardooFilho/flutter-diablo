import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:diablo_iv/character.dart';

class CharacterService {
  Future<List<Character>> fetchCharacters() async {
    final response =
        await http.get(Uri.parse('http://localhost:3000/characters'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Character.fromJson(json)).toList();
    } else {
      throw Exception('Falha ao carregar personagens');
    }
  }

  Future<void> addCharacter(Character character) async {
    final tempId = DateTime.now().millisecondsSinceEpoch;

    final response = await http.post(
      Uri.parse('http://localhost:3000/characters'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'id': tempId.toString(),
        'nome': character.nome,
        'classe': character.classe.toString().split('.').last,
        'elmo': character.elmo,
        'peitoral': character.peitoral,
        'calca': character.calca,
        'botas': character.botas,
        'aneis': character.aneis.map((anel) => anel.toJson()).toList(),
        'amuleto': character.amuleto,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Falha ao adicionar personagem');
    }
  }

  Future<void> updateCharacter(int id, Character character) async {
    final response = await http.put(
      Uri.parse('http://localhost:3000/characters/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'nome': character.nome,
        'classe': character.classe.toString().split('.').last,
        'elmo': character.elmo,
        'peitoral': character.peitoral,
        'calca': character.calca,
        'botas': character.botas,
        'aneis': character.aneis.map((anel) => anel.toJson()).toList(),
        'amuleto': character.amuleto,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Falha ao atualizar personagem');
    }
  }

  Future<void> deleteCharacter(int id) async {
    final response = await http.delete(
      Uri.parse('http://localhost:3000/characters/$id'),
    );

    if (response.statusCode != 204 && response.statusCode != 200) {
      throw Exception('Falha ao excluir personagem');
    }
  }
}
