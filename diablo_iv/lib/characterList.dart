import 'package:diablo_iv/characterForm.dart';
import 'package:diablo_iv/characterService.dart';
import 'package:flutter/material.dart';
import 'package:diablo_iv/character.dart';
import 'package:google_fonts/google_fonts.dart' as gf;
import 'package:flutter/src/services/asset_manifest.dart' as assetManifest;

class CharacterList extends StatefulWidget {
  @override
  _CharacterListState createState() => _CharacterListState();
}

class _CharacterListState extends State<CharacterList> {
  final CharacterService _characterService = CharacterService();
  late Future<List<Character>> _charactersFuture;

  @override
  void initState() {
    super.initState();
    _loadCharacters();
  }

  void _loadCharacters() {
    setState(() {
      _charactersFuture = _characterService.fetchCharacters();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Personagens', style: gf.GoogleFonts.playfairDisplay(color: Colors.white)),
        backgroundColor: Color(0xFF1A1A1A),
      ),
      body: Container(
        color: Color(0xFF222222),
        child: FutureBuilder<List<Character>>(
          future: _charactersFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Erro ao carregar personagens'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('Nenhum personagem encontrado'));
            } else {
              final characters = snapshot.data!;
              return ListView.builder(
                itemCount: characters.length,
                itemBuilder: (context, index) {
                  final character = characters[index];
                  return _buildCharacterCard(character);
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CharacterForm()),
          ).then((_) {
            _loadCharacters();
          });
        },
        child: Icon(Icons.add),
        backgroundColor: Color(0xFF2C6E49),
      ),
    );
  }

  Widget _buildCharacterCard(Character character) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      color: Color(0xFF333333),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: Color(0xFF444444), width: 2),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(15),
        title: Text(
          character.nome,
          style: gf.GoogleFonts.playfairDisplay(
            color: Colors.orange,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Classe: ${character.classe.toString().split('.').last.capitalize()}',
              style: gf.GoogleFonts.playfairDisplay(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
            _buildFieldWithCheck('Anéis', character.aneis.isNotEmpty),
            _buildFieldWithCheck('Elmo', character.elmo != ''),
            _buildFieldWithCheck('Peitoral', character.peitoral != ''),
            _buildFieldWithCheck('Calça', character.calca != ''),
            _buildFieldWithCheck('Botas', character.botas != ''),
            _buildFieldWithCheck('Amuleto', character.amuleto != ''),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildEditButton(character),
            SizedBox(width: 8),
            _buildDeleteButton(character),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldWithCheck(String label, bool isFilled) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: gf.GoogleFonts.playfairDisplay(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
        if (isFilled)
          Icon(Icons.check_circle, color: Colors.green, size: 18),
      ],
    );
  }

  Widget _buildEditButton(Character character) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CharacterForm(character: character),
          ),
        ).then((_) {
          _loadCharacters();
        });
      },
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Color(0xFF2C6E49),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Color(0xFF1A4B2A), width: 2),
        ),
        child: Icon(Icons.edit, color: Colors.white),
      ),
    );
  }

  Widget _buildDeleteButton(Character character) {
    return GestureDetector(
      onTap: () async {
        await _characterService.deleteCharacter(character.id);
        _loadCharacters();
      },
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Color(0xFF9C1D1D),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Color(0xFF6C1414), width: 2),
        ),
        child: Icon(Icons.delete, color: Colors.white),
      ),
    );
  }
}

extension StringCapitalization on String {
  String capitalize() {
    return this.isNotEmpty ? '${this[0].toUpperCase()}${this.substring(1)}' : this;
  }
}
