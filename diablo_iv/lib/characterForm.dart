import 'package:diablo_iv/anel.dart';
import 'package:diablo_iv/character.dart';
import 'package:diablo_iv/characterService.dart';
import 'package:diablo_iv/classe.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart' as gf;
import 'package:flutter/src/services/asset_manifest.dart' as assetManifest;

class CharacterForm extends StatefulWidget {
  final Character? character;

  CharacterForm({this.character});

  @override
  _CharacterFormState createState() => _CharacterFormState();
}

class _CharacterFormState extends State<CharacterForm> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _elmoController = TextEditingController();
  final _peitoralController = TextEditingController();
  final _calcaController = TextEditingController();
  final _botasController = TextEditingController();
  final _amuletoController = TextEditingController();
  final List<TextEditingController> _aneisControllers = [];
  final List<TextEditingController> _nivelPoderControllers = [];
  Classe? _classe;
  final CharacterService _characterService = CharacterService();

  @override
  void initState() {
    super.initState();
    if (widget.character != null) {
      _nomeController.text = widget.character!.nome;
      _elmoController.text = widget.character!.elmo;
      _peitoralController.text = widget.character!.peitoral;
      _calcaController.text = widget.character!.calca;
      _botasController.text = widget.character!.botas;
      _amuletoController.text = widget.character!.amuleto;
      _classe = widget.character!.classe;

      for (var anel in widget.character!.aneis) {
        final descricaoController = TextEditingController(text: anel.descricao);
        final nivelPoderController =
            TextEditingController(text: anel.nivelPoder.toString());
        _aneisControllers.add(descricaoController);
        _nivelPoderControllers.add(nivelPoderController);
      }
    } else {
      _classe = Classe.definir;
      _aneisControllers.add(TextEditingController());
      _nivelPoderControllers.add(TextEditingController());
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _elmoController.dispose();
    _peitoralController.dispose();
    _calcaController.dispose();
    _botasController.dispose();
    _amuletoController.dispose();
    for (var controller in _aneisControllers) {
      controller.dispose();
    }
    for (var controller in _nivelPoderControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addAnelField() {
    setState(() {
      _aneisControllers.add(TextEditingController());
      _nivelPoderControllers.add(TextEditingController());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.character == null
              ? 'Adicionar Personagem'
              : 'Editar Personagem',
          style:
              gf.GoogleFonts.playfairDisplay(color: Colors.white, fontSize: 24),
        ),
        backgroundColor: Color(0xFF1A1A1A),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2A2A2A), Color(0xFF1A1A1A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                _buildTextFormField(
                    _nomeController, 'Insira o nome do Personagem', 'Nome'),
                SizedBox(height: 15),
                _buildTextFormField(_elmoController, 'Insira um Elmo', 'Elmo'),
                SizedBox(height: 15),
                _buildTextFormField(
                    _peitoralController, 'Insira um Peitoral', 'Peitoral'),
                SizedBox(height: 15),
                _buildTextFormField(
                    _calcaController, 'Insira um Calça', 'Calça'),
                SizedBox(height: 15),
                _buildTextFormField(
                    _botasController, 'Insira uma Bota', 'Botas'),
                SizedBox(height: 15),
                _buildTextFormField(
                    _amuletoController, 'Insira um Amuleto', 'Amuleto'),
                SizedBox(height: 15),
                _buildDropdownField(),
                SizedBox(height: 15),
                Text('Anéis',
                    style:
                        gf.GoogleFonts.playfairDisplay(color: Colors.orange)),
                SizedBox(height: 10),
                ..._aneisControllers.map((controller) {
                  int index = _aneisControllers.indexOf(controller);
                  return Column(
                    children: [
                      _buildTextFormField(controller, 'Insira um Anel', 'Anel'),
                      SizedBox(height: 10),
                      _buildTextFormField(_nivelPoderControllers[index],
                          'Insira um nível de poder', 'Nível de Poder'),
                      SizedBox(height: 15),
                    ],
                  );
                }).toList(),
                TextButton(
                  onPressed: _addAnelField,
                  child: Text(
                    'Adicionar Anel',
                    style: gf.GoogleFonts.playfairDisplay(color: Colors.white),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      final aneis = _aneisControllers.map((controller) {
                        int index = _aneisControllers.indexOf(controller);
                        return Anel(
                          descricao: controller.text,
                          nivelPoder:
                              int.parse(_nivelPoderControllers[index].text),
                        );
                      }).toList();

                      final character = Character(
                        id: widget.character?.id ??
                            DateTime.now().millisecondsSinceEpoch,
                        nome: _nomeController.text,
                        elmo: _elmoController.text,
                        peitoral: _peitoralController.text,
                        calca: _calcaController.text,
                        botas: _botasController.text,
                        aneis: aneis,
                        amuleto: _amuletoController.text,
                        classe: _classe ?? Classe.definir,
                      );

                      if (widget.character == null) {
                        _characterService.addCharacter(character);
                        _characterService.fetchCharacters();
                      } else {
                        _characterService.updateCharacter(
                            widget.character!.id, character);
                        _characterService.fetchCharacters();
                      }

                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    widget.character == null ? 'Adicionar' : 'Salvar',
                    style: gf.GoogleFonts.playfairDisplay(color: Colors.white),
                  ),
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField(
      TextEditingController controller, String label, String labelTitle) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelTitle,
        hintText: label,
        hintStyle: TextStyle(color: Colors.grey),
        labelStyle: TextStyle(color: Colors.orange),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: Color(0xFF2A2A2A),
      ),
      style: gf.GoogleFonts.playfairDisplay(color: Colors.white),
    );
  }

  Widget _buildDropdownField() {
    return DropdownButtonFormField<Classe>(
      value: _classe,
      decoration: InputDecoration(
        labelText: 'Classe',
        hintText: 'Escolha a classe',
        hintStyle: TextStyle(color: Colors.grey),
        labelStyle: TextStyle(color: Colors.orange),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: Color(0xFF2A2A2A),
      ),
      items: Classe.values.map((classe) {
        return DropdownMenuItem(
          value: classe,
          child: Text(
            _formatClassName(classe),
            style: TextStyle(color: Colors.black),
          ),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _classe = value;
        });
      },
      validator: (value) {
        if (value == null) {
          return 'Classe é obrigatória';
        }
        return null;
      },
      dropdownColor: Color(0xFF333333),
    );
  }

  String _formatClassName(Classe classe) {
    final className = classe.toString().split('.').last;
    return className[0].toUpperCase() +
        className.substring(1).toLowerCase();
  }
}
