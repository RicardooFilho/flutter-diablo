import 'dart:convert';
import 'package:diablo_iv/characterForm.dart';
import 'package:diablo_iv/characterList.dart';
import 'package:diablo_iv/classe.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int totalPersonagens = 0;
  int totalMagos = 0;
  int totalBarbaros = 0;
  int totalNecromantes = 0;
  int totalDruidas = 0;
  int totalRenegados = 0;
  int totalNatispiritos = 0;
  int totalDefinir = 0;

  @override
  void initState() {
    super.initState();
    _fetchDashboardData();
  }

  Future<void> _fetchDashboardData() async {
    final response =
        await http.get(Uri.parse('http://localhost:3000/characters'));

    if (response.statusCode == 200) {
      List<dynamic> personagens = json.decode(response.body);

      setState(() {
        totalPersonagens = personagens.length;

        totalMagos = personagens
            .where((character) => character['classe'] == Classe.mago.toString().split('.').last)
            .length;

        totalBarbaros = personagens
            .where((character) => character['classe'] == Classe.barbaro.toString().split('.').last)
            .length;

        totalDruidas = personagens
            .where((character) => character['classe'] == Classe.druida.toString().split('.').last)
            .length;

        totalNecromantes = personagens
            .where((character) => character['classe'] == Classe.necromante.toString().split('.').last)
            .length;

        totalRenegados = personagens
            .where((character) => character['classe'] == Classe.renegado.toString().split('.').last)
            .length;

        totalNatispiritos = personagens
            .where((character) => character['classe'] == Classe.natispirito.toString().split('.').last)
            .length;

        totalDefinir = personagens
            .where((character) => character['classe'] == Classe.definir.toString().split('.').last)
            .length;
      });
    } else {
      throw Exception('Falha ao carregar dados');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF1A1A1A),
      ),
      drawer: Drawer(
        backgroundColor: Color(0xFF333333),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF1A1A1A),
              ),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.orange, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.dashboard, color: Colors.orange),
              title: Text('Dashboard', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.list, color: Colors.orange),
              title: Text('Ver Personagens', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CharacterList()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.add, color: Colors.orange),
              title: Text('Adicionar Personagem', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CharacterForm()),
                );
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDashboardHeader(),
            SizedBox(height: 20),
            _buildQuickActions(context),
            SizedBox(height: 30),
            Center(child: _buildSummary()),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bem-vindo ao Gerenciador de Personagens e Builds de Diablo IV!',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.orange,
          ),
        ),
        SizedBox(height: 10),
        Text(
          'Aqui você pode adicionar e editar seus personagens, assim como visualizar um resumo dos mesmos.',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildActionButton(
          context,
          Icons.list,
          'Ver Personagens',
          () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CharacterList()),
            );
          },
        ),
        _buildActionButton(
          context,
          Icons.add,
          'Adicionar Personagem',
          () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CharacterForm()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildActionButton(
      BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(0xFF333333),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.orange, size: 40),
            SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummary() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF333333),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Resumo dos Personagens:',
            style: TextStyle(
                color: Colors.orange,
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            'Você tem $totalPersonagens personagens cadastrados.',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          SizedBox(height: 10),
          Text(
            'Total de Magos: $totalMagos',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          SizedBox(height: 10),
          Text(
            'Total de Bárbaros: $totalBarbaros',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          SizedBox(height: 10),
          Text(
            'Total de Necromantes: $totalNecromantes',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          SizedBox(height: 10),
          Text(
            'Total de Druídas: $totalDruidas',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          SizedBox(height: 10),
          Text(
            'Total de Natispirítos: $totalNatispiritos',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          SizedBox(height: 10),
          Text(
            'Total de Renegados: $totalRenegados',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          SizedBox(height: 10),
          Text(
            'Personagens com classe a definir: $totalDefinir',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
