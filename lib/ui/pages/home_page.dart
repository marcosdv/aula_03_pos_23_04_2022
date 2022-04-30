import 'package:aula_03_pos/datasources/local/editora_helper.dart';
import 'package:aula_03_pos/models/editora.dart';
import 'package:aula_03_pos/ui/pages/cad_editora_page.dart';
import 'package:aula_03_pos/ui/pages/livros_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _editoraHelper = EditoraHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editoras')),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: _abrirTelaCadastro,
      ),
      body: FutureBuilder(
        future: _editoraHelper.getTodos(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const CircularProgressIndicator();
            default:
              if (snapshot.hasError) {
                return Text('Erro: ${snapshot.error}');
              }
              return _criarLista(snapshot.data as List<Editora>);
          }
        },
      ),
    );
  }

  Widget _criarLista(List<Editora> listaDados) {
    return ListView.builder(
      padding: const EdgeInsets.all(4),
      itemCount: listaDados.length,
      itemBuilder: (context, index) {
        return Dismissible(
          key: UniqueKey(),
          direction: DismissDirection.horizontal,
          child: _criarItemLista(listaDados[index]),
          background: Container(
            alignment: const Alignment(-1, 0),
            color: Colors.blue,
            child: const Text('Editar editora',
              style: TextStyle(color: Colors.white),),
          ),
          secondaryBackground: Container(
            alignment: const Alignment(1, 0),
            color: Colors.red,
            child: const Text('Excluir editora',
              style: TextStyle(color: Colors.white),),
          ),
          onDismissed: (DismissDirection direction) {
            if (direction == DismissDirection.startToEnd) {
              _abrirTelaCadastro(editora: listaDados[index]);
            }
            else if (direction == DismissDirection.endToStart) {
              _editoraHelper.apagar(listaDados[index]);
            }
          },
        );
      }
    );
  }

  Widget _criarItemLista(Editora editora) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Text(editora.nome, style: const TextStyle(fontSize: 28),),
            ],
          ),
        ),
      ),
      onTap: () => _abrirListaLivros(editora),
      onLongPress: () => _abrirTelaCadastro(editora: editora),
    );
  }

  void _abrirListaLivros(Editora editora) {
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => LivrosPage(editora)
    ));
  }

  void _abrirTelaCadastro({Editora? editora}) async {
    await Navigator.push(context, MaterialPageRoute(
      builder: (context) => CadEditoraPage(editora: editora,)
    ));

    setState(() { });
  }
}